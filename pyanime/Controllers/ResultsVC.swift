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
    let emptyStateView = UIView()
    
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
    
    
    func showEmptyState() {
        
        let sadFaceIconImage = UIImage(named: "sad-face")!
        let emptyStateImageView = UIImageView(image: sadFaceIconImage)
        emptyStateImageView.tintColor = .darkGray
        emptyStateImageView.contentMode = .scaleAspectFill
        emptyStateImageView.clipsToBounds = true
        let emptyStateLabel = PATitleLabel(textAlignment: .center, fontSize: 24)
        emptyStateLabel.text = "sorry, it seems there is no results"
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.textColor = .darkGray
        
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emptyStateView)
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
        
        emptyStateView.bounds = resultsCollectionView.bounds
        NSLayoutConstraint.activate([
            
            emptyStateImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor, constant: 150),
            emptyStateImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            emptyStateImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                        
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 20),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 20),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -20),
            emptyStateLabel.heightAnchor.constraint(equalToConstant: 30)
            
        ])
        
    }
    
    
    func getSearchResults() {
        
        FaselhdAPI.shared.search(for: searchQuery) { (result) in
            switch result {
            case .success(let results) :
                self.results = results
                DispatchQueue.main.async {
                    if self.results.count == 0 {
                        print("showing empty state")
                        self.showEmptyState()
                    } else {
                        self.resultsCollectionView.reloadData()
                    }
                }
            case .failure(let error) :
                DispatchQueue.main.async {
                    self.presentPAAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "ok")
                }
            }
        }
    }
    
    
    func procedsToShowVC(with selectedSearchResult: SearchResult) {
        let showVC = ShowInfoVC()
        showVC.title = selectedSearchResult.name
        showVC.selectedSearchResult = selectedSearchResult
        navigationController?.pushViewController(showVC, animated: true)
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
        procedsToShowVC(with: item)
    }
    
}
