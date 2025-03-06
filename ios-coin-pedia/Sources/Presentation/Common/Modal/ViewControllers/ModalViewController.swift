//
//  ModalViewController.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit

final class ModalViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = ModalView()
    private let viewModel = ModalViewModel()
    
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
