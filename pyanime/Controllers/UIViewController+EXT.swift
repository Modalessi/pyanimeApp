//
//  UIViewController+EXT.swift
//  pyanime
//
//  Created by Mohammed Alessi on 09/04/2022.
//

import UIKit

fileprivate var containerView: UIView!

extension UIViewController {
    
//    https://www.faselhd.top/wp-content/uploads/2021/12/81tgdi5S-S._AC_SY741_-400x600.jpg
    
    
    func presentPAAlertOnMainThread(title: String, message: String, buttonTitle: String?) {
        
        DispatchQueue.main.async {
            let alertViewController = PAAlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            alertViewController.modalPresentationStyle = .overFullScreen
            alertViewController.modalTransitionStyle = .crossDissolve
            self.present(alertViewController, animated: true, completion: nil)
        }
        
    }
    
    
    func showLoadingIndicator() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) { containerView.alpha = 0.8 }
        
        let acitivityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(acitivityIndicator)
        acitivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            acitivityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            acitivityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        acitivityIndicator.startAnimating()
    }
    
    
    func dismisLoadingIndicator() {
        DispatchQueue.main.async {
            guard let containerView = containerView else { return }
            containerView.removeFromSuperview()
        }
    }
    
}
