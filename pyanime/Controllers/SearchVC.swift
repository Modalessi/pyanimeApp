//
//  ViewController.swift
//  pyanime
//
//  Created by Mohammed Alessi on 09/04/2022.
//

import UIKit

class SearchVC: UIViewController {
    
    let searchTextField = UITextField()
    let searchButton = PAButton(backgroundColor: .systemBlue, title: "Search")

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureViewController()
        searchTextField.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
    }

    
    @objc func searchButtonTouched() {
        guard searchTextField.text != "" else {
            presentPAAlertOnMainThread(title: "Ooops", message: "enter anime, tv show or movie name to search for", buttonTitle: "Ok")
            return
        }
        
        pushResultsVC()
    }
    
    func pushResultsVC() {
        let resultsVC = ResultsVC(searchQuery: searchTextField.text!)
        navigationController?.pushViewController(resultsVC, animated: true)
    }
    
    
    func configureViewController() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTouched(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func viewTouched(_ gesture: UITapGestureRecognizer) {
        searchTextField.resignFirstResponder()
    }
    
    
    func layoutUI() {
        
        searchTextField.placeholder = "Search Query"
        searchTextField.textAlignment = .center
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 15
        searchTextField.layer.borderColor = UIColor.secondarySystemFill.cgColor
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchTextField)
        NSLayoutConstraint.activate([
            searchTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
        
        searchButton.addTarget(self, action: #selector(searchButtonTouched), for: .touchUpInside)
        
        view.addSubview(searchButton)
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            searchButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    
}


extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchButtonTouched()
        
        return true
    }
}
