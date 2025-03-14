//
//  TickerViewController.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit
import RxSwift

final class TickerViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = TickerView()
    private let viewModel = TickerViewModel()
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
        let input = TickerViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            viewDidDisappear: rx.viewDidDisappear,
            priceSortTap: mainView.headerView.priceSort.rx.tap,
            changeSortTap: mainView.headerView.changeSort.rx.tap,
            accPriceSortTap: mainView.headerView.accPriceSort.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        mainView.headerView.priceSort.status.accept(.normal)
        mainView.headerView.changeSort.status.accept(.normal)
        mainView.headerView.accPriceSort.status.accept(.dsc)
        
        output.headerTitle
            .bind(to: mainView.headerView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.priceSortStatus
            .bind(to: mainView.headerView.priceSort.status)
            .disposed(by: disposeBag)
        
        output.changeSortStatus
            .bind(to: mainView.headerView.changeSort.status)
            .disposed(by: disposeBag)
        
        output.accPriceSortStatus
            .bind(to: mainView.headerView.accPriceSort.status)
            .disposed(by: disposeBag)
        
        output.tickers
            .bind(
                to: mainView.tableView.rx.items(
                    cellIdentifier: TickerTableViewCell.id,
                    cellType: TickerTableViewCell.self
                ),
                curriedArgument: { row, element, cell in
                    cell.setData(element)
                }
            )
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
    }
    
}
