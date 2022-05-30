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
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureResultImageView()
        configureGradientView()
        configureResultnameLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(result: SearchResult) {
        resultNameLabel.text = result.name
        resultImageView.downloadImage(from: result.imageUrl)
    }
    
    
    private func configureGradientView() {
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(gradientView)
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: resultImageView.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: resultImageView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: resultImageView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: resultImageView.bottomAnchor)
        ])
        
    }
    
    
    private func configureResultImageView() {
        
        addSubview(resultImageView)
        
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
        addSubview(resultNameLabel)
        
        NSLayoutConstraint.activate([
            resultNameLabel.bottomAnchor.constraint(equalTo: resultImageView.bottomAnchor, constant: -20),
            resultNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            resultNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            resultNameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    
    func drawLayer() {
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        drawLayer()
    }
    
}
