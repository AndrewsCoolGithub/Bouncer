//
//  SearchViewComponents.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 8/1/22.
//

import Foundation
import UIKit

struct SearchViewComponents{
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.barStyle = .default
        searchBar.tintColor = .white
        searchBar.backgroundColor = .greyColor()
        searchBar.barTintColor = .greyColor()
        searchBar.setDimensions(height: .makeHeight(60), width: .makeWidth(310))
        return searchBar
    }()
    
    let cancelSearchButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .poppinsMedium(size: .makeWidth(16.5))
        button.titleLabel?.textAlignment = .center
        button.setDimensions(height: .makeHeight(60), width: .makeWidth(85))
        return button
    }()
    
    let searchCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ProfileSearchCell.self, forCellWithReuseIdentifier: ProfileSearchCell.id)
        collectionView.register(SearchHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchHeaderCell.id)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .greyColor()
        return collectionView
    }()
}
    
