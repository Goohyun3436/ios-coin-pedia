//
//  RealmModel.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/11/25.
//

import Foundation
import RealmSwift

final class CoinTable: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var thumb: String
    @Persisted var date: Date
    
    convenience init(
        id: String,
        name: String,
        thumb: String
    ) {
        self.init()
        self.id = id
        self.name = name
        self.thumb = thumb
        self.date = Date()
    }
}
