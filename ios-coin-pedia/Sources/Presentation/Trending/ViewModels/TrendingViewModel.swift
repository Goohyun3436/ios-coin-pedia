//
//  TrendingViewModel.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxGesture

final class TrendingViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let viewWillAppear: ControlEvent<Void>
        let viewDidDisappear: ControlEvent<Void>
        let mainViewTapNSwipeDown: ControlEvent<RxGestureRecognizer>
        let searchText: ControlProperty<String?>
        let searchTap: ControlEvent<Void>
        let coinTap: ControlEvent<CGCoinsInfo>
    }
    
    //MARK: - Output
    struct Output {
        let searchBarPlaceholder: Observable<String>
        let coinHeaderTitle: Observable<String>
        let nftHeaderTitle: Observable<String>
        let dismissKeyboard: PublishRelay<Void>
        let searchText: PublishRelay<String>
        let fetchedDatetime: PublishRelay<String>
        let coins: PublishRelay<[CGCoinsInfo]>
        let nfts: PublishRelay<[CGNftInfo]>
        let alert: PublishRelay<AlertInfo>
        let pushVC: PublishRelay<BaseViewController>
    }
    
    //MARK: - Private
    private struct Private {
        let searchBarPlaceholder = "검색어를 입력해주세요."
        let coinHeaderTitle = "인기 검색어"
        let nftHeaderTitle = "인기 NFT"
        let fetchedDatetimeFormat = "MM.dd HH:mm 기준"
        let fetchCycleSec: TimeInterval = 60 * 10
        let timerTrigger = PublishRelay<Void>()
        let fetchTrigger = PublishRelay<Void>()
        let coinElementCount = 14
        let nftElementCount = 7
        let searchError = PublishRelay<SearchError>()
        let networkError = PublishRelay<CGError>()
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv = Private()
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let searchBarPlaceholder = Observable.just(priv.searchBarPlaceholder)
        let coinHeaderTitle = Observable.just(priv.coinHeaderTitle)
        let nftHeaderTitle = Observable.just(priv.nftHeaderTitle)
        let dismissKeyboard = PublishRelay<Void>()
        let searchText = PublishRelay<String>()
        let fetchedDatetime = PublishRelay<String>()
        let coins = PublishRelay<[CGCoinsInfo]>()
        let nfts = PublishRelay<[CGNftInfo]>()
        let alert = PublishRelay<AlertInfo>()
        let pushVC = PublishRelay<BaseViewController>()
        
        var fetchCycle: Disposable?
        let fetchTrigger = priv.fetchTrigger.share(replay: 1)
        
        input.viewWillAppear
            .map { fetchCycle = self.makeFetchCycle() }
            .bind(to: priv.timerTrigger, priv.fetchTrigger)
            .disposed(by: priv.disposeBag)
        
        input.viewDidDisappear
            .bind(with: self, onNext: { owner, _ in
                fetchCycle?.dispose()
            })
            .disposed(by: priv.disposeBag)
        
        fetchTrigger
            .flatMapLatest {
                NetworkManager.shared.request(
                    CGRequest.trending,
                    CGTrendingResponse.self,
                    CGError.self
                )
            }
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, response in
                switch response {
                case .success(var data):
                    data = owner.postProcessing(data)
                    coins.accept(data.coins)
                    nfts.accept(data.nfts)
                case .failure(let error):
                    owner.priv.networkError.accept(error)
                }
            })
            .disposed(by: priv.disposeBag)
        
        fetchTrigger
            .map { self.getCurrentTime() }
            .bind(to: fetchedDatetime)
            .disposed(by: priv.disposeBag)
        
        input.mainViewTapNSwipeDown
            .when(.recognized)
            .map { _ in }
            .bind(to: dismissKeyboard)
            .disposed(by: priv.disposeBag)
        
        input.searchTap
            .withLatestFrom(input.searchText.orEmpty)
            .flatMap { SearchError.validation($0) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let query):
                    searchText.accept(query)
                    pushVC.accept(SearchViewController(
                        viewModel: SearchViewModel(query: query)
                    ))
                case .failure(let error):
                    owner.priv.searchError.accept(error)
                }
            }
            .disposed(by: priv.disposeBag)
        
        input.coinTap
            .map {
                DetailViewController(
                    viewModel: DetailViewModel(
                        coin: CoinThumbnail(
                            id: $0.item.id,
                            name: $0.item.name,
                            thumb: $0.item.thumb,
                            isFavorite: $0.item.isFavorite
                        )
                    )
                )
            }
            .bind(to: pushVC)
            .disposed(by: priv.disposeBag)
        
        priv.searchError
            .map { AlertInfo(title: $0.title, message: $0.message) }
            .bind(to: alert)
            .disposed(by: priv.disposeBag)
        
        priv.networkError
            .map { AlertInfo(title: $0.title, message: $0.message) }
            .bind(to: alert)
            .disposed(by: priv.disposeBag)
        
        return Output(
            searchBarPlaceholder: searchBarPlaceholder,
            coinHeaderTitle: coinHeaderTitle,
            nftHeaderTitle: nftHeaderTitle,
            dismissKeyboard: dismissKeyboard,
            searchText: searchText,
            fetchedDatetime: fetchedDatetime,
            coins: coins,
            nfts: nfts,
            alert: alert,
            pushVC: pushVC
        )
    }
    
    private func makeFetchCycle() -> Disposable {
        return priv.timerTrigger
            .flatMapLatest({
                Observable<Int>.interval(
                    .seconds(60),
                    scheduler: MainScheduler.instance
                )
            })
            .map { _ in
                let todayUnix = Date().timeIntervalSince1970
                let remainSec = todayUnix / self.priv.fetchCycleSec
                let isTimeToFetch = floor(remainSec * 10) / 10 == Double(Int(remainSec))
                return isTimeToFetch
            }
            .filter { $0 == true }
            .map { _ in }
            .bind(to: priv.fetchTrigger)
    }
    
    private func postProcessing(_ data: CGTrendingResponse) -> CGTrendingResponse {
        var result = data
        
        result.coins = Array(data.coins.prefix(priv.coinElementCount))
        result.nfts = Array(data.nfts.prefix(priv.nftElementCount))
        
        return result
    }
    
    private func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = priv.fetchedDatetimeFormat
        var dateStr = formatter.string(from: Date())
        
        //refactor point: 화면 첫 진입 시, MN분 -> M0분 으로 교체 필요
        var dateArray = Array(dateStr)
        dateArray[10] = "0"
        dateStr = String(dateArray)
        
        return dateStr
    }
    
}
