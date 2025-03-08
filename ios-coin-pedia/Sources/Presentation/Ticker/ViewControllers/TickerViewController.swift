//
//  TickerViewController.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit
import RxSwift
import RxCocoa

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
        mainView.headerView.titleLabel.text = "코인"
        mainView.headerView.priceSort.status.accept(.normal)
        mainView.headerView.changeSort.status.accept(.normal)
        mainView.headerView.accPriceSort.status.accept(.dsc)
        
        dump(testMockMarketData)
        print(testMockMarketData[0].price)
        dump(testMockMarketData[0].volatility)
        print(testMockMarketData[0].accPrice)
        
        Observable.just(mockMarketData)
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
    }
    
}
