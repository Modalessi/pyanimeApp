//
//  GFAvatarImageView.swift
//  GHFollwers
//
//  Created by Mohammed Alessi on 08/06/2021.
//

import UIKit

class PAAvatarImageView: UIImageView {
    
    let placeholderImage = UIImage(named: "imagePlaceholder")!
    
    let cache = FaselhdAPI.shared.cache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        contentMode = .scaleAspectFill
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from url: String) {
        let cacheKey = NSString(string: url)
        if let image = cache.object(forKey: cacheKey) {
            DispatchQueue.main.async {
                self.image = image
            }
            return
        }
        
        guard let url = URL(string: url) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            guard let self = self else { return }
            
            if error != nil { return }
            
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            
            self.cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                self.image = image
            }
            
        }
        
        
        task.resume()
    }
    
}
