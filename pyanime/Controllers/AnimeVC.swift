//
//  AnimeVC.swift
//  pyanime
//
//  Created by Mohammed Alessi on 21/04/2022.
//

import UIKit


class AnimeVC: UIViewController {
    
    let episodesTableView = UITableView()
    let mainImageView = UIImageView()
    var selectedSearchResult: SearchResult!
    var anime: Anime = Anime()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureEpisodesTableView()
        GogoanimeAPI.shared.getAnime(of: selectedSearchResult) { (result) in
            switch result {
            case .success(let anime) :
                self.anime = anime
                DispatchQueue.main.async {
                    self.episodesTableView.reloadData()
                }
            case .failure(let error) :
                DispatchQueue.main.async {
                    self.presentPAAlertOnMainThread(title: "Ooops", message: error.rawValue, buttonTitle: "Ok")
                }
            }
        }
    }
    
    
    func configureEpisodesTableView() {
        
        view.addSubview(episodesTableView)
        episodesTableView.rowHeight = 75
        episodesTableView.frame = view.bounds
        episodesTableView.separatorStyle = .none
        episodesTableView.delegate = self
        episodesTableView.dataSource = self
        episodesTableView.register(EpisodeCell.self, forCellReuseIdentifier: EpisodeCell.reuseID)
        episodesTableView.register(AnimeInfoCell.self, forCellReuseIdentifier: AnimeInfoCell.reuseID)
        episodesTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
}

extension AnimeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.view.frame.height * 0.30
        } else {
            return self.view.frame.height * 0.08
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // one for the info cell
        return anime.episodes.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let animeInfoCell = tableView.dequeueReusableCell(withIdentifier: AnimeInfoCell.reuseID) as! AnimeInfoCell
            animeInfoCell.set(anime: anime)
            return animeInfoCell
        }
        
        let episodeCell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.reuseID) as! EpisodeCell
        episodeCell.titleLable.text = "Episode \(anime.episodes[indexPath.row - 1].number)"
        return episodeCell
    }
    
    
}
