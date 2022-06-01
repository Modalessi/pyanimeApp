//
//  GradiantView.swift
//  pyanime
//
//  Created by Mohammed Alessi on 31/05/2022.
//

import UIKit

class GradientView: UIView {
    var topColor: UIColor = UIColor.clear
    var bottomColor: UIColor = UIColor.black

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
        (layer as! CAGradientLayer).locations = [0.0, 0.75]
    }
}
