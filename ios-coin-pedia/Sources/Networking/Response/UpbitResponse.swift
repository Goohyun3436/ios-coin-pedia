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
    let tradePrice: Double
    let signedChangePrice: Double
    let signedChangeRate: Double
    let accTradePrice24H: Double
    
    let title: String
    let price: String
    let volatility: VolatilityInfo
    let accPrice: String
    
    enum CodingKeys: String, CodingKey {
        case market
        case tradePrice
        case signedChangePrice
        case signedChangeRate
        case accTradePrice24H
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        market = try container.decode(String.self, forKey: .market)
        tradePrice = try container.decode(Double.self, forKey: .tradePrice)
        signedChangePrice = try container.decode(Double.self, forKey: .signedChangePrice)
        signedChangeRate = try container.decode(Double.self, forKey: .signedChangeRate)
        accTradePrice24H = try container.decode(Double.self, forKey: .accTradePrice24H)
        
        let marketInfo = market.split(separator: "-")
        title = "\(marketInfo[1])/\(marketInfo[0])"
        
        switch NumberType(tradePrice) {
        case .int:
            price = tradePrice.formatted()
        case .double1f:
            price = String(format: "%.1f", tradePrice)
        case .double2f:
            price = String(format: "%.2f", tradePrice)
        case .zero:
            price = "0"
        }
        
        volatility = VolatilityInfo(
            type: .priceNPercentage,
            price: signedChangePrice,
            percentage: signedChangeRate
        )
        
        let oneMillion: Double = 1000000
        
        if oneMillion <= accTradePrice24H {
            accPrice = Int(accTradePrice24H / oneMillion).formatted() + "백만"
        } else {
            accPrice = Int(accTradePrice24H).formatted()
        }
    }
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
