//
//  MinimalSearchBar.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/8/25.
//

import UIKit

final class MinimalSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        searchTextField.leftViewMode = .never
        searchTextField.clearButtonMode = .never
        setPositionAdjustment(UIOffset(horizontal: -20, vertical: 0), for: .search)
        searchTextField.font = AppFont.title4.value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
