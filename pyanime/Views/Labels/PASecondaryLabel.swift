//
//  PASecondaryFont.swift
//  pyanime
//
//  Created by Mohammed Alessi on 09/04/2022.
//

import UIKit

class PASecondaryFontLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    init(textAlignment: NSTextAlignment) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        textColor = .secondaryLabel
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        lineBreakMode = .byWordWrapping
        
        translatesAutoresizingMaskIntoConstraints = false
    }

}
    
