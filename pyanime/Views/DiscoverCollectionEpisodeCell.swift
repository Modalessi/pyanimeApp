//
//  DiscoverCollectionEpisodeCell.swift
//  pyanime
//
//  Created by Mohammed Alessi on 05/06/2022.
//

import UIKit


class DiscoveryCollectionEpisodeCell: UICollectionViewCell {
    
    static let reuseID: String = "DiscoveryCollectionEpisodeCell"
    
    let mainImage = PAAvatarImageView(frame: .zero)
    let title = PASecondaryLabel(textAlignment: .left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        contentView.addSubview(mainImage)
        contentView.addSubview(title)
        
        let padding: CGFloat = 2
        
        NSLayoutConstraint.activate([
            mainImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            mainImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            mainImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            mainImage.widthAnchor.constraint(equalTo: mainImage.heightAnchor),
            
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            title.leadingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: 10),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
        
    }
    
    
    func setWith(_ searchResult: SearchResult) {
        self.mainImage.downloadImage(from: searchResult.imageUrl)
        self.title.text = searchResult.name
    }
    
}
