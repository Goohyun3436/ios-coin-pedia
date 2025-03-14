//
//  TrendingViewController.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit
import RxSwift
import RxGesture

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
        let input = TrendingViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            viewDidDisappear: rx.viewDidDisappear,
            mainViewTapNSwipeDown: mainView.rx.anyGesture(
                .tap(configuration: { rec, _ in rec.cancelsTouchesInView = false }),
                .swipe(direction: .down)
            ),
            searchText: mainView.searchBar.rx.text,
            searchTap: mainView.searchBar.rx.searchButtonClicked,
            coinTap: mainView.coinCollectionView.rx.modelSelected(CGCoinsInfo.self)
        )
        let output = viewModel.transform(input: input)
        
        output.searchBarPlaceholder
            .bind(to: mainView.searchBar.rx.placeholder)
            .disposed(by: disposeBag)
        
        output.coinHeaderTitle
            .bind(to: mainView.coinHeader.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.nftHeaderTitle
            .bind(to: mainView.nftHeader.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.dismissKeyboard
            .bind(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        output.searchText
            .bind(to: mainView.searchBar.rx.text)
            .disposed(by: disposeBag)
        
        output.fetchedDatetime
            .bind(to: mainView.coinHeader.detailLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.coins
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
        
        output.nfts
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
        
        output.alert
            .bind(with: self, onNext: { owner, alert in
                owner.presentAlert(alert)
            })
            .disposed(by: disposeBag)
        
        output.presentVC
            .bind(with: self, onNext: { owner, vc in
                owner.presentVC(vc)
            })
            .disposed(by: disposeBag)
        
        output.dismissVC
            .bind(with: self, onNext: { owner, _ in
                owner.dismissVC()
            })
            .disposed(by: disposeBag)
        
        output.pushVC
            .bind(with: self, onNext: { owner, vc in
                owner.pushVC(vc)
            })
            .disposed(by: disposeBag)
    }
    
}
