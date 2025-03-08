//
//  TickerSortButton.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/8/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class TickerSortButton: UIButton {
    
    //MARK: - Property
    private let view = TickerSortButtonView()
    let status = PublishRelay<TickerSortStatus>()
    private let disposeBag = DisposeBag()
    
    //MARK: - Initializer Method
    init(_ sortType: TickerSort) {
        super.init(frame: .zero)
        loadView()
        setupBind()
        view.titleLabel.text = sortType.rawValue
    }
    
    //MARK: - Setup Method
    private func setupBind() {
        status
            .bind(with: self, onNext: { owner, status in
                owner.setStatus(status)
            })
            .disposed(by: disposeBag)
    }
    
    private func setStatus(_ status: TickerSortStatus) {
        let opacity: Float = 0.5
        
        switch status {
        case .normal:
            view.arrowUpIcon.layer.opacity = opacity
            view.arrowDownIcon.layer.opacity = opacity
        case .asc:
            view.arrowUpIcon.layer.opacity = 1
            view.arrowDownIcon.layer.opacity = opacity
        case .dsc:
            view.arrowUpIcon.layer.opacity = opacity
            view.arrowDownIcon.layer.opacity = 1
        }
    }
    
    private func loadView() {
        addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Inner View
private final class TickerSortButtonView: BaseView {
    
    //MARK: - UI Property
    let titleLabel = AppLabel(.title3)
    private let arrowWrap = UIStackView()
    let arrowUpIcon = UIImageView(
        image: UIImage(systemName: AppIcon.arrowUp.value)
    )
    let arrowDownIcon = UIImageView(
        image: UIImage(systemName: AppIcon.arrowDown.value)
    )
    
    //MARK: - Setup Method
    override func setupUI() {
        [arrowUpIcon, arrowDownIcon].forEach {
            arrowWrap.addArrangedSubview($0)
        }
        arrowWrap.axis = .vertical
        arrowWrap.spacing = -3
        
        [titleLabel, arrowWrap].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let margin: CGFloat = 2
        let iconSize = CGSize(width: 6, height: 10)
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
        }
        
        [arrowUpIcon, arrowDownIcon].forEach {
            $0.snp.makeConstraints { make in
                make.width.equalTo(iconSize.width)
                make.height.equalTo(iconSize.height)
            }
        }

        arrowWrap.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(margin)
            make.trailing.equalToSuperview()
        }
    }
    
    override func setupAttributes() {
        isUserInteractionEnabled = false
        backgroundColor = AppColor.clear.value
        [arrowUpIcon, arrowDownIcon].forEach {
            $0.contentMode = .scaleToFill
            $0.tintColor = AppColor.navy.value
        }
    }
    
}
