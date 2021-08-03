//
//  NewDataModel.swift
//  News
//
//  Created by Азат Киракосян on 28.07.2021.
//

import Foundation

struct Sources: Decodable {
    let sources: [SourceObject]
}

struct News: Decodable {
    let articles: [NewsObject]
}

struct Search: Decodable {
   let articles: [Article]
}

struct Article: Decodable {
    
    let url: String?
    let description: String?
    let title: String?
    let urlToImage: URL?
    
}
