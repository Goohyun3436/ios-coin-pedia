//
//  DetailViewController.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit

final class DetailViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = DetailView()
    private let viewModel = DetailViewModel()
    
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
