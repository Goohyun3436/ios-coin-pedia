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
    let headerView = TickerHeaderView()
    let tableView = {
        let view = UITableView()
        view.register(TickerTableViewCell.self, forCellReuseIdentifier: TickerTableViewCell.id)
        return view
    }()
    
    //MARK: - Setup Method
    override func setupUI() {
        [headerView, tableView].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let headerH: CGFloat = 34
        
        headerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(headerH)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func setupAttributes() {
        tableView.rowHeight = 44
//        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
}
