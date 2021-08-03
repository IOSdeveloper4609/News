//
//  DatabaseManager.swift
//  News
//
//  Created by Азат Киракосян on 28.07.2021.
//

import Foundation
import RealmSwift

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    var safeRealm: Realm? {
        do {
            return try Realm()
        } catch {
            assertionFailure(error.localizedDescription)
        }
        
        return nil
    }
    
    private var sourse: Results<SourceObject>? {
        return safeRealm?.objects(SourceObject.self)
    }
    
    private init() {}
    
    func saveSources(objects: [SourceObject]) {
        write {
            objects.forEach {
                $0.isFavourite = safeRealm?.object(ofType: SourceObject.self, forPrimaryKey: $0.id)?.isFavourite ?? false
            }
            safeRealm?.add(objects, update: .all)
        }
    }
    
    func saveNews(objects: [NewsObject]) {
        write {
            safeRealm?.add(objects, update: .all)
        }
    }
    
    func write(completion: () -> Void) {
        do {
            try safeRealm?.write {
                completion()
            }
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
}
