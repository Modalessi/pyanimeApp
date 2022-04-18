//
//  UIViewController+EXT.swift
//  pyanime
//
//  Created by Mohammed Alessi on 09/04/2022.
//

import UIKit

extension UIViewController {
    
    func presentPAAlertOnMainThread(title: String, message: String, buttonTitle: String?) {
        
        DispatchQueue.main.async {
            let alertViewController = PAAlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            alertViewController.modalPresentationStyle = .overFullScreen
            alertViewController.modalTransitionStyle = .crossDissolve
            self.present(alertViewController, animated: true, completion: nil)
        }
        
    }
    
}
