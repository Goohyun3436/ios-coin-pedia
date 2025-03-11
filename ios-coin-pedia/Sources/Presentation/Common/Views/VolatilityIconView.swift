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
    private let wrap = UIStackView()
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
        } else {
            iconView.isHidden = true
        }
        label.text = info.text
        iconView.tintColor = info.color.value
        label.textColor = info.color.value
    }
    
    override func setupUI() {
        [iconView, label].forEach {
            wrap.addArrangedSubview($0)
        }
        
        addSubview(wrap)
    }
    
    override func setupConstraints() {
        let margin: CGFloat = 4
        let iconSize: CGFloat = 12
        
        wrap.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        wrap.axis = .horizontal
        wrap.spacing = margin
        
        iconView.snp.makeConstraints { make in
            make.size.equalTo(iconSize)
        }
    }
    
    override func setupAttributes() {
        label.textAlignment = .right
    }
    
}
