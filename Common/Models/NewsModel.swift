//
//  NewsModel.swift
//  News
//
//  Created by Азат Киракосян on 28.07.2021.
//

import Foundation

final class NewsModel {
    
    let title: String?
    let image: URL?
    let url: String?
    let description: String?
    let model: NewsObject
    
    init(model: NewsObject) {
        self.model = model
        url = model.url
        image = model.urlToImage
        title = model.title
        description = model.detailed
    }
    
}
