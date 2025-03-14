//
//  TickerViewModel.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import Foundation
import RxSwift
import RxCocoa

final class TickerViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let viewWillAppear: ControlEvent<Void>
        let viewDidDisappear: ControlEvent<Void>
        let priceSortTap: ControlEvent<Void>
        let changeSortTap: ControlEvent<Void>
        let accPriceSortTap: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {
        let headerTitle: Observable<String>
        let priceSortStatus: PublishRelay<TickerSortStatus>
        let changeSortStatus: PublishRelay<TickerSortStatus>
        let accPriceSortStatus: PublishRelay<TickerSortStatus>
        let tickers: PublishRelay<[UBTickerResponse]>
        let presentVC: PublishRelay<BaseViewController>
        let dismissVC: PublishRelay<Void>
        let presentToast: PublishRelay<ToastType>
    }
    
    //MARK: - Private
    private struct Private {
        let headerTitle = "코인"
        let fetchCycleSec = 5
        let networkErrorCountMax = 3
        let trigger = PublishRelay<Void>()
        let timerTrigger = PublishRelay<Void>()
        let fetchTrigger = PublishRelay<Void>()
        let sort = BehaviorRelay(value: TickerSort.accPrice)
        let sortStatus = BehaviorRelay(value: TickerSortStatus.dsc)
        let tickers = PublishRelay<[UBTickerResponse]>()
        let networkError = PublishRelay<UBError>()
        let networkErrorInfo = PublishRelay<ErrorModalInfo>()
        let networkErrorCount = BehaviorRelay(value: 0)
        var disposeBag = DisposeBag()
    }
    
    //MARK: - Property
    private var priv = Private()
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let headerTitle = Observable.just(priv.headerTitle)
        let priceSortStatus = PublishRelay<TickerSortStatus>()
        let changeSortStatus = PublishRelay<TickerSortStatus>()
        let accPriceSortStatus = PublishRelay<TickerSortStatus>()
        let tickers = PublishRelay<[UBTickerResponse]>()
        let presentVC = PublishRelay<BaseViewController>()
        let dismissVC = PublishRelay<Void>()
        let presentToast = PublishRelay<ToastType>()
        
        var fetchCycle: Disposable?
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
            .bind(to: priv.timerTrigger)
            .disposed(by: priv.disposeBag)
        
        priv.fetchTrigger
            .flatMapLatest {
                NetworkManager.shared.request(
                    UBRequest.ticker([.KRW]),
                    [UBTickerResponse].self,
                    UBError.self
                )
            }
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, response in
                switch response {
                case .success(let data):
                    dismissVC.accept(())
                    owner.priv.tickers.accept(data)
                case .failure(let error):
                    owner.priv.networkError.accept(error)
                }
            })
            .disposed(by: priv.disposeBag)
        
        input.priceSortTap
            .bind(with: self, onNext: { owner, sort in
                owner.updateSortStatus(with: TickerSort.price)
            })
            .disposed(by: priv.disposeBag)
        
        input.changeSortTap
            .bind(with: self, onNext: { owner, sort in
                owner.updateSortStatus(with: TickerSort.change)
            })
            .disposed(by: priv.disposeBag)
        
        input.accPriceSortTap
            .bind(with: self, onNext: { owner, sort in
                owner.updateSortStatus(with: TickerSort.accPrice)
            })
            .disposed(by: priv.disposeBag)
        
        Observable
            .combineLatest(
                priv.tickers, priv.sort, priv.sortStatus
            )
            .map { self.sorted($0, for: $1, with: $2) }
            .bind(to: tickers)
            .disposed(by: priv.disposeBag)
        
        Observable
            .combineLatest(
                priv.sort, priv.sortStatus
            )
            .bind(with: self, onNext: { owner, info in
                let (sort, sortStatus) = info
                
                switch sort {
                case .price:
                    priceSortStatus.accept(sortStatus)
                    changeSortStatus.accept(.normal)
                    accPriceSortStatus.accept(.normal)
                case .change:
                    priceSortStatus.accept(.normal)
                    changeSortStatus.accept(sortStatus)
                    accPriceSortStatus.accept(.normal)
                case .accPrice:
                    priceSortStatus.accept(.normal)
                    changeSortStatus.accept(.normal)
                    accPriceSortStatus.accept(sortStatus)
                }
            })
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
                ErrorModalInfo(
                    title: error.title,
                    message: error.message,
                    submitHandler: {
                        owner.priv.trigger.accept(())
                        
                        let isMax = owner.priv.networkErrorCount.value >= owner.priv.networkErrorCountMax
                        
                        switch isMax {
                        case true:
                            presentToast.accept(.network)
                        case false:
                            dismissVC.accept(())
                        }
                    },
                    cancelHandler: {
                        fetchCycle?.dispose()
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
            headerTitle: headerTitle,
            priceSortStatus: priceSortStatus,
            changeSortStatus: changeSortStatus,
            accPriceSortStatus: accPriceSortStatus,
            tickers: tickers,
            presentVC: presentVC,
            dismissVC: dismissVC,
            presentToast: presentToast
        )
    }
    
    private func makeFetchCycle() -> Disposable {
        return priv.timerTrigger
            .flatMapLatest({
                Observable<Int>.timer(
                    .seconds(0),
                    period: .seconds(self.priv.fetchCycleSec),
                    scheduler: MainScheduler.instance
                )
            })
            .map { _ in }
            .bind(to: priv.fetchTrigger)
    }
    
    private func updateSortStatus(with inputSort: TickerSort) {
        var sort = TickerSort.accPrice
        var sortStatus = TickerSortStatus.dsc
        
        if inputSort == priv.sort.value {
            if priv.sortStatus.value == .asc {
                sort = .accPrice
                sortStatus = .dsc
            }
            
            if priv.sortStatus.value == .dsc {
                sort = inputSort
                sortStatus = .asc
            }
        } else {
            sort = inputSort
            sortStatus = .dsc
        }
        
        priv.sort.accept(sort)
        priv.sortStatus.accept(sortStatus)
    }
    
    private func sorted(
        _ tickers: [UBTickerResponse],
        for sort: TickerSort,
        with sortStatus: TickerSortStatus
    ) -> [UBTickerResponse] {
        var sorted = [UBTickerResponse]()
        
        switch sort {
        case .price:
            if sortStatus == .asc {
                sorted = tickers.sorted { $0.tradePrice < $1.tradePrice }
            }
            if sortStatus == .dsc {
                sorted = tickers.sorted { $0.tradePrice > $1.tradePrice }
            }
        case .change:
            if sortStatus == .asc {
                sorted = tickers.sorted { $0.signedChangeRate < $1.signedChangeRate }
            }
            if sortStatus == .dsc {
                sorted = tickers.sorted { $0.signedChangeRate > $1.signedChangeRate }
            }
        case .accPrice:
            if sortStatus == .asc {
                sorted = tickers.sorted { $0.accTradePrice24H < $1.accTradePrice24H }
            }
            if sortStatus == .dsc {
                sorted = tickers.sorted { $0.accTradePrice24H > $1.accTradePrice24H }
            }
        }
        
        return sorted
    }
    
}
