//
//  SearchViewModel.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let screenWidth: CGFloat
        let searchTap: ControlEvent<Void>
        let searchText: ControlProperty<String?>
        let segmentTap: ControlProperty<Int>
        let segmentSwipe: ControlEvent<Void>
        let scrollOffset: ControlProperty<CGPoint>
        let coinTap: ControlEvent<CGSearchCoinInfo>
    }
    
    //MARK: - Output
    struct Output {
        let searchBarPlaceholder: Observable<String>
        let segmentTitles: Observable<[String]>
        let dismissKeyboard: PublishRelay<Void>
        let selectedSegmentIndex: BehaviorRelay<Int>
        let scrollOffset: PublishRelay<CGPoint>
        let searchText: BehaviorRelay<String>
        let coins: PublishRelay<[CGSearchCoinInfo]>
        let alert: PublishRelay<AlertInfo>
        let pushVC: PublishRelay<BaseViewController>
    }
    
    //MARK: - Private
    private struct Private {
        let searchBarPlaceholder = "검색어를 입력해주세요."
        let searchTypes = CGSearchType.allCases
        let initialSelectedSegmentIndex = 0
        let query: BehaviorRelay<String>
        let fetchTrigger = PublishRelay<String>()
        let searchError = PublishRelay<SearchError>()
        let networkError = PublishRelay<CGError>()
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv: Private
    
    //MARK: - Initializer Method
    init(query: String) {
        priv = Private(query: BehaviorRelay(value: query))
    }
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let searchBarPlaceholder = Observable.just(priv.searchBarPlaceholder)
        let searchText = BehaviorRelay(value: priv.query.value)
        let segmentTitles = Observable.just(priv.searchTypes.map { $0.rawValue })
        let dismissKeyboard = PublishRelay<Void>()
        let selectedSegmentIndex = BehaviorRelay(value: priv.initialSelectedSegmentIndex)
        let scrollOffset = PublishRelay<CGPoint>()
        let coins = PublishRelay<[CGSearchCoinInfo]>()
        let alert = PublishRelay<AlertInfo>()
        let pushVC = PublishRelay<BaseViewController>()
        
        let query = priv.query.share(replay: 1)
        let segmentTap = input.segmentTap.share(replay: 1)
        let searchTap = input.searchTap.share(replay: 1)
        
        priv.fetchTrigger
            .flatMapLatest {
                NetworkManager.shared.request(
                    CGRequest.search($0),
                    CGSearchResponse.self,
                    CGError.self
                )
            }
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, response in
                switch response {
                case .success(let data):
                    coins.accept(data.coins)
                case .failure(let error):
                    owner.priv.networkError.accept(error)
                }
            })
            .disposed(by: priv.disposeBag)
        
        query
            .bind(to: searchText)
            .disposed(by: priv.disposeBag)
        
        query
            .bind(to: priv.fetchTrigger)
            .disposed(by: priv.disposeBag)
        
        searchTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText.orEmpty)
            .distinctUntilChanged()
            .flatMap { SearchError.validation($0) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let query):
                    owner.priv.query.accept(query)
                case .failure(let error):
                    owner.priv.searchError.accept(error)
                }
            }
            .disposed(by: priv.disposeBag)
        
        searchTap
            .map { _ in }
            .bind(to: dismissKeyboard)
            .disposed(by: priv.disposeBag)
        
        segmentTap
            .filter { $0 != -1 }
            .bind(to: selectedSegmentIndex)
            .disposed(by: priv.disposeBag)
        
        segmentTap
            .filter { $0 != -1 }
            .map { self.getCurrentOffset(input.screenWidth, $0) }
            .bind(to: scrollOffset)
            .disposed(by: priv.disposeBag)
        
        input.segmentSwipe
            .withLatestFrom(input.scrollOffset)
            .map { self.getCurrentPage(input.screenWidth, $0.x) }
            .bind(to: selectedSegmentIndex)
            .disposed(by: priv.disposeBag)
        
        input.coinTap
            .map {
                DetailViewController(
                    viewModel: DetailViewModel(
                        coin: CoinThumbnail(
                            id: $0.id,
                            name: $0.name,
                            thumb: $0.thumb,
                            isFavorite: $0.isFavorite
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
            segmentTitles: segmentTitles,
            dismissKeyboard: dismissKeyboard,
            selectedSegmentIndex: selectedSegmentIndex,
            scrollOffset: scrollOffset,
            searchText: searchText,
            coins: coins,
            alert: alert,
            pushVC: pushVC
        )
    }
    
    private func getCurrentPage(
        _ pageWidth: CGFloat,
        _ offsetX: CGFloat
    ) -> Int {
        let page = floor((offsetX - pageWidth / 2) / pageWidth) + 1
        return Int(page)
    }
    
    private func getCurrentOffset(
        _ pageWidth: CGFloat,
        _ page: Int
    ) -> CGPoint {
        var currentOffset = CGPoint(x: 0, y: 0)
        currentOffset.x = pageWidth * CGFloat(page)
        return currentOffset
    }
    
}
