//
//  LankLabelView.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/10/25.
//

import UIKit
import SnapKit

final class LankLabelView: BaseView {
    
    let label: AppLabel
    
    init(_ font: AppFont, _ color: AppColor = .navy) {
        label = AppLabel(font, color)
        super.init(frame: .zero)
    }
    
    override func setupUI() {
        addSubview(label)
    }
    
    override func setupConstraints() {
        let inset: CGFloat = 4
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(inset)
        }
    }
    
    override func setupAttributes() {
        layer.cornerRadius = 4
        backgroundColor = AppColor.lightGray.value
    }
    
}
