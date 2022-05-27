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
    
    init(from searchResult: SearchResult, isMovie: Bool, seasons: [Season]?, episodes: [Episode]?) {
        self.isMovie = isMovie
        self.seasons = seasons
        self.episodes = episodes
        super.init(name: searchResult.name, link: searchResult.link, imageUrl: searchResult.imageUrl)
    }
    
    init() {
        self.isMovie = false
        self.seasons = nil
        self.episodes = nil
        super.init(name: "", link: "", imageUrl: "")
    }
    
}
