//
//  UpbitResponse.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/7/25.
//

import Foundation

//MARK: - Response
struct UBTickerResponse: Decodable {
    let market: String
    let trade_price: Double
    let signed_change_price: Double
    let signed_change_rate: Double
    let acc_trade_price_24h: Double
}

//MARK: - Error Code
enum UBError: String, APIError {
    case notFound
    case unowned
    
    init(statusCode: Int) {
        switch statusCode {
        case 400:
            self = .notFound
        default:
            self = .unowned
        }
    }
    
    var message: String {
        return "\(self.description) (\(self.rawValue)"
    }
    
    private var description: String {
        switch self {
        case .notFound:
            return "잘못된 요청입니다."
        case .unowned:
            return "Coin Pedia 내부에 오류가 발생했습니다."
        }
    }
}
