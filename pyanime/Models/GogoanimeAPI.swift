//
//  EgybestAPI.swift
//  pyanime
//
//  Created by Mohammed Alessi on 17/04/2022.
//

import UIKit
import SwiftSoup

class GogoanimeAPI {
    
    
    static let baseUrl: URL = URL(string: "https://gogoanime.fi/")!
    
    
    static let shared: GogoanimeAPI = GogoanimeAPI()
    
    
    func search(for searchQuery: String, completed: @escaping (Result<[SearchResult], PAError>)->Void) {
        
        var searchUrlComponents = URLComponents(url: GogoanimeAPI.baseUrl, resolvingAgainstBaseURL: true)
        
        searchUrlComponents?.path = "/search.html"
        searchUrlComponents?.queryItems = [
            URLQueryItem(name: "keyword", value: searchQuery)
        ]
        
        guard let searchUrl = searchUrlComponents?.url else {
            completed(.failure(.invalidUrl))
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: searchUrl) { (data, response, error) in
            
            
            guard let data = data else {
                completed(.failure(.fetchHtml))
                return
            }
            
            guard let html = String(data: data, encoding: .ascii) else {
                completed(.failure(.fetchHtml))
                return
            }
            
            guard let document = try? SwiftSoup.parse(html) else {
                completed(.failure(.htmlParsing))
                return
            }
            
            var results: [SearchResult] = []
            
            do {
                let resultsDivs = try document.select("ul").array().filter { try $0.attr("class") == "items"}[0]
                
                
                
                for resultDiv in try resultsDivs.select("li").array() {
                    let name = try resultDiv.select("p").first()?.select("a").first()?.text()
                    let link = try resultDiv.select("p").first()?.select("a").first()?.attr("href")
                    let imgUrl = try resultDiv.select("div").first()?.select("a").first()?.select("img").first()?.attr("src")
                    
                    results.append(SearchResult(name: name ?? "null", link: link ?? "null", imageUrl: imgUrl ?? "null"))
                }
                
            } catch {
                return completed(.failure(.extractingData))
            }
            
            
            return completed(.success(results))
        }
        
        task.resume()
    }
    
    
}
