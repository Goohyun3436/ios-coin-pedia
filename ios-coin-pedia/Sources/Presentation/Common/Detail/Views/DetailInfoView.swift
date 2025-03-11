//
//  DetailInfoView.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/11/25.
//

import UIKit
import SnapKit

final class DetailInfoView: BaseView {
    
    //MARK: - UI Property
    private let wrap = UIStackView()
    private let wrap24H = UIStackView()
    private let wrapAT = UIStackView()
    let high24H = CoinPriceView()
    let low24H = CoinPriceView()
    let ath = CoinPriceView()
    let atl = CoinPriceView()
    
    //MARK: - Setup Method
    override func setupUI() {
        [high24H, low24H].forEach {
            wrap24H.addArrangedSubview($0)
        }
        
        [ath, atl].forEach {
            wrapAT.addArrangedSubview($0)
        }
        
        [wrap24H, wrapAT].forEach {
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
        wrap.distribution = .fillEqually
        
        [wrap24H, wrapAT].forEach {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.distribution = .fillEqually
        }
    }
    
    override func setupAttributes() {
        layer.cornerRadius = 16
        backgroundColor = AppColor.lightGray.value
    }
    
}
