//
//  TrendingViewController.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit
import RxSwift
import RxCocoa

final class TrendingViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = TrendingView()
    private let viewModel = TrendingViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - Override Method
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Setup Method
    override func setupBind() {
        mainView.searchBar.placeholder = "검색어를 입력해주세요."
        
        mainView.coinHeader.titleLabel.text = "인기 검색어"
        mainView.coinHeader.detailLabel.text = "02.16 00:30 기준"
        
        Observable.just(mockTrendingCoins)
            .bind(
                to: mainView.coinCollectionView.rx.items(
                    cellIdentifier: TrendingCoinCollectionViewCell.id,
                    cellType: TrendingCoinCollectionViewCell.self
                ),
                curriedArgument: { item, element, cell in
                    cell.setData(element)
                }
            )
            .disposed(by: disposeBag)
        
        mainView.nftHeader.titleLabel.text = "인기 NFT"
        
        Observable.just(mockTrendingNFTs)
            .bind(
                to: mainView.nftCollectionView.rx.items(
                    cellIdentifier: TrendingNftCollectionViewCell.id,
                    cellType: TrendingNftCollectionViewCell.self
                ),
                curriedArgument: { item, element, cell in
                    cell.setData(element)
                }
            )
            .disposed(by: disposeBag)
    }
    
}
