//
//  DetailAnalyzeView.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/11/25.
//

import UIKit
import SnapKit

final class DetailAnalyzeView: BaseView {
    
    //MARK: - UI Property
    private let wrap = UIStackView()
    let marketCap = CoinPriceView()
    let fdv = CoinPriceView()
    let totalVolume = CoinPriceView()
    
    //MARK: - Setup Method
    override func setupUI() {
        [marketCap, fdv, totalVolume].forEach {
            wrap.addArrangedSubview($0)
        }
        
        addSubview(wrap)
    }
    
    override func setupConstraints() {
        let margin: CGFloat = 16
        let innerMargin: CGFloat = 8
        
        wrap.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(margin)
        }
        wrap.axis = .vertical
        wrap.spacing = innerMargin
    }
    
    override func setupAttributes() {
        layer.cornerRadius = 16
        backgroundColor = AppColor.lightGray.value
    }
    
}
