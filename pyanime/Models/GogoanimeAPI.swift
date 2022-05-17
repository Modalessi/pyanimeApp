//
//  EgybestAPI.swift
//  pyanime
//
//  Created by Mohammed Alessi on 17/04/2022.
//

import UIKit
import SwiftSoup

class GogoanimeAPI {
    
    
    static let baseUrl: URL = URL(string: "https://gogoanime.sk/")!
    let cache = NSCache<NSString, UIImage>()
    
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
        
        print(GogoanimeAPI.baseUrl)
        print(searchUrl)
        
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
    
    
    
    
    func getAnime(of result: SearchResult, completed: @escaping (Result<Anime,PAError>)->Void) {
        
        var animeUrlComponents = URLComponents(url: GogoanimeAPI.baseUrl, resolvingAgainstBaseURL: true)
        
        animeUrlComponents?.path = result.link
        
        guard let animeUrl = animeUrlComponents?.url else {
            completed(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: animeUrl) { (data, response, error) in
            
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
            
            
            let anime = Anime(searchResult: result, plot: "", episodes: [])
            
            do {
                
                // Get episodes
                
                let episodesEnds = try document.select("a").array().filter { $0.hasAttr("ep_end") }
                let lastEpisode = try Int((episodesEnds.last?.attr("ep_end"))!)
                
                guard lastEpisode != nil else {
                    completed(.failure(.extractingData))
                    return
                }
                
                let animePath = animeUrlComponents?.path
                let animeName = animePath?.split(separator: "/").last
                
                for ep in 1...lastEpisode! {
                    
                    let episodePath = "\(String(describing: animeName))-episode-\(ep)"
                    
                    var episodeComponents = URLComponents(url: GogoanimeAPI.baseUrl, resolvingAgainstBaseURL: true)
                    episodeComponents?.path = episodePath
                    
                    let episode = Episode(number: "\(ep)", link: "\(String(describing: episodeComponents!.url))")
                    anime.episodes.append(episode)
                }
                
                // Get plot
                
                let plotParagraph = try document.select("p").array().filter { try $0.attr("class") == "type" }
                
                let plot = try plotParagraph[1].text().dropFirst(13)
                
                anime.plot = String(plot)
                completed(.success(anime))
                
                
            } catch {
                completed(.failure(.extractingData))
            }
            
            
        }
        
        
        task.resume()
        
    }
    
    
}
