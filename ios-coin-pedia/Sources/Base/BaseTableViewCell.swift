//
//  BaseTableViewCell.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/9/25.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        setupAttributes()
    }
    
    func setupUI() {}
    
    func setupConstraints() {}
    
    func setupAttributes() {}
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
