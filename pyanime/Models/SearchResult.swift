//
//  SearchResult.swift
//  pyanime
//
//  Created by Mohammed Alessi on 18/04/2022.
//


class SearchResult: Hashable {
    var name: String
    var link: String
    var imageUrl: String
    
    init(name: String, link: String, imageUrl: String) {
        self.name = name
        self.link = link
        self.imageUrl = imageUrl
    }
    
    init(favourite: Favourite) {
        self.name = favourite.name!
        self.link = favourite.link!
        self.imageUrl = favourite.imageUrl!
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(link)
    }
    
    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        return lhs.link == rhs.link
    }
    
}
