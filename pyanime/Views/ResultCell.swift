//
//  ResultCell.swift
//  pyanime
//
//  Created by Mohammed Alessi on 18/04/2022.
//

import UIKit


class ResultCell: UICollectionViewCell {
    
    static let reuseID: String = "ResultCell"
    
    let resultImageView = PAAvatarImageView(frame: .zero)
    let resultNameLabel = PATitleLabel(textAlignment: .center, fontSize: 16)
    let gradientView = UIView()
    let gradientLayer = CAGradientLayer()
    var backgroundMaskedView = GradientView()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureResultImageView()
        configureGradientView()
        configureResultnameLabel()
//        drawLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(result: SearchResult) {
        resultNameLabel.text = result.name
        resultImageView.downloadImage(from: result.imageUrl)
    }
    
    
    private func configureGradientView() {
        
        backgroundMaskedView.translatesAutoresizingMaskIntoConstraints = false
        
        resultImageView.addSubview(backgroundMaskedView)
        
        NSLayoutConstraint.activate([
            backgroundMaskedView.topAnchor.constraint(equalTo: resultImageView.topAnchor),
            backgroundMaskedView.leadingAnchor.constraint(equalTo: resultImageView.leadingAnchor),
            backgroundMaskedView.trailingAnchor.constraint(equalTo: resultImageView.trailingAnchor),
            backgroundMaskedView.bottomAnchor.constraint(equalTo: resultImageView.bottomAnchor)
        ])
        
    }
    
    
    private func configureResultImageView() {
        
        self.contentView.addSubview(resultImageView)
        
        NSLayoutConstraint.activate([
            resultImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            resultImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            resultImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            resultImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5)
        ])
        
    }
    
    
    private func configureResultnameLabel() {
        
        resultNameLabel.textColor = .white
        resultNameLabel.numberOfLines = 2
        self.contentView.addSubview(resultNameLabel)
        
        NSLayoutConstraint.activate([
            resultNameLabel.bottomAnchor.constraint(equalTo: resultImageView.bottomAnchor, constant: -20),
            resultNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            resultNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            resultNameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
//
//    override func layoutSubviews() {
//        gradientLayer.frame = gradientView.bounds
//    }
//
//    func drawLayer() {
//        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
//        gradientView.layer.insertSublayer(gradientLayer, at: 0)
//    }
//
//    override func layoutSublayers(of layer: CALayer) {
//        super.layoutSublayers(of: layer)
//        drawLayer()
//    }
//
    
    
}
