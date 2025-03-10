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
