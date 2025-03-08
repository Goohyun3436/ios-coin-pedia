//
//  SectionHeaderView.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit
import SnapKit

final class SectionHeaderView: BaseView {
    
    //MARK: - UI Property
    private let titleLabel = AppLabel(.title2)
    private let accessoryView = UIStackView()
    private let detailLabel = AppLabel(.text2, .lightNavy)
    private let detailButton = DetailButton()
    
    //MARK: - Initializer Method
    init(
        _ type: SectionHeaderType,
        title: String?,
        detailText: String? = nil
    ) {
        super.init(frame: .zero)
        
        switch type {
        case .detailText:
            detailButton.isHidden = true
            detailLabel.text = detailText
        case .detailButton:
            detailLabel.isHidden = true
        }
        
        titleLabel.text = title
    }
    
    //MARK: - Setup Method
    override func setupUI() {
        [detailLabel, detailButton].forEach {
            accessoryView.addArrangedSubview($0)
        }
        
        [titleLabel, accessoryView].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let margin: CGFloat = 16
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().offset(margin)
        }
        
        accessoryView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(margin)
            make.trailing.equalToSuperview().inset(margin)
        }
    }
    
}
