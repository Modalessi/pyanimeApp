//
//  FavouriteVC.swift
//  pyanime
//
//  Created by Mohammed Alessi on 01/06/2022.
//

import UIKit


class FavouriteVC: UIViewController {
    
    var favouritesCollectionView: UICollectionView!
    var favourites: [Favourite] = []
    let emptyStateView = UIView()
    let favouriteIconImage = UIImage(systemName: "star")
    let emptyStateImageView = UIImageView()
    let emptyStateLabel = PATitleLabel(textAlignment: .center, fontSize: 24)


    
    override func viewDidLoad() {
        configureFavouritesCollectionView()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavourites()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    func configureFavouritesCollectionView() {
        favouritesCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: creatTwoColoumnFlowLayout())
        favouritesCollectionView.backgroundColor = .systemBackground
        favouritesCollectionView.register(ResultCell.self, forCellWithReuseIdentifier: ResultCell.reuseID)
        favouritesCollectionView.dataSource = self
        favouritesCollectionView.delegate = self
        view.addSubview(favouritesCollectionView)
        favouritesCollectionView.translatesAutoresizingMaskIntoConstraints = false
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
    
    func getFavourites() {
        PersistenceManager.dataController.getFavourites { result in
            switch result {
            case .success(let favourites) :
                self.favourites = favourites
                favouritesCollectionView.reloadData()
                if favourites.isEmpty {
                    showEmptyState()
                } else {
                    removeEmptyState()
                }
            case .failure(let error) :
                print(error.rawValue)
            }
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        removeEmptyState()
    }
    
    func removeEmptyState() {
        guard emptyStateView.superview != nil, emptyStateLabel.superview != nil else { return }
        emptyStateView.removeFromSuperview()
        emptyStateLabel.removeFromSuperview()
    }
    
    
    func showEmptyState() {
        emptyStateImageView.image = favouriteIconImage
        emptyStateImageView.tintColor = .darkGray
        emptyStateImageView.contentMode = .scaleAspectFill
        emptyStateImageView.clipsToBounds = true
        emptyStateLabel.text = "you dont have any favourites"
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.textColor = .darkGray
        
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(emptyStateImageView)
        view.addSubview(emptyStateLabel)
        NSLayoutConstraint.activate([

            emptyStateImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            emptyStateImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),

        
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 20),
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emptyStateLabel.heightAnchor.constraint(equalToConstant: 30)

        ])
        
        
    }
    
    
    func procedsToShowVC(with selectedSearchResult: SearchResult, favourite: Favourite) {
        let showVC = ShowInfoVC()
        showVC.title = selectedSearchResult.name
        showVC.selectedSearchResult = selectedSearchResult
        navigationController?.pushViewController(showVC, animated: true)
    }
    
    
}



extension FavouriteVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favourites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let resultCell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCell.reuseID, for: indexPath) as! ResultCell
        
        resultCell.set(result: SearchResult(favourite: favourites[indexPath.row]))
        return resultCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = favourites[indexPath.row]
        procedsToShowVC(with: SearchResult(favourite: item), favourite: item)
    }
}
