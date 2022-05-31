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
    
    var cache = NSCache<NSString, UIImage>()
    
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
                    
                    searchResultName = String((searchResultName?.filter {$0.isASCII}) ?? "").trimmingCharacters(in: .whitespaces)
                    
                    let searchResultImageLink = try aTag!.getElementsByClass("imgdiv-class").first()?.select("img").first()?.attr("data-src")
                    
                    
                    
                    results.append(SearchResult(name: searchResultName!, link: searchResultLink, imageUrl: searchResultImageLink!))
                }
                
                
                completed(.success(results))
                
            } catch {
                completed(.failure(.extractingData))
            }
            
        }
        
        task.resume()
        
    }
    
    
    func getShow(for searchResult: SearchResult, completed: @escaping (Result<Show, PAError>)->Void) {
        
        guard let showUrl = URL(string: searchResult.link) else {
            completed(.failure(.invalidUrl))
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: showUrl) { (data, response, error) in
                        
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
            
            let show = Show()
            var imdbDeatils = ImdbShowDetails()
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            ImdbAPI.shared.getShowDetails(for: searchResult) { (result) in
                switch result {
                case .success(let imdbShowDetails) :
                    imdbDeatils = imdbShowDetails
                case .failure(let error) :
                    completed(.failure(error))
                }
                dispatchGroup.leave()
            }
            
            
            dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                if self.isMovie(document) {
                    show.isMovie = true
                    completed(.success(Show(from: searchResult, imdbDetails: imdbDeatils, isMovie: true, seasons: nil, episodes: nil)))
                } else {
                    
                    if self.hasSeasons(document) {
                        self.getSeasons(document) { (result) in
                            switch result {
                            case .success(let seasons) :
                                completed(.success(Show(from: searchResult, imdbDetails: imdbDeatils, isMovie: false, seasons: seasons, episodes: nil)))
                            case .failure(let error) :
                                completed(.failure(error))
                            }
                        }
                    } else {
                        self.getEpisodes(showUrl.description) { (result) in
                            switch result {
                            case .failure(let error) :
                                completed(.failure(error))
                            case .success(let episodes) :
                                completed(.success(Show(from: searchResult, imdbDetails: imdbDeatils, isMovie: false, seasons: nil, episodes: episodes)))
                            }
                        }
                    }
                }
            })
            
        }
        
        task.resume()
        
    }
    
    
    func hasSeasons(_ document: Document)->Bool {
        do {
            let seasonsDiv = try document.getElementById("seasonList")
            return seasonsDiv != nil
        } catch {
            return false
        }
    }
    
    
    func isMovie(_ document: Document)-> Bool {
        do {
            let episodesDiv = try document.getElementById("epAll")
            return episodesDiv == nil
        } catch {
            return false
        }
    }
    
    
    func getSeasons(_ document: Document, completed: @escaping (Result<[Season], PAError>)->Void) {
        var seasons: [Season] = []
        
        do {
            let seasonsContainer = try document.getElementById("seasonList")
            let seasonsDivs = try seasonsContainer!.getElementsByClass("col-xl-2 col-lg-3 col-md-6").array()
            
            let dispatchGroup = DispatchGroup()
            for seasonDiv in seasonsDivs {
                let baseUrl = "https://www.faselhd.pro/?p="
                let div = try seasonDiv.getElementsByClass("seasonDiv").first()
                let id = try div!.attr("data-href")
                let link = baseUrl + id
                var title = try div!.getElementsByClass("title").text()
                title = String(title.filter {$0.isASCII} ).trimmingCharacters(in: .whitespaces)
                dispatchGroup.enter()
                getEpisodes(link) { (result) in
                    switch result {
                    case .failure(let error) :
                        print(error.localizedDescription)
                        seasons.append(Season(number: title, episodes: []))
                    case .success(let episodes) :
                        seasons.append(Season(number: title, episodes: episodes))
                    }
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                completed(.success(seasons))
            })
        } catch {
            completed(.failure(.extractingData))
        }
    }
    
    
    func getEpisodes(_ link: String, completed: @escaping (Result<[Episode], PAError>)->Void) {
        
        let showUrl = URL(string: link)
        let task = URLSession.shared.dataTask(with: showUrl!) { (data, response, error) in
            
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
            
            do {
                
                let episodesDiv = try document.getElementById("epAll")
                let links = try episodesDiv!.select("a").array()
                var episodes: [Episode] = []
                for link in links {
                    let number = try String(link.text().filter {$0.isASCII}).trimmingCharacters(in: .whitespaces)
                    let link = try link.attr("href")
                    episodes.append(Episode(number: number, link: link))
                }
                completed(.success(episodes))
            } catch {
                completed(.failure(.extractingData))
            }
            
        }
        
        task.resume()
    }
    
    
    
    func getSteamUrl(_ link: String, completed: @escaping (Result<String, PAError>)->Void) {
        
        guard let showUrl = URL(string: link) else {
            completed(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: showUrl) { (data, response, error) in
            
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
            
            do {
                
                let frames = try document.select("iframe").array()
                var frameLink = ""
                for frame in frames {
                    if try frame.attr("name") == "player_iframe" {
                        frameLink = try frame.attr("src")
                        break
                    }
                }
                
                self.getIframePage(frameLink) { (result) in
                    switch result {
                    case .failure(let error) :
                        completed(.failure(error))
                    case .success(let streamUrl) :
                        completed(.success(streamUrl))
                    }
                }
                
            } catch {
                completed(.failure(.extractingData))
            }
            
        }
        
        task.resume()
        
        
    }
    
    
    func getIframePage(_ link: String, completed: @escaping (Result<String, PAError>)->Void) {
        
        guard let iframeUrl = URL(string: link) else {
            completed(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: iframeUrl) { (data, response, error) in
            
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
            
            do {
                
                var buttons = try document.getElementsByClass("hd_btn").array()
                buttons.remove(at: 0)
                try buttons.sort { (e1, e2) -> Bool in
                    let q1 = try e1.text().dropLast()
                    let q2 = try e2.text().dropLast()
                    return Int(q1)! < Int(q2)!
                }
                
                completed(.success(try buttons.last!.attr("data-url")))
            } catch {
                completed(.failure(.extractingData))
            }
            
        }
        
        task.resume()
        
        
    }
    
    
}

// ÙØ³ÙØ³Ù
