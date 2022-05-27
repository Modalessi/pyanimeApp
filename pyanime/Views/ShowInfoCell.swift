//
//  ShowInfoCell.swift
//  pyanime
//
//  Created by Mohammed Alessi on 27/05/2022.
//

import UIKit

class ShowInfoCell: UITableViewCell {
    
    
    static let reuseID: String = "showInfoCell"
    
    let resultImageView = PAAvatarImageView(frame: .zero)
    let gradientView = UIView()
    let gradientLayer = CAGradientLayer()
    let mainView = UIView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureMainView()
        configureResultImageView()
        configureGradientView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(_ show: Show) {
        DispatchQueue.main.async {
            self.resultImageView.downloadImage(from: show.imageUrl)
        }
    }
    
    
    private func configureMainView() {
        
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
    
    
    private func configureGradientView() {
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubview(gradientView)
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: resultImageView.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: resultImageView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: resultImageView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: resultImageView.bottomAnchor)
        ])
        
    }
    
    
    private func configureResultImageView() {
        
        mainView.addSubview(resultImageView)
        
        NSLayoutConstraint.activate([
            resultImageView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 5),
            resultImageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10),
            resultImageView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10),
            resultImageView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 5)
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
