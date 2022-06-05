//
//  CollectionViewHeader.swift
//  pyanime
//
//  Created by Mohammed Alessi on 05/06/2022.
//

import UIKit

class CollectionViewHeader: UICollectionReusableView {
    static let reuseID = "collectionViewHeader"

    let label = PATitleLabel(textAlignment: .left, fontSize: 28)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func configure() {
        backgroundColor = .systemBackground

        addSubview(label)

        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
}
