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
    let plotLabel = PABodyLabel(textAlignment: .left)
    let posterImageView = PAAvatarImageView(frame: .zero)
    let gradientLayer = CAGradientLayer()
    
    
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
        plotLabel.textAlignment = .center
        mainView.addSubview(plotLabel)
        NSLayoutConstraint.activate([
            plotLabel.topAnchor.constraint(equalTo: mainView.centerYAnchor),
            plotLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 5),
            plotLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -5),
            plotLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -5)
        ])
    }
    
    func drawLayer() {
        gradientLayer.frame = posterImageView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        posterImageView.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        drawLayer()
    }
    
    
    func set(show: Show) {
        plotLabel.text = show.imdbDetails.description
        posterImageView.downloadImage(from: show.imageUrl)
    }
    
    
}
