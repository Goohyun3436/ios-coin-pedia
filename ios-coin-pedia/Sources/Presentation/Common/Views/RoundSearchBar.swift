//
//  RoundSearchBar.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit

final class RoundSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1
        layer.borderColor = AppColor.lightNavy.value.cgColor
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = rect.size.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
