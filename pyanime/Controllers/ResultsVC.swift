//
//  ResultsVC.swift
//  pyanime
//
//  Created by Mohammed Alessi on 09/04/2022.
//

import UIKit

class ResultsVC: UIViewController {
    
    let searchQuery: String
    var results: [SearchResult] = []
    var resultsCollectionView: UICollectionView!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Results"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureResultsCollectionView()
        getSearchResults()
    }
    
    
    func getSearchResults() {
        
        FaselhdAPI.shared.search(for: searchQuery) { (result) in
            switch result {
            case .success(let results) :
                self.results = results
                DispatchQueue.main.async {
                    self.resultsCollectionView.reloadData()
                }
            case .failure(let error) :
                DispatchQueue.main.async {
                    self.presentPAAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "ok")
                }
            }
        }
    }
    
    
    func procedsToAnimeVC(with selectedSearchResult: SearchResult) {
        let animeVC = AnimeVC()
        animeVC.title = selectedSearchResult.name
        animeVC.selectedSearchResult = selectedSearchResult
        navigationController?.pushViewController(animeVC, animated: true)
    }
    
    
    func configureResultsCollectionView() {
        resultsCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: creatTwoColoumnFlowLayout())
        resultsCollectionView.backgroundColor = .systemBackground
        resultsCollectionView.register(ResultCell.self, forCellWithReuseIdentifier: ResultCell.reuseID)
        resultsCollectionView.dataSource = self
        resultsCollectionView.delegate = self
        view.addSubview(resultsCollectionView)
        resultsCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func creatTwoColoumnFlowLayout()-> UICollectionViewFlowLayout {
        
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimunItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - minimunItemSpacing
        let itemWidth = availableWidth / 2
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: CGFloat(itemWidth), height: itemWidth * 1.5)
        
        return flowLayout
    }
    
    
    init(searchQuery: String) {
        self.searchQuery = searchQuery
        super.init(nibName: nil, bundle: nil)
    }
    
}



extension ResultsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let resultCell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCell.reuseID, for: indexPath) as! ResultCell
        
        resultCell.set(result: results[indexPath.row])
        return resultCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = results[indexPath.row]
        procedsToAnimeVC(with: item)
    }
    
}
