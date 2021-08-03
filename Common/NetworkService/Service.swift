//
//  Network.swift
//  News
//
//  Created by Азат Киракосян on 28.07.2021.
//

import Foundation

class Service {
    
    private let baseParameters = ["apikey": apiKey]
    
    func baseGetRequest<T: Decodable>(url: URLComponents, completion: @escaping (T?) -> Void) {
        guard let url = url.url else {
            completion(nil)
            assertionFailure("missing url request")
            return
        }
        let request = URLRequest(url: url)
        print(request)
        URLSession.shared.dataTask(with: request) { data,_,error in
            if let error = error {
                completion(nil)
                assertionFailure(error.localizedDescription)
            } else if let data = data, let results = self.parseResponse(T.self, data: data) {
                completion(results)
            }
        }.resume()
    }
    
    func sendGetRequest<T: Decodable>(path: String, host: String, parameters: [String:String], completion: @escaping (T?) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        var param = baseParameters
        parameters.forEach({ param[$0] = $1 })
        let result = param.compactMap { URLQueryItem(name: $0, value: $1) }
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = result
        
        baseGetRequest(url: urlComponents, completion: completion)
    }
    
    private func parseResponse<T>(_ type: T.Type, data: Data) -> T? where T: Decodable {
        do {
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            print(error)
            return nil
        }
    }
    
}
