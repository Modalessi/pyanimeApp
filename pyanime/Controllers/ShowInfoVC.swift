//
//  ShowInfoVC.swift
//  pyanime
//
//  Created by Mohammed Alessi on 27/05/2022.
//

import UIKit
import AVKit

class ShowInfoVC: UIViewController {
    
    let episodesTableView = UITableView()
    let mainImageView = PAAvatarImageView(frame: .zero)
    var selectedSearchResult: SearchResult!
    var show: Show = Show()
    var favouriteBarButton = UIBarButtonItem()
    var favourite: Favourite?
    var isFavourite: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favourite = PersistenceManager.dataController.getFavourite(for: selectedSearchResult)
        isFavourite = favourite != nil
        configureShowInofVC()
        configureEpisodesTableView()
        getShow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    func getShow() {
        self.showLoadingIndicator()
        FaselhdAPI.shared.getShow(for: selectedSearchResult) { [weak self] (result) in
            guard let self = self else { return }
            self.dismisLoadingIndicator()
            self.favouriteBarButton.isEnabled = true
            switch result {
            case .success(let show) :
                self.show = show
                
                DispatchQueue.main.async {
                    show.seasons?.sort(by: { (s1, s2) -> Bool in
                        Int(s1.number)! < Int(s2.number)!
                    })
                    self.episodesTableView.reloadData()
                }
            case .failure(let error) :
                DispatchQueue.main.async {
                    self.dismisLoadingIndicator()
                    self.presentPAAlertOnMainThread(title: "Ooops", message: error.rawValue, buttonTitle: "Ok")
                }
            }
            
        }
    }
    
    
    func configureShowInofVC() {
        favouriteBarButton = UIBarButtonItem(image: UIImage(systemName: isFavourite ? "star.fill" : "star"), style: .plain, target: self, action: #selector(favourtieBarButtonTouched))
        navigationItem.rightBarButtonItem = favouriteBarButton
        favouriteBarButton.isEnabled = false
    }
    
    
    @objc func favourtieBarButtonTouched() {
        isFavourite.toggle()
        let favouriteImageName = isFavourite ? "star.fill" : "star"
        let favouriteImage = UIImage(systemName: favouriteImageName)
        favouriteBarButton.image = favouriteImage
        
        if isFavourite {
            PersistenceManager.dataController.addToFavourites(show: show) { error in
                guard let error = error else { return }
                self.presentPAAlertOnMainThread(title: "Ooops", message: error.rawValue, buttonTitle: "Ok")
            }
        } else {
            guard let favourite = favourite else { return }
            PersistenceManager.dataController.removeFromFavourites(favourite) { error in
                guard let error = error else { return }
                self.presentPAAlertOnMainThread(title: "Ooops", message: error.rawValue, buttonTitle: "Ok")
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
        episodesTableView.register(ShowInfoCell.self, forCellReuseIdentifier: ShowInfoCell.reuseID)
        episodesTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func presentMoviePlayer(with streamUrl: String) {
        
        guard let url: URL = URL(string: streamUrl) else {
            print("invalid stream url")
            return
        }

        let player = AVPlayer(url: url)
        let playerController = AVPlayerViewController()
        playerController.player = player
        
        present(playerController, animated: true) {
            player.play()
        }
        
    }
    
    
}




extension ShowInfoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0 {
            return self.view.frame.height * 0.7
        } else {
            return self.view.frame.height * 0.08
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let seasons = show.seasons {
            return seasons.count + 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // one for the info cell
        if section == 0 {
            return 1
        }
        
        if show.isMovie {
            return 1
        }
        
        if let seasons = show.seasons {
            return seasons[section - 1].episodes.count
        } else {
            if let episodes = show.episodes {
                return episodes.count
            } else {
                return 0
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let seasons = show.seasons {
            return "season \(seasons[section].number)"
        } else {
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let hasSeasons = show.seasons != nil
        let sectionView: UIView = UIView()
        let sectionTitleLabel = PATitleLabel(textAlignment: .center, fontSize: 18)
        sectionTitleLabel.layer.cornerRadius = 10
        sectionTitleLabel.backgroundColor = .systemGray6
        sectionTitleLabel.clipsToBounds = true
        
        
        sectionTitleLabel.text = hasSeasons ? "season \(show.seasons![section - 1].number)" : "Episodes"
        sectionView.addSubview(sectionTitleLabel)
        NSLayoutConstraint.activate([
            sectionTitleLabel.topAnchor.constraint(equalTo: sectionView.topAnchor),
            sectionTitleLabel.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 10),
            sectionTitleLabel.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant: -10)
        ])
        return sectionView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? CGFloat.leastNonzeroMagnitude : 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 && indexPath.section == 0 {
            
            let infoCell = tableView.dequeueReusableCell(withIdentifier: ShowInfoCell.reuseID) as! ShowInfoCell
            infoCell.set(show: show)
            return infoCell
        }
        
        
        let episodeCell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.reuseID) as! EpisodeCell
                    
        let hasSeasons = show.seasons != nil
        
        
        if show.isMovie {
            episodeCell.titleLable.text = "Watch Movie"
        } else if hasSeasons {
            episodeCell.titleLable.text = "Episode \(show.seasons![indexPath.section - 1].episodes[indexPath.row].number)"
        } else {
            episodeCell.titleLable.text = "Episode \(show.episodes![indexPath.row].number)"
        }
        
        return episodeCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hasSeasons = show.seasons != nil
        var link = ""
        if show.isMovie {
            link = show.link
        } else if hasSeasons {
            link = show.seasons![indexPath.section - 1].episodes[indexPath.row].link
        } else {
            link = show.episodes![indexPath.row].link
        }
        showLoadingIndicator()
        FaselhdAPI.shared.getSteamUrl(link) { (result) in
            self.dismisLoadingIndicator()
            switch result {
            case .failure(let error) :
                print(error.rawValue)
            case .success(let streamUrl) :
                DispatchQueue.main.async {
                    print(streamUrl)
                    self.presentMoviePlayer(with: streamUrl)
                }
            }
        }
    }
    
}
