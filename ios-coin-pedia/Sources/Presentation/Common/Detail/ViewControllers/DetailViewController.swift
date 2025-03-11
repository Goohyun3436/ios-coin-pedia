//
//  DetailViewController.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

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
        Observable.just("url")
            .bind(to: mainView.coinThumbnailView.rx.icon)
            .disposed(by: disposeBag)
        
        Observable.just("Bitcoin")
            .bind(to: mainView.coinThumbnailView.rx.text)
            .disposed(by: disposeBag)
        
        mainView.priceLabel.text = "₩140,375,094"
        
        mainView.volatilityView.setData(VolatilityInfo(type: .percentage, percentage: 88.88))
        
        mainView.updateTimeLabel.text = "2/15 18:00:45 업데이트"
        
        mainView.infoHeader.titleLabel.text = "종목정보"
        
        mainView.infoView.high24H.titleLabel.text = "24시간 고가"
        mainView.infoView.high24H.priceLabel.text = "₩140,375,094"
        mainView.infoView.low24H.titleLabel.text = "24시간 저가"
        mainView.infoView.low24H.priceLabel.text = "₩140,375,094"
        mainView.infoView.ath.titleLabel.text = "역대 최고가"
        mainView.infoView.ath.priceLabel.text = "₩140,375,094"
        mainView.infoView.ath.subLabel.text = "25년 1월 20일"
        mainView.infoView.atl.titleLabel.text = "역대 최저가"
        mainView.infoView.atl.priceLabel.text = "₩140,375,094"
        mainView.infoView.atl.subLabel.text = "25년 1월 20일"
        
        mainView.analyzeHeader.titleLabel.text = "투자지표"
        
        mainView.analyzeView.marketCap.titleLabel.text = "시가총액"
        mainView.analyzeView.marketCap.priceLabel.text = "₩140,375,094,534,545,345,456"
        mainView.analyzeView.fdv.titleLabel.text = "완전 희석 가치(FDV)"
        mainView.analyzeView.fdv.priceLabel.text = "₩140,375,094,534,545,345,456"
        mainView.analyzeView.totalVolume.titleLabel.text = "총 거래량"
        mainView.analyzeView.totalVolume.priceLabel.text = "₩140,375,094,534,545,345,456"
    }
    
}
