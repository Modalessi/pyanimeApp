//
//  Anime.swift
//  pyanime
//
//  Created by Mohammed Alessi on 20/04/2022.
//

import UIKit

class Anime: SearchResult {
    var plot: String
    var episodes: [Episode]
    
    
    init(searchResult: SearchResult, plot: String, episodes: [Episode]) {
        self.episodes = episodes
        self.plot = plot
        super.init(name: searchResult.name, link: searchResult.link, imageUrl: searchResult.imageUrl)
    }
    
    init() {
        self.episodes = []
        self.plot = ""
        super.init(name: "", link: "", imageUrl: "")
    }
    
}
