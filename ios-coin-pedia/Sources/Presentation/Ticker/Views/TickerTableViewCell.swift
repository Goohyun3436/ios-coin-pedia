//
//  TickerTableViewCell.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/9/25.
//

import UIKit
import SnapKit

final class TickerTableViewCell: BaseTableViewCell {
    
    //MARK: - UI Property
    private let titleLabel = AppLabel(.text1)
    private let priceLabel = AppLabel(.text2)
    private let volatilityView = VolatilityTextView()
    private let accPriceLabel = AppLabel(.text2)
    
    //MARK: - Property
    static let id = "TickerTableViewCell"
    
    //MARK: - Setup Method
    func setData(_ info: UBTickerResponse) {
        titleLabel.text = info.title
        priceLabel.text = info.price
        volatilityView.setData(info.volatility)
        accPriceLabel.text = info.accPrice
    }
    
    override func setupUI() {
        [titleLabel, priceLabel, volatilityView, accPriceLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let paddingV: CGFloat = 8
        let paddingH: CGFloat = 16
        let columnWidthRates: [CGFloat] = [0.3, 0.25, 0.2, 0.25]
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(paddingV)
            make.leading.equalToSuperview().offset(paddingH)
            make.width.equalToSuperview().multipliedBy(columnWidthRates[0]).offset(-paddingH)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(paddingV)
            make.leading.equalTo(titleLabel.snp.trailing)
            make.width.equalToSuperview().multipliedBy(columnWidthRates[1])
        }
        
        volatilityView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(paddingV)
            make.leading.equalTo(priceLabel.snp.trailing)
            make.width.equalToSuperview().multipliedBy(columnWidthRates[2])
        }
        
        accPriceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(paddingV)
            make.leading.equalTo(volatilityView.snp.trailing)
            make.trailing.equalToSuperview().inset(paddingH)
            make.width.equalToSuperview().multipliedBy(columnWidthRates[3]).offset(-paddingH)
        }
    }
    
    override func setupAttributes() {
        backgroundColor = AppColor.clear.value
        priceLabel.textAlignment = .right
        accPriceLabel.textAlignment = .right
    }
    
}
