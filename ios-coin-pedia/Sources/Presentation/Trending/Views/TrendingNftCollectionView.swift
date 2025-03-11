//
//  TrendingNftCollectionView.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/9/25.
//

import UIKit

final class TrendingNftCollectionView: UICollectionView {
    
    init(itemSize: AppImageSize, insetV: CGFloat, insetH: CGFloat) {
        super.init(frame: .zero, collectionViewLayout: {
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .estimated(1),
                heightDimension: .fractionalHeight(1.0)
            )
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(itemSize.value.width + insetH * 2),
                heightDimension: .fractionalHeight(1.0)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(
                top: insetV,
                leading: insetH,
                bottom: insetV,
                trailing: insetH
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            let layout = UICollectionViewCompositionalLayout(section: section)
            return layout
        }())
        
        register(TrendingNftCollectionViewCell.self, forCellWithReuseIdentifier: TrendingNftCollectionViewCell.id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
