//
//  PAEmptyStateView.swift
//  pyanime
//
//  Created by Mohammed Alessi on 03/06/2022.
//

import UIKit

class PAEmptyStateView: UIView {
    
    let mainImageView = UIImageView()
    let messageLabel = PATitleLabel(textAlignment: .center, fontSize: 24)
    var image: UIImage = UIImage(systemName: "photo")!
    var message: String = "this view is empty"
    
    init(image: UIImage, message: String) {
        self.image = image
        self.message = message
        super.init(frame: .zero)
        self.layoutUI()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layoutUI()
    }
    
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func layoutUI() {
        
        mainImageView.image = image
        mainImageView.tintColor = .darkGray
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .darkGray
        
        mainImageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(mainImageView)
        addSubview(messageLabel)
        NSLayoutConstraint.activate([

            mainImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            mainImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            mainImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100),

        
            messageLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 20),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            messageLabel.heightAnchor.constraint(equalToConstant: 30)

        ])
    }
    
    
    
}
