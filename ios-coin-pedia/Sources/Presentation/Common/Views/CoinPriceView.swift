//
//  CoinPriceView.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/11/25.
//

import UIKit
import SnapKit

final class CoinPriceView: BaseView {
    
    //MARK: - UI Property
    let titleLabel = AppLabel(.text2, .lightNavy)
    let priceLabel = AppLabel(.text1)
    let subLabel = AppLabel(.subText3, .lightNavy)
    
    init() {
        super.init(frame: .zero)
        subLabel.text = " "
    }
    
    //MARK: - Setup Method
    override func setupUI() {
        [titleLabel, priceLabel, subLabel].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let margin: CGFloat = 4
        
        titleLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(margin)
            make.horizontalEdges.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(margin)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func setupAttributes() {
        backgroundColor = AppColor.clear.value
        
        [titleLabel, priceLabel, subLabel].forEach {
            $0.textAlignment = .left
        }
    }
    
}
