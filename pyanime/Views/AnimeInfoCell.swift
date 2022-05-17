//
//  AnimeInfoCell.swift
//  pyanime
//
//  Created by Mohammed Alessi on 17/05/2022.
//

import UIKit

class AnimeInfoCell: UITableViewCell {
    
    
    static let reuseID = "AnimeInfoCell"
    
    let mainView = UIView()
    let titleLabel = PATitleLabel(textAlignment: .left, fontSize: 22)
    let plotLabel = PABodyLabel(textAlignment: .left)
    let posterImageView = PAAvatarImageView(frame: .zero)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureUI() {
        configureMainView()
        configurePosterImageView()
        configureTitleLabel()
        configurePlotLabel()
    }
    
    
    func configureMainView() {
        
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = .secondarySystemBackground
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
    }
    
    
    func configurePosterImageView() {
        mainView.addSubview(posterImageView)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 5),
            posterImageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 5),
            posterImageView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -5),
            posterImageView.widthAnchor.constraint(equalTo: posterImageView.heightAnchor, multiplier: 0.6)
        ])
        
    }
    
    
    func configureTitleLabel() {
        mainView.addSubview(titleLabel)
        titleLabel.numberOfLines = 2
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    func configurePlotLabel() {
        plotLabel.numberOfLines = 0
        plotLabel.font = UIFont.systemFont(ofSize: 15)
        mainView.addSubview(plotLabel)
        NSLayoutConstraint.activate([
            plotLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            plotLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 5),
            plotLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -5),
            plotLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -5)
        ])
    }
    
    
    func set(anime: Anime) {
        titleLabel.text = anime.name
        plotLabel.text = anime.plot
        posterImageView.downloadImage(from: anime.imageUrl)
    }
    
    
}
