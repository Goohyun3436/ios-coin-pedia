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
    struct Input {}
    
    //MARK: - Output
    struct Output {
        let coinIconImage: Observable<String>
        let coinName: Observable<String>
        let isFavorite: BehaviorRelay<Bool>
        let currentPrice: PublishRelay<String>
        let volatility: PublishRelay<VolatilityInfo>
        let chartInfo: PublishRelay<CoinChartInfo>
        let updateTime: PublishRelay<String>
    }
    
    //MARK: - Private
    private struct Private {
//        let infoHeaderTitle
        let coin: CoinThumbnail
        let coinInfo = PublishRelay<CGMarketsResponse>()
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv: Private
    
    //MARK: - Initializer Method
    init(coin: CoinThumbnail) {
        priv = Private(coin: coin)
    }
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let coinIconImage = Observable.just(priv.coin.thumb)
        let coinName = Observable.just(priv.coin.name)
        let isFavorite = BehaviorRelay(value: priv.coin.isFavorite)
        let currentPrice = PublishRelay<String>()
        let volatility = PublishRelay<VolatilityInfo>()
        let chartInfo = PublishRelay<CoinChartInfo>()
        let updateTime = PublishRelay<String>()
        
        Observable.just(priv.coin.id)
            .debug("fetch")
            .flatMapLatest {
                NetworkManager.shared.request(
                    CGRequest.markets([.krw], [$0]),
                    [CGMarketsResponse].self,
                    CGError.self
                )
            }
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, response in
                switch response {
                case .success(let data):
                    guard let coin = data.first else {
                        // error
                        return
                    }
                    owner.priv.coinInfo.accept(coin)
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: priv.disposeBag)
        
        priv.coinInfo
            .bind(with: self, onNext: { owner, coin in
                currentPrice.accept(coin.currentPriceStr)
                volatility.accept(coin.volatility)
                chartInfo.accept(coin.chartInfo)
                updateTime.accept(coin.lastUpdatedStr)
            })
            .disposed(by: priv.disposeBag)
        
        return Output(
            coinIconImage: coinIconImage,
            coinName: coinName,
            isFavorite: isFavorite,
            currentPrice: currentPrice,
            volatility: volatility,
            chartInfo: chartInfo,
            updateTime: updateTime
        )
    }
    
}
