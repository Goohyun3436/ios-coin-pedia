//
//  SearchCollectionViewCell.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/10/25.
//

import UIKit
import RxSwift
import Kingfisher
import SnapKit

final class SearchCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - UI Property
    private let iconImageView = IconImageView(.small)
    private let nameLabel = AppLabel(.title3)
    private let symbolLabel = AppLabel(.text2, .lightNavy)
    private let rankView = LankLabelView(.subText2, .lightNavy)
    let favoriteButton = FavoriteButton()
    
    //MARK: - Property
    static let id = "SearchCollectionViewCell"
    let disposeBag = DisposeBag()
    
    //MARK: - Setup Method
    func setData(_ info: CGSearchCoinInfo) {
        iconImageView.kf.setImage(
            with: URL(string: info.thumb),
            placeholder: UIImage(systemName: info.imagePlaceholder)
        )
        nameLabel.text = info.name
        symbolLabel.text = info.symbol
        rankView.label.text = info.rank
        favoriteButton.isSelected = info.isFavorite
    }
    
    override func setupUI() {
        [iconImageView, nameLabel, symbolLabel, rankView, favoriteButton].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let imageMargin: CGFloat = 8
        let textMargin: CGFloat = 4
        
        iconImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(AppImageSize.small.value.width)
            make.height.equalTo(AppImageSize.small.value.height)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.top)
            make.leading.equalTo(iconImageView.snp.trailing).offset(imageMargin)
        }
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        symbolLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(nameLabel.snp.bottom).offset(textMargin)
            make.leading.equalTo(iconImageView.snp.trailing).offset(imageMargin)
            make.bottom.equalTo(iconImageView.snp.bottom)
        }
        symbolLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        rankView.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.leading.equalTo(nameLabel.snp.trailing).offset(textMargin)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.greaterThanOrEqualTo(rankView.snp.trailing).offset(imageMargin)
            make.leading.greaterThanOrEqualTo(symbolLabel.snp.trailing).offset(imageMargin)
        }
    }
    
}
