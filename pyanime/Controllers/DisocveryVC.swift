//
//  DisocveryVC.swift
//  pyanime
//
//  Created by Mohammed Alessi on 04/06/2022.
//

import UIKit

class DiscoveryVC: UIViewController {
    
    var discovery: [FaselhdAPI.DiscoverySection : [SearchResult]] = [.slideShow: [], .latestMovies: [], .bestShows: []]
    
    
    var discoveryCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<FaselhdAPI.DiscoverySection, SearchResult>!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDiscovery()
        configureDiscoveryCollectionView()
        configureDataSource()
    }
    
    
    
    func configureDiscoveryCollectionView() {
        discoveryCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        discoveryCollectionView.backgroundColor = .systemBackground
        discoveryCollectionView.delegate = self
        discoveryCollectionView.register(ResultCell.self, forCellWithReuseIdentifier: ResultCell.reuseID)
        discoveryCollectionView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: CollectionViewHeader.reuseID, withReuseIdentifier: CollectionViewHeader.reuseID)
        
        discoveryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(discoveryCollectionView)
        NSLayoutConstraint.activate([
            discoveryCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            discoveryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            discoveryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            discoveryCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<FaselhdAPI.DiscoverySection, SearchResult>(collectionView: discoveryCollectionView, cellProvider: { collectionView, indexPath, searchResult in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCell.reuseID, for: indexPath) as! ResultCell
            
                cell.set(result: searchResult)
                return cell
        })
        
        dataSource.supplementaryViewProvider = {(collectionView: UICollectionView, kind: String, indexPath: IndexPath) in
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: CollectionViewHeader.reuseID, withReuseIdentifier: CollectionViewHeader.reuseID, for: indexPath) as! CollectionViewHeader
            header.label.text = FaselhdAPI.DiscoverySection.allCases[indexPath.section].rawValue
            return header
        }
        
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
            
    func generateLayout()-> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.47),
              heightDimension: .fractionalHeight(0.33))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            group.contentInsets = NSDirectionalEdgeInsets(
              top: 5,
              leading: 5,
              bottom: 5,
              trailing: 5)
            
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(40))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: CollectionViewHeader.reuseID, alignment: .top)
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [headerItem]
            section.orthogonalScrollingBehavior = .continuous
            section.accessibilityScroll(.right)
            return section
        }
        
        return layout
    }
    
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<FaselhdAPI.DiscoverySection, SearchResult> {
        var snapshot = NSDiffableDataSourceSnapshot<FaselhdAPI.DiscoverySection, SearchResult>()
        snapshot.appendSections([FaselhdAPI.DiscoverySection.slideShow])
        snapshot.appendItems(discovery[.slideShow]!)
        
        snapshot.appendSections([FaselhdAPI.DiscoverySection.latestMovies])
        snapshot.appendItems(discovery[.latestMovies]!)
        
        snapshot.appendSections([FaselhdAPI.DiscoverySection.bestShows])
        snapshot.appendItems(discovery[.bestShows]!)

        return snapshot
    }
    
    func getDiscovery() {
        FaselhdAPI.shared.getDiscovery { result in
            switch result {
            case .success(let discovery) :
                self.discovery = discovery
                DispatchQueue.main.async {
                    self.dataSource.apply(self.snapshotForCurrentState(), animatingDifferences: false)
                }
            case .failure(let error) :
                self.presentPAAlertOnMainThread(title: "Oops", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
}



extension DiscoveryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0 :
            return discovery[.slideShow]!.count
        case 1 :
            return discovery[.latestMovies]!.count
        case 2 :
            return discovery[.bestShows]!.count
        default :
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let resultCell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCell.reuseID, for: indexPath) as! ResultCell
        
        
        var section: FaselhdAPI.DiscoverySection = .bestShows
        if collectionView.tag == 0 {
            section = .slideShow
        } else if collectionView.tag == 1 {
            section = .latestMovies
        } else {
            section = .bestShows
        }
        
        
        resultCell.set(result: discovery[section]![indexPath.row])
        return resultCell
    }
    
}
