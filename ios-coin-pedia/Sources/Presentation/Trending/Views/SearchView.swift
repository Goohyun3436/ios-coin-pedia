//
//  SearchView.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/6/25.
//

import UIKit
import SnapKit

final class SearchView: BaseView {
    
    //MARK: - UI Property
    let searchBar = MinimalSearchBar()
    let segmentControl = BorderBottomSegmentControl()
    let scrollView = UIScrollView()
    private let stackView = UIStackView()
    let coinCollectionView = SearchCollectionView(
        itemSize: AppImageSize.small,
        insetV: 16,
        insetH: 16
    )
    let nftCollectionView = SearchCollectionView(
        itemSize: AppImageSize.small,
        insetV: 16,
        insetH: 16
    )
    let exchangeCollectionView = SearchCollectionView(
        itemSize: AppImageSize.small,
        insetV: 16,
        insetH: 16
    )
    
    //MARK: - Property
    private let segmentHeight: CGFloat = 40
    
    //MARK: - Override Method
    override func draw(_ rect: CGRect) {
        let safeAreaHeight: CGFloat = safeAreaLayoutGuide.layoutFrame.size.height
        let collectionViewWidth: CGFloat = UIScreen.main.bounds.width
        let collectionViewHeight: CGFloat = safeAreaHeight - segmentHeight
        
        [coinCollectionView, nftCollectionView, exchangeCollectionView].forEach {
            $0.snp.makeConstraints { make in
                make.width.equalTo(collectionViewWidth)
                make.height.equalTo(collectionViewHeight)
            }
        }
    }
    
    //MARK: - Setup Method
    override func setupUI() {
        [coinCollectionView, nftCollectionView, exchangeCollectionView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        scrollView.addSubview(stackView)
        
        [segmentControl, scrollView].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        segmentControl.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(segmentHeight)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview()
        }
        stackView.axis = .horizontal
        stackView.spacing = 0
    }
    
    override func setupAttributes() {
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.alwaysBounceVertical = false
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        
        [coinCollectionView, nftCollectionView, exchangeCollectionView].forEach {
            $0.keyboardDismissMode = .onDrag
        }
    }
    
}
