//
//  RealmRepository.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/11/25.
//

import Foundation
import RealmSwift

protocol Repository {
    func printFileURL()
    func add<Table: Object>(_ document: Table)
    func update<Table: Object>(_ document: Table)
    func fetch<Table: Object>(_ TableT: Table.Type) -> Results<Table>
    func delete<Table: Object>(_ document: Table)
}

final class TableRepository: Repository {
    
    private let realm = try! Realm()
    
    func printFileURL() {
        print(realm.configuration.fileURL ?? "NotFound fileURL")
    }
    
    func add<Table: Object>(_ document: Table) {
        do {
            try realm.write {
                realm.add(document)
            }
        } catch {
            print(#function, error)
        }
    }
    
    func update<Table: Object>(_ document: Table) {
        do {
            try realm.write {
                realm.create(Table.self, value: document, update: .modified)
            }
        } catch {
            print(#function, error)
        }
    }
    
    func fetch<Table: Object>(_ TableT: Table.Type) -> Results<Table> {
        return realm.objects(TableT)
    }
    
    func delete<Table: Object>(_ document: Table) {
        do {
            try realm.write {
                realm.delete(document)
            }
        } catch {
            print(#function, error)
        }
    }
    
}
