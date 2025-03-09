//
//  CoingeckoResponse.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/7/25.
//

import Foundation

//MARK: - Response
//MARK: - Trending
struct CGTrendingResponse: Decodable {
    let coins: [CGCoinsInfo]
    let nfts: [CGNftInfo]
}

struct CGCoinsInfo: Decodable {
    let item: CGTrendingCoinInfo
}

struct CGTrendingCoinInfo: Decodable {
    let id: String
    let coin_id: Int
    let name: String
    let symbol: String
    let thumb: String
    let data: CGCoinDataInfo
}

struct CGCoinDataInfo: Decodable {
    let price_change_percentage_24h: CGCoinPriceChangePercentage24h
}

struct CGCoinPriceChangePercentage24h: Decodable {
    let krw: Double
}

struct CGNftInfo: Decodable {
    let id: String
    let name: String
    let thumb: String
    let floor_price_24h_percentage_change: Double
    let data: CGNftDataInfo
}

struct CGNftDataInfo: Decodable {
//    let floor_price_in_usd_24h_percentage_change: String
    let h24_average_sale_price: String
}

//MARK: - Search
struct CGSearchResponse: Decodable {
    let coins: [CGSearchCoinInfo]
}

struct CGSearchCoinInfo: Decodable {
    let id: String
    let name: String
    let symbol: String
    let market_cap_rank: Int
    let thumb: String
    let score: Int
}

//MARK: - Markets
struct CGMarketsResponse: Decodable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let current_price: Double
    let price_change_percentage_24h: Double
    let last_updated: String
    let high_24h: Double
    let low_24h: Double
    let ath: Double
    let ath_date: String
    let atl: Double
    let atl_date: String
    let market_cap: Double
    let fully_diluted_valuation: Double
    let total_volume: Double
    let sparkline_in_7d: CGMarketSparkline
}

struct CGMarketSparkline: Decodable {
    let price: [Double]
}

//MARK: - Error Code
//MARK: - Trending
enum CGError: String, APIError {
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case missingParameter
    case tooManyRequests
    case internalServerError
    case serviceUnavailable
    case accessDenied
    case apiKeyMissing
    case unowned
    
    init(statusCode: Int) {
        switch statusCode {
        case 400:
            self = .badRequest
        case 401:
            self = .unauthorized
        case 403:
            self = .forbidden
        case 404:
            self = .notFound
        case 422:
            self = .missingParameter
        case 429:
            self = .tooManyRequests
        case 500:
            self = .internalServerError
        case 503:
            self = .serviceUnavailable
        case 1020:
            self = .accessDenied
        case 10002:
            self = .apiKeyMissing
        default:
            self = .unowned
        }
    }
    
    var message: String {
        return "\(self.description) (\(self.rawValue)"
    }
    
    private var description: String {
        switch self {
        case .badRequest, .missingParameter:
            return "잘못된 요청입니다."
        case .unauthorized:
            return "리소스에 대한 유효한 인증 자격 증명이 필요합니다."
        case .forbidden:
            return "엑세스가 차단되었습니다."
        case .notFound:
            return "요청한 리소스를 찾을 수 없습니다."
        case .tooManyRequests:
            return "요금이 한도에 도달하였습니다. 서비스 플랜을 확장하세요."
        case .internalServerError:
            return "CoinGecko 서버에 오류가 발생했습니다."
        case .serviceUnavailable:
            return "현재 CoinGecko 서비스를 이용할 수 없습니다. API 상태와 업데이트를 확인하세요."
        case .accessDenied:
            return "CoinGecko CDN 방화벽 규칙 위반으로 인해 요청이 거부되었습니다."
        case .apiKeyMissing:
            return "CoinGecko API 키의 자격 증명을 확인하세요."
        case .unowned:
            return "Coin Pedia 내부에 오류가 발생했습니다."
        }
    }
}
