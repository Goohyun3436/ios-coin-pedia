//
//  TrendingCoinCollectionView.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/9/25.
//

import UIKit

final class TrendingCoinCollectionView: UICollectionView {
    
    init(coinsInColumn numberOfCoinsInColumn: CGFloat, insetV: CGFloat, insetH: CGFloat) {
        super.init(frame: .zero, collectionViewLayout: {
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            
            let innerGroupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1 / numberOfCoinsInColumn)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(
                top: insetV,
                leading: insetH,
                bottom: insetV,
                trailing: insetH
            )
            
            let innerGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: innerGroupSize,
                subitems: [item]
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [innerGroup]
            )
            let section = NSCollectionLayoutSection(group: group)
            let layout = UICollectionViewCompositionalLayout(section: section)
            return layout
        }())
        
        register(TrendingCoinCollectionViewCell.self, forCellWithReuseIdentifier: TrendingCoinCollectionViewCell.id)
        
        isScrollEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
