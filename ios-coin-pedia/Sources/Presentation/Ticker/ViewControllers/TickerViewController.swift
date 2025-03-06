//
//  TickerViewController.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit

final class TickerViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = TickerView()
    private let viewModel = TickerViewModel()
    
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
