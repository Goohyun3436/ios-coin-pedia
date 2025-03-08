//
//  FavoriteButton.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit

final class FavoriteButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(UIImage(systemName: AppIcon.star.value), for: .normal)
        setImage(UIImage(systemName: AppIcon.starFill.value), for: .selected)
        tintColor = AppColor.navy.value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
