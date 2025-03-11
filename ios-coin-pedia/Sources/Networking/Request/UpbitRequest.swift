//
//  UpbitRequest.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/7/25.
//

import Foundation

enum UBRequest: APIRequest {
    case ticker(_ quote_currencies: [UBCurrency])
    
    var endpoint: String {
        return APIUrl.upbit + self.path
    }
    
    private var path: String {
        switch self {
        case .ticker:
            return "/ticker/all"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .ticker(let quote_currencies):
            let currencies = quote_currencies
                .map { $0.rawValue }
                .joined(separator: ",")
            return [
                "quote_currencies": currencies
            ]
        }
    }
    
    var headers: HTTPHeaders {
        return [:]
    }
}

enum UBCurrency: String {
    case KRW
    case BTC
    case USDT
}
