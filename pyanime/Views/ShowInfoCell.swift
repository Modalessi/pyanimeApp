//
//  AnimeInfoCell.swift
//  pyanime
//
//  Created by Mohammed Alessi on 17/05/2022.
//

import UIKit

class ShowInfoCell: UITableViewCell {
    
    
    static let reuseID = "ShowInfoCell"
    
    let mainView = UIView()
    let plotLabel = PABodyLabel(textAlignment: .center)
    let posterImageView = PAAvatarImageView(frame: .zero)
    let gradientLayer = CAGradientLayer()
    let genersLabel = PABodyLabel(textAlignment: .center)
    let releaseYearLabel = PABodyLabel(textAlignment: .center)
    let releaseYearIcon = UIImageView(image: UIImage(systemName: "calendar"))
    let runtimeLabel = PABodyLabel(textAlignment: .center)
    let runtimeIcon = UIImageView(image: UIImage(systemName: "clock.arrow.circlepath"))
    let ratingLabel = PABodyLabel(textAlignment: .center)
    let ratingIcon = UIImageView(image: UIImage(systemName: "star"))
    let detailsStackView = UIStackView()
    let miniDetailsStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureUI() {
        configureMainView()
        configurePosterImageView()
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
            posterImageView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            posterImageView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            posterImageView.heightAnchor.constraint(equalTo: mainView.heightAnchor),
            posterImageView.widthAnchor.constraint(equalTo: mainView.widthAnchor)
        ])
        
    }
    
    
    func configurePlotLabel() {
        plotLabel.numberOfLines = 0
        plotLabel.font = UIFont.systemFont(ofSize: 15)
        plotLabel.textColor = .white
        mainView.addSubview(plotLabel)
        NSLayoutConstraint.activate([
            plotLabel.topAnchor.constraint(equalTo: mainView.centerYAnchor),
            plotLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 5),
            plotLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -5),
        ])
    }
    
    
    func configureDetailsStackView() {
        
        detailsStackView.addArrangedSubview(genersLabel)
        detailsStackView.addArrangedSubview(miniDetailsStackView)
        
        miniDetailsStackView.addArrangedSubview(releaseYearIcon)
        miniDetailsStackView.addArrangedSubview(releaseYearLabel)
        
        miniDetailsStackView.addArrangedSubview(runtimeIcon)
        miniDetailsStackView.addArrangedSubview(runtimeLabel)
        
        miniDetailsStackView.addArrangedSubview(ratingIcon)
        miniDetailsStackView.addArrangedSubview(ratingLabel)
        
        
        detailsStackView.alignment = .center
        detailsStackView.axis = .vertical
        detailsStackView.spacing = 10
        
        miniDetailsStackView.alignment = .center
        miniDetailsStackView.axis = .horizontal
        miniDetailsStackView.spacing = 10
        
        genersLabel.textColor = .white
        releaseYearLabel.textColor = .white
        runtimeLabel.textColor = .white
        ratingLabel.textColor = .white
        
        releaseYearIcon.tintColor = .white
        runtimeIcon.tintColor = .white
        ratingIcon.tintColor = .white
        
        
        mainView.addSubview(detailsStackView)
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        miniDetailsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            detailsStackView.topAnchor.constraint(equalTo: plotLabel.bottomAnchor, constant: 5),
            detailsStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10),
            detailsStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10),
            detailsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    
    
    func drawLayer() {
        // add gradient layer above the poster image view
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 0.75]
        gradientLayer.frame = posterImageView.bounds
        posterImageView.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        drawLayer()
    }
    
    
    func set(show: Show) {
        
        if show.imdbDetails.id != "" { configureDetailsStackView() }
        plotLabel.text = show.imdbDetails.description
        genersLabel.text = show.imdbDetails.genres.joined(separator: " • ")
        releaseYearLabel.text = "\(show.imdbDetails.release_year)"
        runtimeLabel.text = show.imdbDetails.runtime
        ratingLabel.text = "\(show.imdbDetails.rating)"
        posterImageView.downloadImage(from: show.imageUrl)
    }
    
    
}
