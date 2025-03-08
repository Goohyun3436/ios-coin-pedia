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
        self.searchTextField.leftViewMode = .never
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
