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
        print(#function)
        
        mainView.titleLabel.text = "안내"
        mainView.messageLabel.text = "네트워크 연결이 일시적으로 원활하지 않습니다. 데이터 또는 Wi-Fi 연결 상태를 확인해주세요."
        mainView.submitButton.setTitle("다시 시도하기", for: .normal)
    }
    
}
