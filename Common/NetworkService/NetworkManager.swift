//
//  NetworkManager.swift
//  News
//
//  Created by Азат Киракосян on 28.07.2021.
//

import Foundation

final class NetworkManager: Service {
    
    func getSources(completion: @escaping ([SourceObject]) -> Void) {
        let parameters = ["language": "en"]
        
        let completion: (Sources?) -> Void = { data in
            guard let data = data else {
                print("Error")
                return completion([])
            }
            
            completion(data.sources)
        }
        
        sendGetRequest(
            path: "/v2/top-headlines/sources",
            host: "newsapi.org",
            parameters: parameters,
            completion: completion
        )
    }
    
    func getNews(id: String, completion: @escaping ([NewsObject]) -> Void) {
        let parameters = ["sources": id]
        
        let completion: (News?) -> Void = { data in
            guard let data = data else {
                print("Error")
                return completion([])
            }
            
            completion(data.articles)
        }
        
        sendGetRequest(
            path: "/v2/everything",
            host: "newsapi.org",
            parameters: parameters,
            completion: completion
        )
    }
    
    func getObject(value: String, completion: @escaping ([Article]) -> Void) {
        let parameters = ["q": value,
                          "language":"en"]
        
        let completion: (Search?) -> Void = { data in
            guard let data = data else {
                print("Error")
                return completion([])
            }
            
            completion(data.articles)
        }
        
        sendGetRequest(
            path: "/v2/everything",
            host: "newsapi.org",
            parameters: parameters,
            completion: completion
        )
    }
    
}
