//
//  TickerView.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit
import SnapKit

final class TickerView: BaseView {
    
    //MARK: - UI Property
    let view = IconImageView(.large)
    
    //MARK: - Setup Method
    override func setupUI() {
        addSubview(view)
        
        view.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(AppImageSize.large.value.width)
        }
    }
    
    override func setupConstraints() {
        
    }
    
    override func setupAttributes() {
        
    }
    
}
