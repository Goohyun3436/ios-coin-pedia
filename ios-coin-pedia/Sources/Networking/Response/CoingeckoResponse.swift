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
    var coins: [CGCoinsInfo]
    var nfts: [CGNftInfo]
}

struct CGCoinsInfo: Decodable {
    let item: CGTrendingCoinInfo
}

struct CGTrendingCoinInfo: Decodable {
    let id: String
    let coinId: Int
    let name: String
    let symbol: String
    let thumb: String
    let score: Int
    let data: CGCoinDataInfo
    
    let rank: String
    let imagePlaceholder: String
    let volatility: VolatilityInfo
    let isFavorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case coinId
        case name
        case symbol
        case thumb
        case score
        case data
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        coinId = try container.decode(Int.self, forKey: .coinId)
        name = try container.decode(String.self, forKey: .name)
        symbol = try container.decode(String.self, forKey: .symbol)
        thumb = try container.decode(String.self, forKey: .thumb)
        score = try container.decode(Int.self, forKey: .score)
        data = try container.decode(CGCoinDataInfo.self, forKey: .data)
        
        rank = "\(score + 1)"
        imagePlaceholder = AppIcon.questionMark.value
        volatility = VolatilityInfo(
            type: .percentage,
            percentage: data.priceChangePercentage24H.krw
        )
        isFavorite = true
    }
}

struct CGCoinDataInfo: Decodable {
    let priceChangePercentage24H: CGCoinPriceChangePercentage24H
}

struct CGCoinPriceChangePercentage24H: Decodable {
    let krw: Double
}

struct CGNftInfo: Decodable {
    let id: String
    let name: String
    let thumb: String
    let floorPrice24HPercentageChange: Double
    let data: CGNftDataInfo
    
    let imagePlaceholder: String
    let volatility: VolatilityInfo
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case thumb
        case floorPrice24HPercentageChange
        case data
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        thumb = try container.decode(String.self, forKey: .thumb)
        floorPrice24HPercentageChange = try container.decode(Double.self, forKey: .floorPrice24HPercentageChange)
        data = try container.decode(CGNftDataInfo.self, forKey: .data)
        
        imagePlaceholder = AppIcon.questionMark.value
        volatility = VolatilityInfo(
            type: .percentage,
            percentage: floorPrice24HPercentageChange
        )
    }
}

struct CGNftDataInfo: Decodable {
    let h24AverageSalePrice: String
}

//MARK: - Search
struct CGSearchResponse: Decodable {
    let coins: [CGSearchCoinInfo]
}

struct CGSearchCoinInfo: Decodable {
    let id: String
    let name: String
    let symbol: String
    let marketCapRank: Int
    let thumb: String
    
    let imagePlaceholder: String
    let rank: String
    let isFavorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case marketCapRank
        case thumb
        case score
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        symbol = try container.decode(String.self, forKey: .symbol)
        marketCapRank = try container.decodeIfPresent(Int.self, forKey: .marketCapRank) ?? 0
        thumb = try container.decode(String.self, forKey: .thumb)
        
        imagePlaceholder = AppIcon.questionMark.value
        rank = "#\(marketCapRank)"
        isFavorite = true
    }
}

//MARK: - Markets
struct CGMarketsResponse: Decodable {
    let id: String
    let symbol: String
    let name: String
    let currentPrice: Double
    let priceChangePercentage24H: Double
    let lastUpdated: String
    let high24H: Double
    let low24H: Double
    let ath: Double
    let athDate: String
    let atl: Double
    let atlDate: String
    let marketCap: Double
    let fullyDilutedValuation: Double
    let totalVolume: Double
    let sparklineIn7D: CGMarketSparkline
    
    let currentPriceStr: String
    let volatility: VolatilityInfo
    let chartInfo: CoinChartInfo
    let lastUpdatedStr: String
    let info: CoinInfo
    let analyze: CoinAnalyze
    
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case currentPrice
        case priceChangePercentage24H
        case lastUpdated
        case high24H
        case low24H
        case ath
        case athDate
        case atl
        case atlDate
        case marketCap
        case fullyDilutedValuation
        case totalVolume
        case sparklineIn7D
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        symbol = try container.decode(String.self, forKey: .symbol)
        name = try container.decode(String.self, forKey: .name)
        currentPrice = try container.decode(Double.self, forKey: .currentPrice)
        priceChangePercentage24H = try container.decode(Double.self, forKey: .priceChangePercentage24H)
        lastUpdated = try container.decode(String.self, forKey: .lastUpdated)
        high24H = try container.decode(Double.self, forKey: .high24H)
        low24H = try container.decode(Double.self, forKey: .low24H)
        ath = try container.decode(Double.self, forKey: .ath)
        athDate = try container.decode(String.self, forKey: .athDate)
        atl = try container.decode(Double.self, forKey: .atl)
        atlDate = try container.decode(String.self, forKey: .atlDate)
        marketCap = try container.decode(Double.self, forKey: .marketCap)
        fullyDilutedValuation = try container.decode(Double.self, forKey: .fullyDilutedValuation)
        totalVolume = try container.decode(Double.self, forKey: .totalVolume)
        sparklineIn7D = try container.decode(CGMarketSparkline.self, forKey: .sparklineIn7D)
        
        currentPriceStr = "₩\(currentPrice.formatted())"
        
        volatility = VolatilityInfo(
            type: .percentage,
            percentage: priceChangePercentage24H
        )
        
        let prices = sparklineIn7D.price
        let startDate = Date().addingTimeInterval(-Double(prices.count) * 3600)
        let chartData = prices.enumerated().map {
            CoinChartData(
                time: startDate.addingTimeInterval(Double($0) * 3600),
                price: $1
            )
        }
        var chartInfo_ = CoinChartInfo(data: chartData)
        if let yMin = prices.min(), let yMax = prices.max() {
            chartInfo_.yMin = yMin * 0.98
            chartInfo_.yMax = yMax
        }
        chartInfo = chartInfo_
        
        lastUpdatedStr = DateManager.shared.convertFormat(
            with: lastUpdated,
            from: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            to: "M/d HH:mm:ss 업데이트"
        )
        
        info = CoinInfo(
            high24H: CoinPriceInfo(title: "24시간 고가", price: high24H),
            low24H: CoinPriceInfo(title: "24시간 저가", price: low24H),
            ath: CoinPriceInfo(title: "역대 최고가", price: ath, date: athDate),
            atl: CoinPriceInfo(title: "역대 최저가", price: atl, date: atlDate)
        )
        
        analyze = CoinAnalyze(
            marketCap: CoinPriceInfo(title: "시가총액", price: marketCap),
            fdv: CoinPriceInfo(title: "완전 희석 가치(FDV)", price: fullyDilutedValuation),
            totalVolume: CoinPriceInfo(title: "총 거래량", price: totalVolume)
        )
    }
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
    
    var title: String {
        return "네트워크 에러"
    }
    
    var message: String {
        return "\(self.description) (\(self.rawValue))"
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
