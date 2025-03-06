//
//  SearchViewController.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit

final class SearchViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = SearchView()
    private let viewModel = SearchViewModel()
    
    //MARK: - Override Method
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Setup Method
    override func setupBind() {
        
    }
    
}
