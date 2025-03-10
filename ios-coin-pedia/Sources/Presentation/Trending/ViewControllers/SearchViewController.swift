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
        
        mainView.searchBar.placeholder = "검색어를 입력해주세요."
        mainView.searchBar.text = "Bitcoin"
        mainView.segmentControl.setSegment(titles: ["코인", "NFT", "거래소"])
        mainView.segmentControl.selectedSegmentIndex = 0
        
        mainView.segmentControl.rx.selectedSegmentIndex
            .bind(to: mainView.segmentControl.rx.selectedSegmentIndex)
            .disposed(by: disposeBag)
        
        Observable.just(mockSearchCoin)
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
    }
    
}
