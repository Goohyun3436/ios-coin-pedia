//
//  TrendingViewController.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit

final class TrendingViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = TrendingView()
    private let viewModel = TrendingViewModel()
    
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
