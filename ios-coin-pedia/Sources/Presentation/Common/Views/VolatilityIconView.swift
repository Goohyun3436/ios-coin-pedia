//
//  VolatilityIconView.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit
import SnapKit

final class VolatilityIconView: BaseView {
    
    //MARK: - UI Property
    private let iconView = UIImageView()
    private let label: AppLabel
    
    //MARK: - Initializer Method
    init(_ font: AppFont = .subText2) {
        label = AppLabel(.subText2)
        super.init(frame: .zero)
    }
    
    //MARK: - Setup Method
    func setData(_ info: VolatilityInfo) {
        if let icon = info.icon {
            iconView.image = UIImage(systemName: icon.value)
        }
        label.text = info.text
        iconView.tintColor = info.color.value
        label.textColor = info.color.value
    }
    
    override func setupUI() {
        [iconView, label].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let margin: CGFloat = 4
        let iconSize: CGFloat = 12
        
        iconView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().offset(margin)
            make.size.equalTo(iconSize)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(margin)
            make.trailing.equalToSuperview().inset(margin)
        }
    }
    
}
