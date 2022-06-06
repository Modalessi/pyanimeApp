//
//  DisocveryVC.swift
//  pyanime
//
//  Created by Mohammed Alessi on 04/06/2022.
//

import UIKit

class DiscoveryVC: UIViewController {
    
    var discovery: [FaselhdAPI.DiscoverySection : [SearchResult]] = [.slideShow: [], .latestMovies: [], .bestShows: [], .latestSeriesEpisodes: [], .latestAnimeEpisodes: []]
    
    
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
        discoveryCollectionView.showsVerticalScrollIndicator = false
        discoveryCollectionView.showsHorizontalScrollIndicator = false
        discoveryCollectionView.delegate = self
        discoveryCollectionView.register(ResultCell.self, forCellWithReuseIdentifier: ResultCell.reuseID)
        discoveryCollectionView.register(DiscoveryCollectionEpisodeCell.self, forCellWithReuseIdentifier: DiscoveryCollectionEpisodeCell.reuseID)
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
            
            let section = FaselhdAPI.DiscoverySection.allCases[indexPath.section]
            
            switch section {
                
            case .bestShows, .slideShow, .latestMovies :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCell.reuseID, for: indexPath) as! ResultCell
                cell.set(result: searchResult)
                return cell
            
            case .latestAnimeEpisodes, .latestSeriesEpisodes :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoveryCollectionEpisodeCell.reuseID, for: indexPath) as! DiscoveryCollectionEpisodeCell
                cell.setWith(searchResult)
                return cell
                
            }
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
            let section = FaselhdAPI.DiscoverySection.allCases[sectionIndex]
            switch section {
            case .slideShow, .latestMovies, .bestShows :
                return self.generateSlideLayout()
            case .latestSeriesEpisodes, .latestAnimeEpisodes :
                return self.generateHorzintalLayout()
            }
        }
        
        return layout
    }
    
    
    func generateSlideLayout()-> NSCollectionLayoutSection {
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
    
    
    func generateHorzintalLayout()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
          heightDimension: .fractionalHeight(0.1))
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
        return section
    }
    
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<FaselhdAPI.DiscoverySection, SearchResult> {
        var snapshot = NSDiffableDataSourceSnapshot<FaselhdAPI.DiscoverySection, SearchResult>()
        snapshot.appendSections([FaselhdAPI.DiscoverySection.slideShow])
        snapshot.appendItems(discovery[.slideShow]!)
        
        snapshot.appendSections([FaselhdAPI.DiscoverySection.latestMovies])
        snapshot.appendItems(discovery[.latestMovies]!)
        
        snapshot.appendSections([FaselhdAPI.DiscoverySection.bestShows])
        snapshot.appendItems(discovery[.bestShows]!)
        
        snapshot.appendSections([FaselhdAPI.DiscoverySection.latestSeriesEpisodes])
        snapshot.appendItems(discovery[.latestSeriesEpisodes]!)
        
        snapshot.appendSections([FaselhdAPI.DiscoverySection.latestAnimeEpisodes])
        snapshot.appendItems(discovery[.latestAnimeEpisodes]!)

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
    
    
    func procedsToShowVC(with selectedSearchResult: SearchResult) {
        let showVC = ShowInfoVC()
        showVC.title = selectedSearchResult.name
        showVC.selectedSearchResult = selectedSearchResult
        navigationController?.pushViewController(showVC, animated: true)
    }
    
}



extension DiscoveryVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionNumber = indexPath.section
        let rowNumber = indexPath.row
        let section = FaselhdAPI.DiscoverySection.allCases[sectionNumber]
        let selectedShow = discovery[FaselhdAPI.DiscoverySection.allCases[sectionNumber]]![rowNumber]
        
        if section == .latestAnimeEpisodes || section == .latestSeriesEpisodes {
            self.showLoadingIndicator()
            FaselhdAPI.shared.getPoster(from: selectedShow.link) { result in
                self.dismisLoadingIndicator()
                switch result {
                case .success(let imageLink) :
                    selectedShow.imageUrl = imageLink
                    DispatchQueue.main.async {
                        self.procedsToShowVC(with: selectedShow)
                    }
                case .failure(let error) :
                    print(error)
                }
            }
        } else {
            procedsToShowVC(with: selectedShow)
        }
        
    }
    
}
