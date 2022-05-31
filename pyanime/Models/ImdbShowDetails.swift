//
//  ShowDetails.swift
//  pyanime
//
//  Created by Mohammed Alessi on 29/05/2022.
//

import Foundation




struct ImdbShowDetails: Decodable {
    var id: String
    var title: String
    var rating: Float
    var rating_count: Int
    var release_year: Int
    var description: String
    var popularity: Int
    var imdb_type: String
    var runtime: String
    var genres: [String]
    var image: String
    
    init() {
        self.id = ""
        self.title = ""
        self.rating = 0
        self.rating_count = 0
        self.release_year = 0
        self.description = ""
        self.popularity = 0
        self.imdb_type = ""
        self.runtime = ""
        self.genres = []
        self.image = ""
    }
    
}
