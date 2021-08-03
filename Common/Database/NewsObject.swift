//
//  NewsObject.swift
//  News
//
//  Created by Азат Киракосян on 28.07.2021.
//

import Foundation
import RealmSwift

 class NewsObject: Object, Decodable {
    
    @objc dynamic var title: String? = ""
    @objc dynamic var imageUrlString: String?
    @objc dynamic var detailed: String? = ""
    @objc dynamic var url: String? = ""
    
    override static func primaryKey() -> String? {
        return "title"
    }
    
    var urlToImage: URL? {
        if let imageUrlString = imageUrlString {
            return URL(string: imageUrlString)
        }
        
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case imageUrlString = "urlToImage"
        case detailed = "description"
        case url
    }
    
}
