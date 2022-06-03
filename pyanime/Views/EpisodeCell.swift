//
//  EpisodeCell.swift
//  pyanime
//
//  Created by Mohammed Alessi on 21/04/2022.
//

import UIKit


class EpisodeCell: UITableViewCell {
    
    static let reuseID: String = "EpisodeCell"
    
    let mainView = UIView()
    let titleLable = PATitleLabel(textAlignment: .left, fontSize: 18)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectedBackgroundView = nil
        selectionStyle = .none
        configureMainView()
        configureTitleLable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureMainView() {
        
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = .systemGray4
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
    }
    
    
    func configureTitleLable() {
        mainView.addSubview(titleLable)
        
        NSLayoutConstraint.activate([
            titleLable.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            titleLable.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10),
            titleLable.heightAnchor.constraint(equalToConstant: 22),
            titleLable.trailingAnchor.constraint(equalTo: mainView.trailingAnchor)
        ])
        
    }
    
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            mainView.backgroundColor = .systemGray5
        } else {
            mainView.backgroundColor = .systemGray4
        }
    }
    
}
