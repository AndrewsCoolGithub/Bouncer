//
//  SuggestedCollectionView.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/12/22.
//

import UIKit


class SuggestedCollectionView: UITableViewCell{
    
    static let id = "SuggestedCollectionView"
    
    let suggestedCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect(origin: .zero, size: CGSize(width: .makeWidth(414), height: .wProportioned(250))), collectionViewLayout: layout)
        cv.alwaysBounceHorizontal = true
        cv.showsHorizontalScrollIndicator = false
        cv.register(SuggestedCard.self, forCellWithReuseIdentifier: SuggestedCard.id)
        cv.backgroundColor = .greyColor()
        return cv
    }()
    
    enum Section{ case suggested}
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Profile>?
    
    
    func setup(_ viewModel: EventSuiteDetailVM){
        contentView.addSubview(suggestedCV)
        suggestedCV.delegate = self
        dataSource = UICollectionViewDiffableDataSource(collectionView: suggestedCV, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestedCard.id, for: indexPath) as! SuggestedCard
            cell.setup(itemIdentifier)
            return cell
        })
        
        viewModel.$suggested.sink { profiles in
            if let profiles = profiles{
                self.updateSnapshot(profiles)
            }
        }.store(in: &viewModel.cancellable)
    }
    
    func updateSnapshot(_ profiles: [Profile]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Profile>()
        snapshot.appendSections([.suggested])
        snapshot.appendItems(profiles, toSection: .suggested)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}


extension SuggestedCollectionView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: .makeWidth(135), height: .wProportioned(210))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .makeWidth(30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: .wProportioned(15), left: .makeWidth(25), bottom: .wProportioned(15), right: .makeWidth(25))
    }
}
