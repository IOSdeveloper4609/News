//
//  SourseModel.swift
//  News
//
//  Created by Азат Киракосян on 31.07.2021.
//

import Foundation

final class SourcesModel {
    
    let title: String?
    let category: String?
    let description: String?
    var isFavourite: Bool = false
    let model: SourceObject
    
    init(model: SourceObject) {
        self.model = model

        title = model.name
        category = model.category
        description = model.detailed
        isFavourite = model.isFavourite
    }
    
}
