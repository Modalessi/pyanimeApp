//
//  ShowInfoVC.swift
//  pyanime
//
//  Created by Mohammed Alessi on 27/05/2022.
//

import UIKit

class ShowInfoVC: UIViewController {
    
    var selectedSearchResult: SearchResult!
    var show: Show!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        FaselhdAPI.shared.getShow(for: selectedSearchResult) { (result) in
            
            switch result {
            case .success(let show) :
                self.show = show
                self.printData()
            case .failure(let error) :
                DispatchQueue.main.async {
                    self.presentPAAlertOnMainThread(title: "Ooops", message: error.rawValue, buttonTitle: "Ok")
                }
            }
            
        }
        
        

        
    }
    
    
    func printData() {
        print(show.isMovie)
        if let seasons = show.seasons {
            for season in seasons {
                print("season [\(season.number)] -----------")
                
                for episode in season.episodes {
                    print("     - episode [\(episode.number)] - \(episode.link)")
                }
            }
        }

        if let episodes = show.episodes {
            for episode in episodes {
                print("episode [\(episode.number)] - \(episode.link)")
            }
        }
    }
    
    
}
