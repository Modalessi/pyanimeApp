//
//  PAButton.swift
//  pyanime
//
//  Created by Mohammed Alessi on 09/04/2022.
//

import UIKit


class PAButton: UIButton {
    
    init(backgroundColor: UIColor, title: String) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        configure()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 10
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
