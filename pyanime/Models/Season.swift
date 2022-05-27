//
//  Season.swift
//  pyanime
//
//  Created by Mohammed Alessi on 27/05/2022.
//



class Season {
    
    var number: String
    var episodes: [Episode]
    
    init(number: String, episodes: [Episode]) {
        self.number = number
        self.episodes = episodes
    }
    
    init() {
        self.number = ""
        self.episodes = []
    }
    
}
