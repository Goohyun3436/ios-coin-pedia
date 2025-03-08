//
//  DetailButton.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/8/25.
//

import UIKit

final class DetailButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var container = AttributeContainer()
        container.font = AppFont.text2.value
        
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("더보기", attributes: container)
        config.image = UIImage(
            systemName: AppIcon.chevronRight.value,
            withConfiguration: UIImage.SymbolConfiguration(
                font: AppFont.subText3.value
            )
        )
        config.imagePlacement = .trailing
        config.imagePadding = 2
        config.baseForegroundColor = AppColor.lightNavy.value
        
        configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
