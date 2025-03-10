//
//  CoingeckoRequest.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/7/25.
//

import Foundation

enum CGRequest: APIRequest {
    case trending
    case search(_ query: String)
    case markets(_ vs_currency: [CGCurrency], _ ids: [String], _ sparkline: Bool = true)
    
    var endpoint: String {
        return APIUrl.coingecko + self.path
    }
    
    private var path: String {
        switch self {
        case .trending:
            return "/search/trending"
        case .search:
            return "/search"
        case .markets:
            return "/coins/markets"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .trending:
            return [:]
        case .search(let query):
            return [
                "query": query
            ]
        case .markets(let vs_currency, let ids, let sparkline):
            let currencies = vs_currency
                .map { $0.rawValue }
                .joined(separator: ",")
            let ids = ids.joined(separator: ",")
            return [
                "vs_currency": currencies,
                "ids": ids,
                "sparkline": sparkline.description
            ]
        }
    }
    
    var headers: HTTPHeaders {
        return [:]
    }
}

enum CGCurrency: String {
    case krw
    case btc
    case usd
}
