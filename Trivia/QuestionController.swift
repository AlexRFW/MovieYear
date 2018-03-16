//
//  QuestionController.swift
//  Trivia
//
//  Created by Alex Witkamp on 13-03-18.
//  Copyright © 2018 Alex Witkamp. All rights reserved.
//

import Foundation
import UIKit

// put the queries into the url of tmdb.org
extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.flatMap { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}

// fetch movie information from tmdb.org
class QuestionController {
    
    static let shared = QuestionController()
    
    func fetchItems(matching query: [String: String], completion: @escaping ([StoreItem]?) -> Void) {
        
        let baseURL = URL(string: "https://api.themoviedb.org/3/discover/movie")!
        
        guard let url = baseURL.withQueries(query) else {
            completion(nil)
            print("Unable to build URL with supplied queries.")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let data = data,
                let rawJSON = try? JSONSerialization.jsonObject(with: data),
                let json = rawJSON as? [String: Any],
                let resultsArray = json["results"] as? [[String: Any]] {
                
                let storeItems = resultsArray.flatMap { StoreItem(json: $0) }
                completion(storeItems)
                
            } else {
                print("Either no data was returned, or data was not serialized.")
                
                completion(nil)
                return
            }
        }
        task.resume()
    }
}
