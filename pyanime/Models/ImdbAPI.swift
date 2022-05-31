//
//  ImdbAPI.swift
//  pyanime
//
//  Created by Mohammed Alessi on 31/05/2022.
//

import Foundation

class ImdbAPI {
    
    let rapidAPIHost = "mdblist.p.rapidapi.com"
    let rapidAPIKey = "c4d04ace95mshb88ceaca3d562a2p1478fcjsn701e899f605c"
    let baseUrl = URL(string: "https://mdblist.p.rapidapi.com")!
    
    static let shared = ImdbAPI()
    
    func getShowDetails(for searchResult: SearchResult, completed: @escaping (Result<ImdbShowDetails, PAError>)->Void) {
        
        var searchUrlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        
        searchUrlComponents?.queryItems = [ URLQueryItem(name: "s", value: searchResult.name) ]
        
        guard let searchUrl = searchUrlComponents?.url else {
            completed(.failure(.invalidUrl))
            return
        }
        
        let request = NSMutableURLRequest(url: searchUrl)
        request.allHTTPHeaderFields = [
            "X-RapidAPI-Host" : rapidAPIHost,
            "X-RapidAPI-Key" : rapidAPIKey
        ]
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completed(.failure(.fetchHtml))
                return
            }
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)  as! [String : Any]
                let results = json["search"] as! [[String : Any]]
                let firstResult = results[0]
                let imdbId = firstResult["imdbid"] as! String
                print("imdbid: \(imdbId)")
                self.getDetails(for: imdbId) { (result) in
                    switch result {
                    case .success(let details) :
                        completed(.success(details))
                    case .failure(let error) :
                        completed(.failure(error))
                    }
                }
                
            } catch let error {
                print(error)
                completed(.failure(.extractingData))
            }
            
        }
        
        task.resume()
        
        
    }
    
    
    
    func getDetails(for imdbId: String, completed: @escaping (Result<ImdbShowDetails, PAError>)->Void) {
        
        
        let baseUrl = URL(string: "https://movie-details1.p.rapidapi.com")!
        var searchUrlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        searchUrlComponents?.queryItems = [ URLQueryItem(name: "id", value: imdbId) ]
        searchUrlComponents?.path = "/imdb_api/movie"
        
        guard let searchUrl = searchUrlComponents?.url else {
            completed(.failure(.invalidUrl))
            return
        }
        
        let request = NSMutableURLRequest(url: searchUrl)
        request.allHTTPHeaderFields = [
            "X-RapidAPI-Host" : "movie-details1.p.rapidapi.com",
            "X-RapidAPI-Key" : rapidAPIKey
        ]
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completed(.failure(.fetchHtml))
                return
            }
            
            do {
                
                let imdbDetails = try JSONDecoder().decode(ImdbShowDetails.self, from: data)
                completed(.success(imdbDetails))
                
            } catch let error {
                print(error)
                completed(.failure(.extractingData))
            }
            
        }
        
        task.resume()
        
        
    }
    
    
    
    
}
