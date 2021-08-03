//
//  Extention + Array.swift
//  News
//
//  Created by Азат Киракосян on 28.07.2021.
//

import Foundation

extension Array {
    
   subscript (safe index: Int) -> Element? {
       return indices.contains(index) ? self[index] : nil
   }
    
}
