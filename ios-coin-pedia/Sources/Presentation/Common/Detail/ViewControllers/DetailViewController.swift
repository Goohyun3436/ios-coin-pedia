//
//  DetailViewController.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit
import RxSwift

final class DetailViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = DetailView()
    private let viewModel: DetailViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Initializer Method
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: - Override Method
    override func loadView() {
        view = mainView
        navigationItem.titleView = mainView.coinThumbnailView
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: mainView.favoriteButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Setup Method
    override func setupBind() {
        let input = DetailViewModel.Input(
            favoriteTap: mainView.favoriteButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.coinIconImage
            .bind(to: mainView.coinThumbnailView.rx.icon)
            .disposed(by: disposeBag)
        
        output.coinName
            .bind(to: mainView.coinThumbnailView.rx.text)
            .disposed(by: disposeBag)
        
        output.isFavorite
            .bind(to: mainView.favoriteButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.currentPrice
            .bind(to: mainView.priceLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.volatility
            .bind(with: self, onNext: { owner, volatility in
                owner.mainView.volatilityView.setData(volatility)
            })
            .disposed(by: disposeBag)
        
        output.chartInfo
            .bind(with: self, onNext: { owner, chartInfo in
                owner.mainView.setData(chartInfo)
            })
            .disposed(by: disposeBag)
        
        output.updateTime
            .bind(to: mainView.updateTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.infoHeaderTitle
            .bind(to: mainView.infoHeader.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.info
            .bind(with: self, onNext: { owner, info in
                owner.mainView.infoView.high24H.setData(info.high24H)
                owner.mainView.infoView.low24H.setData(info.low24H)
                owner.mainView.infoView.ath.setData(info.ath)
                owner.mainView.infoView.atl.setData(info.atl)
            })
            .disposed(by: disposeBag)
        
        output.analyzeHeaderTitle
            .bind(to: mainView.analyzeHeader.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.analyze
            .bind(with: self, onNext: { owner, info in
                owner.mainView.analyzeView.marketCap.setData(info.marketCap)
                owner.mainView.analyzeView.fdv.setData(info.fdv)
                owner.mainView.analyzeView.totalVolume.setData(info.totalVolume)
            })
            .disposed(by: disposeBag)
        
        output.alert
            .bind(with: self, onNext: { owner, alert in
                owner.presentAlert(alert)
            })
            .disposed(by: disposeBag)
    }
    
}
