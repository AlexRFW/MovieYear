import UIKit
import PlaygroundSupport


// onderstaande code gebruikt om TMDB.org API te testen voor unit 6

PlaygroundPage.current.needsIndefiniteExecution = true

extension URL {
    
    func withQueries(_ queries: [String: String]) -> URL? {
        
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.flatMap { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}

struct StoreItem {
    
    var id: Int
    var title: String
    var release_date: String.SubSequence
    var overview: String
    var poster_path: URL
    
    //    var name: String
    //    var artist: String
    //    var description: String
    //    var kind: String
    //    var artworkURL: URL
    
    init?(json: [String: Any]) {
        
        guard let title = json["title"] as? String,
            let id = json["id"] as? Int,
            let release_date = json["release_date"] as? String.SubSequence,
            let overview = json["overview"] as? String,
            let poster_pathString = json["poster_path"] as? String,
            let poster_path = URL(string: poster_pathString) else { return nil }
        
        self.id = id
        self.title = title
        self.release_date = release_date.prefix(4)
        self.overview = overview
        self.poster_path = poster_path
        
        //self.overview = json["overview"] as? String ?? json["longDescription"] as? String ?? ""
    }
}

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


let query: [String: String] = [
    "api_key": "c45d17153b8b450ec8472155dbfafca6",
    "language": "en-US",
    "sort_by": "popularity.desc",
    "include_adult": "false",
    "include_video": "false",
    "page": "1",
    "primary_release_year": "2016"
]

fetchItems(matching: query) { (items) in
    //print(items ?? "0")
    for item in items! {
        print("The movie " + item.title + "was released in", item.release_date)
    }
}


/*:
 
 _Copyright © 2017 Apple Inc._
 
 _Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:_
 
 _The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software._
 
 _THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE._
 */
