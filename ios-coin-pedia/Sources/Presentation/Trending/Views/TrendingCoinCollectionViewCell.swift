//
//  TrendingCoinCollectionViewCell.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/9/25.
//

import UIKit
import Kingfisher
import SnapKit

final class TrendingCoinCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - UI Property
    private let scoreLabel = AppLabel(.text2)
    private let iconImageView = IconImageView(.thumb)
    private let nameLabel = AppLabel(.text1)
    private let symbolLabel = AppLabel(.subText3, .lightNavy)
    private let volatilityView = VolatilityIconView()
    
    //MARK: - Property
    static let id = "TrendingCoinCollectionViewCell"
    
    //MARK: - Setup Method
    func setData(_ info: CGCoinsInfo) {
        scoreLabel.text = info.item.rank
        iconImageView.kf.setImage(
            with: URL(string: info.item.thumb),
            placeholder: UIImage(systemName: info.item.imagePlaceholder)
        )
        nameLabel.text = info.item.name
        symbolLabel.text = info.item.symbol
        volatilityView.setData(info.item.volatility)
    }
    
    override func setupUI() {
        [scoreLabel, iconImageView, nameLabel, symbolLabel, volatilityView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let scoreWidth: CGFloat = 16
        let margin: CGFloat = 4
        
        scoreLabel.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
            make.width.equalTo(scoreWidth)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(scoreLabel.snp.trailing).offset(margin)
            make.width.equalTo(AppImageSize.thumb.value.width)
            make.height.equalTo(AppImageSize.thumb.value.height)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.top)
            make.leading.equalTo(iconImageView.snp.trailing).offset(margin)
        }
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        symbolLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(nameLabel.snp.bottom).offset(margin)
            make.leading.equalTo(iconImageView.snp.trailing).offset(margin)
            make.bottom.equalTo(iconImageView.snp.bottom)
        }
        symbolLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        volatilityView.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.greaterThanOrEqualTo(nameLabel.snp.trailing).offset(margin)
            make.leading.greaterThanOrEqualTo(symbolLabel.snp.trailing).offset(margin)
        }
    }
    
}
