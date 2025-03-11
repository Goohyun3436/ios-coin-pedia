//
//  SearchCollectionView.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/10/25.
//

import UIKit

final class SearchCollectionView: UICollectionView {
    
    init(itemSize: AppImageSize, insetV: CGFloat, insetH: CGFloat) {
        super.init(frame: .zero, collectionViewLayout: {
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(1.0)
            )
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(itemSize.value.height + insetV * 2)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(
                top: insetV,
                leading: insetH,
                bottom: insetV,
                trailing: insetH
            )
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            let layout = UICollectionViewCompositionalLayout(section: section)
            return layout
        }())
        
        register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
