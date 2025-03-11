//
//  TrendingNftCollectionViewCell.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/9/25.
//

import UIKit
import Kingfisher
import SnapKit

final class TrendingNftCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - UI Property
    private let wrap = UIStackView()
    private let iconImageView = IconImageView(.large)
    private let nameLabel = AppLabel(.subText2)
    private let averagePriceLabel = AppLabel(.subText3, .lightNavy)
    private let volatilityView = VolatilityIconView()
    
    //MARK: - Property
    static let id = "TrendingNftCollectionViewCell"
    
    //MARK: - Setup Method
    func setData(_ info: CGNftInfo) {
        iconImageView.kf.setImage(
            with: URL(string: info.thumb),
            placeholder: UIImage(systemName: info.imagePlaceholder)
        )
        nameLabel.text = info.name
        averagePriceLabel.text = info.data.h24AverageSalePrice
        volatilityView.setData(info.volatility)
    }
    
    override func setupUI() {
        [iconImageView, nameLabel, averagePriceLabel, volatilityView].forEach {
            wrap.addArrangedSubview($0)
        }
        
        contentView.addSubview(wrap)
    }
    
    override func setupConstraints() {
        wrap.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        wrap.axis = .vertical
        wrap.alignment = .center
        wrap.distribution = .equalSpacing
        
        iconImageView.snp.makeConstraints { make in
            make.width.equalTo(AppImageSize.large.value.width)
            make.height.equalTo(AppImageSize.large.value.height)
        }
    }
    
}
