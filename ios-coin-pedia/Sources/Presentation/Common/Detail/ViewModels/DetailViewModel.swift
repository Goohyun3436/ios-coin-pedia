//
//  DetailViewModel.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let favoriteTap: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {
        let coinIconImage: Observable<String>
        let coinName: Observable<String>
        let isFavorite: BehaviorRelay<Bool>
        let currentPrice: PublishRelay<String>
        let volatility: PublishRelay<VolatilityInfo>
        let chartInfo: PublishRelay<CoinChartInfo>
        let updateTime: PublishRelay<String>
        let infoHeaderTitle: Observable<String>
        let info: PublishRelay<CoinInfo>
        let analyzeHeaderTitle: Observable<String>
        let analyze: PublishRelay<CoinAnalyze>
        let alert: PublishRelay<AlertInfo>
    }
    
    //MARK: - Private
    private struct Private {
        let infoHeaderTitle = "종목정보"
        let analyzeHeaderTitle = "투자지표"
        let coin: BehaviorRelay<CoinThumbnail>
        let coinInfo = PublishRelay<CGMarketsResponse>()
        let networkError = PublishRelay<CGError>()
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv: Private
    
    //MARK: - Initializer Method
    init(coin: CoinThumbnail) {
        priv = Private(coin: BehaviorRelay(value: coin))
    }
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let coinIconImage = Observable.just(priv.coin.value.thumb)
        let coinName = Observable.just(priv.coin.value.name)
        let isFavorite = BehaviorRelay(value: priv.coin.value.isFavorite)
        let currentPrice = PublishRelay<String>()
        let volatility = PublishRelay<VolatilityInfo>()
        let chartInfo = PublishRelay<CoinChartInfo>()
        let updateTime = PublishRelay<String>()
        let infoHeaderTitle = Observable.just(priv.infoHeaderTitle)
        let info = PublishRelay<CoinInfo>()
        let analyzeHeaderTitle = Observable.just(priv.analyzeHeaderTitle)
        let analyze = PublishRelay<CoinAnalyze>()
        let alert = PublishRelay<AlertInfo>()
        
        priv.coin
            .debug("fetch")
            .flatMapLatest {
                NetworkManager.shared.request(
                    CGRequest.markets([.krw], [$0.id]),
                    [CGMarketsResponse].self,
                    CGError.self
                )
            }
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, response in
                switch response {
                case .success(let data):
                    guard let coin = data.first else { return }
                    owner.priv.coinInfo.accept(coin)
                case .failure(let error):
                    owner.priv.networkError.accept(error)
                }
            })
            .disposed(by: priv.disposeBag)
        
        priv.coinInfo
            .bind(with: self, onNext: { owner, coin in
                currentPrice.accept(coin.currentPriceStr)
                volatility.accept(coin.volatility)
                chartInfo.accept(coin.chartInfo)
                updateTime.accept(coin.lastUpdatedStr)
                info.accept(coin.info)
                analyze.accept(coin.analyze)
            })
            .disposed(by: priv.disposeBag)
        
        input.favoriteTap
            .debug("favoriteTap")
            .withLatestFrom(priv.coin)
            .map {
                let isFavorite = UserStaticStorage.favoriteIds.contains($0.id)
                
                switch isFavorite {
                case true:
                    UserStorage.shared.deleteFavorite(coinId: $0.id)
                case false:
                    UserStorage.shared.addFavorite(coin: $0)
                }
                
                return !isFavorite
            }
            .bind(to: isFavorite)
            .disposed(by: priv.disposeBag)
        
        priv.networkError
            .map { AlertInfo(title: $0.title, message: $0.message) }
            .bind(to: alert)
            .disposed(by: priv.disposeBag)
        
        return Output(
            coinIconImage: coinIconImage,
            coinName: coinName,
            isFavorite: isFavorite,
            currentPrice: currentPrice,
            volatility: volatility,
            chartInfo: chartInfo,
            updateTime: updateTime,
            infoHeaderTitle: infoHeaderTitle,
            info: info,
            analyzeHeaderTitle: analyzeHeaderTitle,
            analyze: analyze,
            alert: alert
        )
    }
    
}
