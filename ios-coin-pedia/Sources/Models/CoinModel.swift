//
//  CoinModel.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/11/25.
//

import Foundation

//MARK: - Coin
struct CoinThumbnail {
    let id: String
    let name: String
    let thumb: String
    let iconPlaceholder = AppIcon.questionMark.value
    var isFavorite: Bool = false
}

struct CoinChartInfo {
    let data: [CoinChartData]
    var yMin: Double = 0
    var yMax: Double = 0
}

struct CoinChartData: Identifiable {
    let id = UUID()
    let time: Date
    let price: Double
}

struct CoinInfo {
    let high24H: CoinPriceInfo
    let low24H: CoinPriceInfo
    let ath: CoinPriceInfo
    let atl: CoinPriceInfo
}

struct CoinAnalyze {
    let marketCap: CoinPriceInfo
    let fdv: CoinPriceInfo
    let totalVolume: CoinPriceInfo
}

struct CoinPriceInfo {
    let title: String
    let price: Double
    var priceKRW: String {
        return "₩\(price.formatted())"
    }
    var date: String = " "
    var dateKR: String {
        return DateManager.shared.convertFormat(
            with: date,
            from: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            to: "yy년 M월 d일"
        )
    }
}

//MARK: - Volatility
enum VolatilityType {
    case percentage
    case priceNPercentage
}

struct VolatilityInfo {
    let icon: AppIcon?
    let text: String
    let subText: String?
    let color: AppColor
    
    init(
        type: VolatilityType,
        price: Double? = nil,
        percentage: Double
    ) {
        let (icon_, color_) = getResource()
        icon = icon_
        color = color_
        
        let (text_, subText_) = getValue()
        text = text_
        subText = subText_
        
        func getResource() -> (AppIcon?, AppColor) {
            let icon: AppIcon?
            let color: AppColor
            
            if percentage < 0 {
                icon = AppIcon.arrowDown
                color = AppColor.blue
            } else if 0 < percentage {
                icon = AppIcon.arrowUp
                color = AppColor.red
            } else {
                icon = nil
                color = AppColor.navy
            }
            
            return (icon, color)
        }
        
        func getValue() -> (String, String?) {
            let value: Double
            let text: String
            var subText: String? = nil
            
            switch type {
            case .percentage:
                value = fabs(percentage)
                
            case .priceNPercentage:
                value = percentage
            }
            
            text = String(format: "%.2f", value) + "%"
            
            if let price {
                switch NumberType(price) {
                case .int:
                    subText = price.formatted()
                case .double1f, .double2f:
                    subText = String(format: "%.2f", price)
                case .zero:
                    subText = "0"
                }
            }
            
            return (text, subText)
        }
    }
}
