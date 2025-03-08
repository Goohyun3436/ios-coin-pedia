//
//  TickerViewController.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit
import RxSwift
import RxCocoa

final class TickerViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = TickerView()
    private let viewModel = TickerViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - Override Method
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = ModalViewController()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
    }
    
    //MARK: - Setup Method
    override func setupBind() {
        
    }
    
}
