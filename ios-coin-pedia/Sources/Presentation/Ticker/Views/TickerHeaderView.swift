//
//  TickerHeaderView.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/9/25.
//

import UIKit
import SnapKit

final class TickerHeaderView: BaseView {
    
    //MARK: - UI Property
    let titleLabel = AppLabel(.title3)
    let priceSort = TickerSortButton(.price)
    let changeSort = TickerSortButton(.change)
    let accPriceSort = TickerSortButton(.acc_price)
    
    override func setupUI() {
        [titleLabel, priceSort, changeSort, accPriceSort].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let padding: CGFloat = 16
        let columnWidthRates: [CGFloat] = [0.3, 0.25, 0.2, 0.25]
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().offset(padding)
            make.width.equalToSuperview().multipliedBy(columnWidthRates[0]).offset(-padding)
        }
        
        priceSort.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing)
            make.width.equalToSuperview().multipliedBy(columnWidthRates[1])
        }
        
        changeSort.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(priceSort.snp.trailing)
            make.width.equalToSuperview().multipliedBy(columnWidthRates[2])
        }
        
        accPriceSort.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(changeSort.snp.trailing)
            make.trailing.equalToSuperview().inset(padding)
            make.width.equalToSuperview().multipliedBy(columnWidthRates[3]).offset(-padding)
        }
    }
    
    override func setupAttributes() {
        backgroundColor = AppColor.lightGray.value
    }
    
}
