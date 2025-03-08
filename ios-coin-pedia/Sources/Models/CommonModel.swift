//
//  CommonModel.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/8/25.
//

import Foundation

enum SectionHeaderType {
    case detailText
    case detailButton
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
                color = AppColor.red
            } else if 0 < percentage {
                icon = AppIcon.arrowUp
                color = AppColor.blue
            } else {
                icon = nil
                color = AppColor.navy
            }
            
            return (icon, color)
        }
        
        func getValue() -> (String, String?) {
            let value: Double
            let text: String
            let subText: String?
            
            switch type {
            case .percentage:
                value = fabs(percentage)
                
            case .priceNPercentage:
                value = percentage
            }
            
            text = String(format: "%.2f", value) + "%"
            subText = price?.formatted()
            
            return (text, subText)
        }
    }
}
