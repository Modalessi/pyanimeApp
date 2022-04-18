//
//  ResultsVC.swift
//  pyanime
//
//  Created by Mohammed Alessi on 09/04/2022.
//

import UIKit

class ResultsVC: UIViewController {
    
    let searchQuery: String
    var results: [SearchResult] = []
    let resultsTableView = UITableView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Results"
        navigationController?.navigationBar.prefersLargeTitles = true
        getSearchResults()
        layoutUI()
    }
    
    
    func getSearchResults() {
        
        GogoanimeAPI.shared.search(for: searchQuery) { (result) in
            switch result {
            case .success(let results) :
                self.results = results
            case .failure(let error) :
                self.presentPAAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "ok")
            }
        }
    }
    
    
    func layoutUI() {
        
        view.addSubview(resultsTableView)
        resultsTableView.frame = view.bounds
        resultsTableView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    init(searchQuery: String) {
        self.searchQuery = searchQuery
        super.init(nibName: nil, bundle: nil)
    }
    
}
