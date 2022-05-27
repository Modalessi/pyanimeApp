//
//  FaselhdAPI.swift
//  pyanime
//
//  Created by Mohammed Alessi on 25/05/2022.
//

import SwiftSoup

class FaselhdAPI {
    
    static let baseUrl: URL = URL(string: "https://www.faselhd.top/")!
    
    static let shared: FaselhdAPI = FaselhdAPI()
    
    func search(for searchQuery: String, completed: @escaping (Result<[SearchResult], PAError>)->Void) {
        var searchUrlComponents = URLComponents(url: FaselhdAPI.baseUrl, resolvingAgainstBaseURL: true)
        
        searchUrlComponents?.queryItems = [ URLQueryItem(name: "s", value: searchQuery) ]
        
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
                
                let resultsContainer = try document.getElementById("postList")
                let resultsDivs = try resultsContainer!.getElementsByClass("col-xl-2 col-lg-2 col-md-3 col-sm-3")
                
                for resultDiv in resultsDivs.array() {
                    let postDiv = try resultDiv.getElementsByClass("postDiv").first()
                    let aTag = try postDiv!.select("a").first()
                    let searchResultLink = try aTag!.attr("href")
                    var searchResultName = try aTag!.getElementsByClass("postInner").first()?.getElementsByClass("h1").text()
                    
                    searchResultName = String((searchResultName?.filter {$0.isASCII}) ?? "")
                    
                    let searchResultImageLink = try aTag!.getElementsByClass("imgdiv-class").first()?.select("img").first()?.attr("src")
                    
                    results.append(SearchResult(name: searchResultName!, link: searchResultLink, imageUrl: searchResultImageLink!))
                }
                
                
                completed(.success(results))
                
            } catch {
                completed(.failure(.extractingData))
            }
            
        }
        
        task.resume()
        
    }
    
    
}

// ÙØ³ÙØ³Ù
