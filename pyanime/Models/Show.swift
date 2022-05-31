//
//  Show.swift
//  pyanime
//
//  Created by Mohammed Alessi on 27/05/2022.
//


class Show: SearchResult {
    
    var isMovie: Bool
    var seasons: [Season]?
    var episodes: [Episode]?
    var imdbDetails: ImdbShowDetails
    
    init(from searchResult: SearchResult, imdbDetails: ImdbShowDetails,isMovie: Bool, seasons: [Season]?, episodes: [Episode]?) {
        self.isMovie = isMovie
        self.seasons = seasons
        self.episodes = episodes
        self.imdbDetails = imdbDetails
        super.init(name: searchResult.name, link: searchResult.link, imageUrl: searchResult.imageUrl)
    }
    
    init() {
        self.isMovie = false
        self.seasons = nil
        self.episodes = nil
        self.imdbDetails = ImdbShowDetails()
        super.init(name: "", link: "", imageUrl: "")
    }
    
}
