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
    
    enum DiscoverySection: String, CaseIterable {
        case slideShow = "Featured Shows"
        case latestMovies = "Latest Movies"
        case bestShows = "Best Shows"
        case latestSeriesEpisodes = "Latest Episodes"
        case latestAnimeEpisodes = "Latest Anime Episodes"
    }
    
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
                    
                    
                    
                    if let data = searchResultName!.data(using: .isoLatin1) {
                        searchResultName = String(data: data, encoding: .utf8) ?? "season"
                    } else {
                        searchResultName = String((searchResultName?.filter {$0.isASCII}) ?? "").trimmingCharacters(in: .whitespaces)
                    }
                    
                    
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
    
    
    
//    private func getImdbDetails(for document: Document) throws -> ImdbShowDetails {
//        var details = ImdbShowDetails()
//
//        do {
//            let discreptionDiv = try document.getElementsByClass("singleDesc").first()?.getElementsByTag("p").first()
//            var discreption = try discreptionDiv?.text()
//            if let data = discreption!.data(using: .isoLatin1) {
//                discreption = String(data: data, encoding: .utf8)
//            } else {
//                throw PAError.extractingData
//            }
//            details.description = discreption!
//
//            let detailsDivs = try document.getElementsByClass("col-xl-6 col-lg-6 col-md-6 col-sm-6")
//
//            for div in detailsDivs {
//                var label = try div.getElementsByTag("span").first()?.text()
//                let data = label!.data(using: .isoLatin1)
//                label = String(data: data!, encoding: .utf8)
//
//                if label!.contains("?????????? ") {
//                    let genersTags = try div.getElementsByTag("a").array()
//                    var geners = try genersTags.map {try $0.text()}
//                    geners = geners.map { String(data: $0.data(using: .isoLatin1)!, encoding: .utf8)! }
//                    details.genres = geners
//
//
//                } else if label!.contains("?????????? ") || label!.contains("?????? ") {
//                    var duration = try div.getElementsByTag("span").first()?.text()
//                    duration = String(duration!.filter { $0.isNumber })
//                    details.runtime = duration!
//
//
//                } else if label!.contains("?????? ") {
//                    var id = try div.getElementsByTag("span").first()?.text()
//                    id = String(id!.filter { $0.isASCII })
//                    details.id = id!
//
//                } else if label!.contains("???????? ") {
//                    let quilityTags = try div.getElementsByTag("a").array()
//                    let quialities = try quilityTags.map {try $0.text()}
//                    details.quilities = quialities.joined(separator: ", ")
//                }
//            }
//
//
//            let starRatingDiv = try document.getElementsByClass("starSys").first()
//            let ratingText = try starRatingDiv!.text()
//
//            let rating = String((ratingText.split(separator: " ").filter { $0.contains(".") }).first!)
//            details.rating = rating
//
//            let titleDiv = try document.getElementsByClass("h1 title").first()
//            let title = try titleDiv?.text()
//            details.title = title!
//
//
//
//            return details
//
//        } catch let error {
//            throw error
//        }
//
//    }
    
    
    
    private func hasSeasons(_ document: Document)->Bool {
        do {
            let seasonsDiv = try document.getElementById("seasonList")
            return seasonsDiv != nil
        } catch {
            return false
        }
    }
    
    
    private func isMovie(_ document: Document)-> Bool {
        do {
            let episodesDiv = try document.getElementById("epAll")
            return episodesDiv == nil
        } catch {
            return false
        }
    }
    
    
    private func getSeasons(_ document: Document, completed: @escaping (Result<[Season], PAError>)->Void) {
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
                title = String((title.filter {$0.isASCII})).trimmingCharacters(in: .whitespaces)
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
    
    
    private func getEpisodes(_ link: String, completed: @escaping (Result<[Episode], PAError>)->Void) {
        
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
    
    
    private func getIframePage(_ link: String, completed: @escaping (Result<String, PAError>)->Void) {
        
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
    
    
    
    
    func getDiscovery(completed: @escaping (Result<[DiscoverySection:[SearchResult]], PAError>)->Void) {
        var discoveryUrlComponent = URLComponents(url: FaselhdAPI.baseUrl, resolvingAgainstBaseURL: true)
        
        discoveryUrlComponent?.path = "/m1"
        
        guard let discoveryUrl = discoveryUrlComponent?.url else {
            completed(.failure(.invalidUrl))
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: discoveryUrl) { data, response, error in
            
            guard let data = data, error == nil else {
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
                
                let slideShowDivs = try document.getElementsByClass("row align-items-center")
                let slidesShows = try self.getSlideShows(from: slideShowDivs)
                
                let latestMoviesDivs = try document.getElementsByClass("col-xl-2 col-lg-2 col-md-2 col-sm-3")
                let latestMovies = try self.getLatestMovies(from: latestMoviesDivs)
                
                let bestShowsDivs = try document.getElementsByClass("col-xl-2 col-lg-2 col-md-3 col-sm-3")
                let bestShows = try self.getBestShows(from: bestShowsDivs)
                
                let latestEpisodesDivs = try document.getElementsByClass("epDivHome")
                let latestEpisodes = try self.getLatestEpisodes(from: latestEpisodesDivs)
                
                let latestSeriesEpisodes = latestEpisodes[0...5].map { $0 }
                let latestAnimeEpisodes = latestEpisodes[6...11].map { $0 }
                completed(.success([
                    .slideShow: slidesShows,
                    .latestMovies: latestMovies,
                    .bestShows: bestShows,
                    .latestSeriesEpisodes: latestSeriesEpisodes,
                    .latestAnimeEpisodes: latestAnimeEpisodes
                ]))
                
            } catch {
                completed(.failure(.extractingData))
            }
            
        }
        
        task.resume()
        
        
    }
    
    
    
    private func getSlideShows(from slides: Elements) throws -> [SearchResult]  {
        var shows: [SearchResult] = []
        
        for slide in slides.array() {
            
            do {
                let imageLink = try slide.getElementsByClass("img-fluid wp-post-image").first()?.attr("src")
                let titleDiv = try slide.getElementsByClass("h1 mb-1").first()
                var title = try titleDiv!.getElementsByTag("a").first()?.text()
                let link = try titleDiv!.getElementsByTag("a").first()?.attr("href")
                
                if let data = title!.data(using: .isoLatin1) {
                    title = String(data: data, encoding: .utf8) ?? "season"
                } else {
                    title = String((title?.filter {$0.isASCII}) ?? "").trimmingCharacters(in: .whitespaces)
                }
                                
                shows.append(SearchResult(name: title!, link: link!, imageUrl: imageLink!))
                
            } catch let error {
                throw error
            }
            
            
        }
        
        return shows
    }
    
    
    private func getLatestMovies(from latestMoviesDivs: Elements) throws -> [SearchResult] {
        var shows: [SearchResult] = []
        
        for movieDiv in latestMoviesDivs.array()[0...11] {
            
            do {
                let link = try movieDiv.getElementsByTag("a").first()?.attr("href")
                let imageLink = try movieDiv.getElementsByTag("img").first()?.attr("data-src")
                var title = try movieDiv.getElementsByClass("h5").first()?.text()
                
                if let data = title!.data(using: .isoLatin1) {
                    title = String(data: data, encoding: .utf8) ?? "season"
                } else {
                    title = String((title?.filter {$0.isASCII}) ?? "").trimmingCharacters(in: .whitespaces)
                }
                                
                shows.append(SearchResult(name: title!, link: link!, imageUrl: imageLink!))
            } catch let error {
                throw error
            }
            
        }
        
        
        return shows
    }
    
    
    private func getBestShows(from bestShowsDivs: Elements) throws -> [SearchResult] {
        var shows: [SearchResult] = []
        
        do {
            for showDiv in bestShowsDivs.array() {
                let link = try showDiv.getElementsByTag("a").first()?.attr("href")
                let imageLink = try showDiv.getElementsByTag("img").first()?.attr("data-src")
                var title = try showDiv.getElementsByClass("h5").first()?.text()
                
                if let data = title!.data(using: .isoLatin1) {
                    title = String(data: data, encoding: .utf8) ?? "season"
                } else {
                    title = String((title?.filter {$0.isASCII}) ?? "").trimmingCharacters(in: .whitespaces)
                }
                
                
                shows.append(SearchResult(name: title!, link: link!, imageUrl: imageLink!))
            }
        } catch let error {
            throw error
        }
        
        return shows
    }
    
    
    private func getLatestEpisodes(from latestEpisodesDiv: Elements) throws -> [SearchResult] {
        var latestEpisodes: [SearchResult] = []
        
        do {
            for episodeDiv in latestEpisodesDiv.array() {
                let link = try episodeDiv.getElementsByTag("a").first()?.attr("href")
                let imageLink = try episodeDiv.getElementsByTag("img").first()?.attr("data-src")
                var title = try episodeDiv.getElementsByClass("h4").first()?.text()
                
                if let data = title!.data(using: .isoLatin1) {
                    title = String(data: data, encoding: .utf8) ?? "season"
                } else {
                    title = String((title?.filter {($0.isLetter || $0.isWhitespace) && $0.isASCII}) ?? "").trimmingCharacters(in: .whitespaces)
                }
                
                latestEpisodes.append(SearchResult(name: title!, link: link!, imageUrl: imageLink!))
            }
        } catch let error {
            throw error
        }
        
        return latestEpisodes
    }
    
    
    func getPoster(from link: String, completed: @escaping (Result<String, PAError>)->Void) {
        
        guard let showUrl = URL(string: link) else {
            completed(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: showUrl) { data, response, error in
            guard let data = data, error == nil else { return }
            
            
            guard let html = String(data: data, encoding: .ascii) else {
                completed(.failure(.fetchHtml))
                return
            }
            
            guard let document = try? SwiftSoup.parse(html) else {
                completed(.failure(.htmlParsing))
                return
            }
            
            do {
                let imageDiv = try document.getElementsByClass("img-fluid poster").first()
                let imageLink = try imageDiv?.attr("src")
                
                completed(.success(imageLink!))
            } catch {
                completed(.failure(.extractingData))
            }
            
        }
        
        task.resume()
    }
    
}

