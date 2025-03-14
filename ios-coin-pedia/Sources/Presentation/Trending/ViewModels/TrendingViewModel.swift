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
        let presentVC: PublishRelay<BaseViewController>
        let dismissVC: PublishRelay<Void>
        let pushVC: PublishRelay<BaseViewController>
    }
    
    //MARK: - Private
    private struct Private {
        let searchBarPlaceholder = "검색어를 입력해주세요."
        let coinHeaderTitle = "인기 검색어"
        let nftHeaderTitle = "인기 NFT"
        let fetchedDatetimeFormat = "MM.dd HH:mm 기준"
        let fetchCycleSec: TimeInterval = 60 * 10
        let coinElementCount = 14
        let nftElementCount = 7
        let networkErrorCountMax = 3
        let trigger = PublishRelay<Void>()
        let timerTrigger = PublishRelay<Void>()
        let fetchTrigger = PublishRelay<Void>()
        let searchError = PublishRelay<SearchError>()
        let networkError = PublishRelay<CGError>()
        let networkErrorInfo = PublishRelay<NetworkModalInfo>()
        let networkErrorCount = BehaviorRelay(value: 0)
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
        let presentVC = PublishRelay<BaseViewController>()
        let dismissVC = PublishRelay<Void>()
        let pushVC = PublishRelay<BaseViewController>()
        
        var fetchCycle: Disposable?
        let fetchTrigger = priv.fetchTrigger.share(replay: 1)
        let searchTap = input.searchTap.share(replay: 1)
        let networkError = priv.networkError.share(replay: 1)
        
        input.viewWillAppear
            .bind(to: priv.trigger)
            .disposed(by: priv.disposeBag)
        
        input.viewDidDisappear
            .bind(with: self, onNext: { owner, _ in
                fetchCycle?.dispose()
            })
            .disposed(by: priv.disposeBag)
        
        priv.trigger
            .map { fetchCycle = self.makeFetchCycle() }
            .bind(to: priv.timerTrigger, priv.fetchTrigger)
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
            .map {
                DateManager.shared.getCurrentTimeTenMin(
                    dateFormat: self.priv.fetchedDatetimeFormat
                )
            }
            .bind(to: fetchedDatetime)
            .disposed(by: priv.disposeBag)
        
        input.mainViewTapNSwipeDown
            .when(.recognized)
            .map { _ in }
            .bind(to: dismissKeyboard)
            .disposed(by: priv.disposeBag)
        
        searchTap
            .bind(to: dismissKeyboard)
            .disposed(by: priv.disposeBag)
        
        searchTap
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
        
        networkError
            .bind(with: self, onNext: { owner, _ in
                fetchCycle?.dispose()
            })
            .disposed(by: priv.disposeBag)
        
        networkError
            .withLatestFrom(priv.networkErrorCount)
            .map { $0 + 1 }
            .bind(to: priv.networkErrorCount)
            .disposed(by: priv.disposeBag)
        
        networkError
            .withUnretained(self)
            .map { owner, error in
                NetworkModalInfo(
                    title: error.title,
                    message: error.message,
                    submitHandler: {
                        owner.priv.trigger.accept(())
                        
                        let isMax = owner.priv.networkErrorCount.value >= owner.priv.networkErrorCountMax
                        
                        switch isMax {
                        case true:
                            print("Toast Message")
                        case false:
                            dismissVC.accept(())
                        }
                    },
                    cancelHandler: {
                        dismissVC.accept(())
                    }
                )
            }
            .bind(to: priv.networkErrorInfo)
            .disposed(by: priv.disposeBag)
        
        priv.networkErrorInfo
            .map {
                let vc = ModalViewController(viewModel: ModalViewModel(info: $0))
                vc.modalPresentationStyle = .overFullScreen
                return vc
            }
            .bind(to: presentVC)
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
            presentVC: presentVC,
            dismissVC: dismissVC,
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
    
}
