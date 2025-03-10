//
//  SearchViewController.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = SearchView()
    private let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Initializer Method
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: - Override Method
    override func loadView() {
        view = mainView
        navigationItem.titleView = mainView.searchBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Setup Method
    override func setupBind() {
        let input = SearchViewModel.Input(
            screenWidth: UIScreen.main.bounds.width,
            searchTap: mainView.searchBar.rx.searchButtonClicked,
            searchText: mainView.searchBar.rx.text,
            segmentTap: mainView.segmentControl.rx.selectedSegmentIndex,
            segmentSwipe: mainView.scrollView.rx.didEndDecelerating,
            scrollOffset: mainView.scrollView.rx.contentOffset,
            coinTap: mainView.coinCollectionView.rx.modelSelected(CGSearchCoinInfo.self)
        )
        let output = viewModel.transform(input: input)
        
        output.searchBarPlaceholder
            .bind(to: mainView.searchBar.rx.placeholder)
            .disposed(by: disposeBag)
        
        output.segmentTitles
            .bind(with: self, onNext: { owner, titles in
                owner.mainView.segmentControl.setSegment(titles: titles)
            })
            .disposed(by: disposeBag)
        
        output.dismissKeyboard
            .bind(with: self, onNext: { owner, _ in
                owner.navigationItem.titleView?.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        output.selectedSegmentIndex
            .bind(to: mainView.segmentControl.rx.selectedSegmentIndex)
            .disposed(by: disposeBag)
        
        output.scrollOffset
            .bind(to: mainView.scrollView.rx.contentOffset)
            .disposed(by: disposeBag)
        
        output.searchText
            .bind(to: mainView.searchBar.rx.text)
            .disposed(by: disposeBag)
        
        output.coins
            .bind(
                to: mainView.coinCollectionView.rx.items(
                    cellIdentifier: SearchCollectionViewCell.id,
                    cellType: SearchCollectionViewCell.self
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
        
        output.pushVC
            .bind(with: self, onNext: { owner, vc in
                owner.pushVC(vc)
            })
            .disposed(by: disposeBag)
    }
    
}
