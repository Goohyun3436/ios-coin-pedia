//
//  DateManager.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/11/25.
//

import Foundation

final class DateManager {
    
    static let shared = DateManager()
    
    private init() {}
    
    func getCurrentTimeTenMin(
        dateFormat: String
    ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        var dateStr = formatter.string(from: Date())
        
        var dateArray = Array(dateStr)
        dateArray[10] = "0"
        dateStr = String(dateArray)
        
        return dateStr
    }
    
    func convertFormat(
        with dateStr: String,
        from: String,
        to: String
    ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = from
        let convertDate = formatter.date(from: dateStr)
        
        formatter.dateFormat = to
        formatter.locale = Locale(identifier:"ko_KR")
        guard let convertDate else { return dateStr }
        
        return formatter.string(from: convertDate)
    }
    
}
