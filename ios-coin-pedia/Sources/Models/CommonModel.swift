//
//  CommonModel.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/8/25.
//

import Foundation
import RxSwift

//MARK: - SectionHeader
enum SectionHeaderAccessoryType {
    case none
    case subText
    case button
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

//MARK: - Number Format
enum NumberType {
    case int
    case double1f
    case double2f
    case zero
    
    init(_ num: Double) {
        if num == 0 {
            self = .zero
            return
        }
        
        if num == Double(Int(num)) {
            self = .int
            return
        }
        
        if let last = String(format: "%.2f", num).last, last == "0" {
            self = .double1f
        } else {
            self = .double2f
        }
    }
}

//MARK: - Search Validation
enum SearchError: Error {
    case emptyQuery
    
    var title: String {
        return "검색 실패"
    }
    
    var message: String {
        switch self {
        case .emptyQuery:
            return "검색어를 입력해주세요"
        }
    }
    
    static func validation(_ query: String) -> Single<Result<String, SearchError>> {
        return Single<Result<String, SearchError>>.create { observer in
            let disposables = Disposables.create()
            
            let query = query.trimmingCharacters(in: .whitespaces)
            
            guard !query.isEmpty else {
                observer(.success(.failure(.emptyQuery)))
                return disposables
            }
            
            observer(.success(.success(query)))
            
            return disposables
        }
    }
}

//MARK: - Alert
struct AlertInfo {
    let title: String?
    let message: String?
}
