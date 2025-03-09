//
//  IconImageView.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit

final class IconImageView: UIImageView {
    
    init(_ iconSize: AppImageSize) {
        super.init(frame: CGRect(origin: .zero, size: iconSize.value))
        
        let rect = iconSize.value
        
        switch iconSize {
        case .large:
            layer.cornerRadius = rect.width / 4
        case .small, .thumb:
            layer.cornerRadius = rect.width / 2
        }
        
        contentMode = .scaleAspectFill
        clipsToBounds = true
        backgroundColor = AppColor.lightGray.value
        tintColor = AppColor.navy.value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
