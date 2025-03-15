//
//  ModalView.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit
import SnapKit

final class ModalView: BaseView {
    
    //MARK: - UI Property
    private let wrap = UIView()
    let titleLabel = AppLabel(.title2)
    let messageLabel = AppLabel(.text2)
    private let buttonWrap = UIStackView()
    let cancelButton = UIButton()
    let submitButton = UIButton()
    
    //MARK: - Override Method
    override func draw(_ rect: CGRect) {
        messageLabel.setLineSpacing(4)
        
        [submitButton, cancelButton].forEach {
            let borderTop = UIView(frame: CGRectMake(0, 0, $0.frame.size.width, 0.5))
            borderTop.backgroundColor = AppColor.lightNavy.value
            $0.addSubview(borderTop)
        }
    }
    
    //MARK: - Setup Method
    override func setupUI() {
        [cancelButton, submitButton].forEach {
            buttonWrap.addArrangedSubview($0)
        }
        
        [titleLabel, messageLabel, buttonWrap].forEach {
            wrap.addSubview($0)
        }
        
        addSubview(wrap)
    }
    
    override func setupConstraints() {
        let modalHMargin: CGFloat = 50
        let paddingV: CGFloat = 20
        let paddingH: CGFloat = 50
        let buttonHeight: CGFloat = 44
        
        wrap.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(modalHMargin)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(paddingV)
            make.centerX.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(paddingV)
            make.horizontalEdges.equalToSuperview().inset(paddingH)
        }
        
        buttonWrap.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(paddingV)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(buttonHeight)
            make.bottom.equalToSuperview()
        }
        buttonWrap.axis = .horizontal
        buttonWrap.spacing = 0
        buttonWrap.distribution = .fillEqually
    }
    
    override func setupAttributes() {
        backgroundColor = AppColor.overlay.value
        wrap.backgroundColor = AppColor.white.value
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.lineBreakMode = .byWordWrapping
        [submitButton, cancelButton].forEach {
            $0.setTitleColor(AppColor.navy.value, for: .normal)
            $0.titleLabel?.font = AppFont.title2.value
        }
    }
    
}
