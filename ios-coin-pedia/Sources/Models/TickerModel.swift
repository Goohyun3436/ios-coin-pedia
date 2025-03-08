//
//  TickerModel.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/8/25.
//

import Foundation

enum TickerSort: String {
    case price = "현재가"
    case change = "전일대비"
    case acc_price = "거래대금"
}

enum TickerSortStatus {
    case normal
    case asc
    case dsc
}
