//
//  VolatilityTextView.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/8/25.
//

import UIKit
import SnapKit

final class VolatilityTextView: BaseView {
    
    //MARK: - UI Property
    private let label = AppLabel(.text2)
    private let subLabel = AppLabel(.subText3)
    
    //MARK: - Setup Method
    func setData(_ info: VolatilityInfo) {
        label.text = info.text
        subLabel.text = info.subText
        label.textColor = info.color.value
        subLabel.textColor = info.color.value
    }
    
    override func setupUI() {
        [label, subLabel].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        label.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(4)
            make.trailing.bottom.equalToSuperview()
        }
    }
    
}
