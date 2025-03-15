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
        let viewWillAppear: ControlEvent<Void>
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
        let presentVC: PublishRelay<BaseViewController>
        let dismissVC: PublishRelay<Void>
        let presentToast: PublishRelay<ToastType>
    }
    
    //MARK: - Private
    private struct Private {
        let infoHeaderTitle = "종목정보"
        let analyzeHeaderTitle = "투자지표"
        let networkErrorCountMax = 3
        let fetchTrigger = PublishRelay<Void>()
        let coin: BehaviorRelay<CoinThumbnail>
        let favoriteHandler: ((Bool) -> ())?
        let coinInfo = PublishRelay<CGMarketsResponse>()
        let networkError = PublishRelay<CGError>()
        let networkErrorInfo = PublishRelay<ErrorModalInfo>()
        let networkErrorCount = BehaviorRelay(value: 0)
        let disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private let priv: Private
    
    //MARK: - Initializer Method
    init(
        coin: CoinThumbnail,
        favoriteHandler: ((Bool) -> ())? = nil
    ) {
        priv = Private(
            coin: BehaviorRelay(value: coin),
            favoriteHandler: favoriteHandler
        )
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
        let presentVC = PublishRelay<BaseViewController>()
        let dismissVC = PublishRelay<Void>()
        let presentToast = PublishRelay<ToastType>()
        
        let networkError = priv.networkError.share(replay: 1)
        
        input.viewWillAppear
            .bind(to: priv.fetchTrigger)
            .disposed(by: priv.disposeBag)
        
        priv.fetchTrigger
            .withLatestFrom(priv.coin)
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
            .map {
                self.priv.favoriteHandler?($0)
                return $0
            }
            .bind(to: isFavorite)
            .disposed(by: priv.disposeBag)
        
        networkError
            .withLatestFrom(priv.networkErrorCount)
            .map { $0 + 1 }
            .bind(to: priv.networkErrorCount)
            .disposed(by: priv.disposeBag)
        
        networkError
            .withUnretained(self)
            .map { owner, error in
                ErrorModalInfo(
                    title: error.title,
                    message: error.message,
                    submitHandler: {
                        owner.priv.fetchTrigger.accept(())
                        
                        let isMax = owner.priv.networkErrorCount.value >= owner.priv.networkErrorCountMax
                        
                        switch isMax {
                        case true:
                            presentToast.accept(.network)
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
            presentVC: presentVC,
            dismissVC: dismissVC,
            presentToast: presentToast
        )
    }
    
}
