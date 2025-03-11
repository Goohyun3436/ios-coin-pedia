//
//  TrendingView.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit
import SnapKit

final class TrendingView: BaseView {
    
    //MARK: - UI Property
    let searchBar = RoundSearchBar()
    let coinHeader = SectionHeaderView(.subText)
    lazy var coinCollectionView = TrendingCoinCollectionView(
        coinsInColumn: numberOfCoinsInColumn,
        insetV: insetV,
        insetH: insetH
    )
    let nftHeader = SectionHeaderView(.none)
    lazy var nftCollectionView = TrendingNftCollectionView(
        itemSize: .large,
        insetV: insetV,
        insetH: insetH
    )
    
    //MARK: - Property
    private let numberOfCoinsInColumn: CGFloat = 7
    private let insetV: CGFloat = 8
    private let insetH: CGFloat = 8
    
    //MARK: - Setup Method
    override func setupUI() {
        [searchBar, coinHeader, coinCollectionView, nftHeader, nftCollectionView].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let margin: CGFloat = 16
        let marginTopSection: CGFloat = 32
        let marginBottomSection: CGFloat = 12
        let searchBarHeight: CGFloat = 40
        let coinCollectionViewHeight: CGFloat = (AppImageSize.thumb.value.height + insetV * 2) * numberOfCoinsInColumn
        let nftCollectionViewHeight: CGFloat = AppImageSize.large.value.height + insetV * 2 + 44
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(margin)
            make.horizontalEdges.equalToSuperview().inset(margin)
            make.height.equalTo(searchBarHeight)
        }
        
        coinHeader.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(marginTopSection)
            make.horizontalEdges.equalToSuperview()
        }
        
        coinCollectionView.snp.makeConstraints { make in
            make.top.equalTo(coinHeader.snp.bottom).offset(marginBottomSection)
            make.horizontalEdges.equalToSuperview().inset(insetH)
            make.height.equalTo(coinCollectionViewHeight)
        }
        
        nftHeader.snp.makeConstraints { make in
            make.top.equalTo(coinCollectionView.snp.bottom).offset(marginTopSection)
            make.horizontalEdges.equalToSuperview()
        }
        
        nftCollectionView.snp.makeConstraints { make in
            make.top.equalTo(nftHeader.snp.bottom).offset(marginBottomSection)
            make.horizontalEdges.equalToSuperview().inset(insetH)
            make.height.equalTo(nftCollectionViewHeight)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide).offset(-0)
        }
    }
    
}
