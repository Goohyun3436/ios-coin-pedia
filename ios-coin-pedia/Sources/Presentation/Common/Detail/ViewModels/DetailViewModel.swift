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
    }
    
    //MARK: - Private
    private struct Private {
        let coin: CoinThumbnail
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
        
        return Output(
            coinIconImage: coinIconImage,
            coinName: coinName,
            isFavorite: isFavorite
        )
    }
    
}
