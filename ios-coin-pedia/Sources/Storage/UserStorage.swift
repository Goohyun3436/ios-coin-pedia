//
//  UserStorage.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/11/25.
//

import Foundation
import RealmSwift

final class UserStorage {
    
    static let shared = UserStorage()
    
    private let repo: Repository = TableRepository()
    
    private init() {}
    
    func printFileURL() {
        repo.printFileURL()
    }
    
    func load() {
        let favorites = Array(repo.fetch(CoinTable.self))
        UserStaticStorage.favorites = favorites
        UserStaticStorage.favoriteIds = favorites.map { $0.id }
        
        printFileURL()
    }
    
    func addFavorite(coin: CoinThumbnail) {
        let coin = CoinTable(
            id: coin.id,
            name: coin.name,
            thumb: coin.thumb
        )
        repo.add(coin)
        self.load()
    }
    
    func deleteFavorite(coinId: String) {
        if let coin = UserStaticStorage.favorites.first(
            where: { $0.id == coinId }
        ) {
            repo.delete(coin)
            self.load()
        }
    }
    
}

enum UserStaticStorage {
    fileprivate(set) static var favorites = [CoinTable]()
    fileprivate(set) static var favoriteIds = [String]()
}
