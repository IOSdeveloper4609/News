//
//  SourceObject.swift
//  News
//
//  Created by Азат Киракосян on 30.07.2021.
//

import Foundation
import RealmSwift

class SourceObject: Object, Decodable {
    
    @objc dynamic var id: String? = ""
    @objc dynamic var name: String? = ""
    @objc dynamic var detailed: String? = ""
    @objc dynamic var isFavourite: Bool = false
    @objc dynamic var category: String? = ""
    @objc dynamic var url: String? = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case detailed = "description"
        case category
        case url
    }
    
}
