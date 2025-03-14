//
//  ModalViewController.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ModalViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = ModalView()
    private let viewModel: ModalViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: ModalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: - Override Method
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Setup Method
    override func setupBind() {
        let input = ModalViewModel.Input(
            submitTap: mainView.submitButton.rx.tap,
            cancelTap: mainView.cancelButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.title
            .bind(to: mainView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.message
            .bind(to: mainView.messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.submitButtonTitle
            .bind(to: mainView.submitButton.rx.title())
            .disposed(by: disposeBag)
        
        output.cancelButtonTitle
            .bind(to: mainView.cancelButton.rx.title())
            .disposed(by: disposeBag)
    }
    
}
