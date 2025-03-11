//
//  CoinThumbnailView.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/11/25.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import SnapKit

final class CoinThumbnailView: BaseView {
    
    //MARK: - UI Property
    private let background = UIView()
    private let wrap = UIView()
    private let iconImageView = IconImageView(.thumb)
    private let label = AppLabel(.title1)
    
    //MARK: - Property
    struct Rx {
        let icon = PublishRelay<String>()
        let text = PublishRelay<String>()
    }
    
    let rx = Rx()
    private let disposeBag = DisposeBag()
    
    //MARK: - Override Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBind()
    }
    
    //MARK: - Setup Method
    private func setupBind() {
        rx.icon
            .bind(with: self, onNext: { owner, image in
                owner.iconImageView.kf.setImage(
                    with: URL(string: image),
                    placeholder: UIImage(systemName: AppIcon.questionMark.value)
                )
            })
            .disposed(by: disposeBag)
        
        rx.text
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        [iconImageView, label].forEach {
//            wrap.addSubview($0)
            addSubview($0)
        }
        
//        background.addSubview(wrap)
//        addSubview(background)
    }
    
    override func setupConstraints() {
        let deviceWidth: CGFloat = UIScreen.main.bounds.width
        let leftOffset: CGFloat = 60
        let rightOffset: CGFloat = 60
        let width: CGFloat = deviceWidth - leftOffset - rightOffset
        let margin: CGFloat = 8
        
//        background.snp.makeConstraints { make in
//            make.width.equalTo(width)
//        }
//        background.backgroundColor = .red
//        wrap.snp.makeConstraints { make in
//            make.verticalEdges.centerX.equalToSuperview()
//        }
//        wrap.backgroundColor = .green
        
        iconImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(AppImageSize.thumb.value.width)
            make.height.equalTo(AppImageSize.thumb.value.height)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconImageView.snp.trailing).offset(margin)
            make.trailing.equalToSuperview()
        }
    }
    
}
