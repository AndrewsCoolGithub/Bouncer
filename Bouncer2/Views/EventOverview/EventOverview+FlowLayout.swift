//
//  EventOverview+FlowLayout.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/12/22.
//

import UIKit

extension EventOverview: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let sectionID = contentView.dataSource?.sectionIdentifier(for: indexPath.section) else {return .zero}
        switch sectionID {
        case .Host:
            return CGSize(width: .makeWidth(414), height: .makeWidth(103))
        default:
            return CGSize(width: .makeWidth(85), height: .makeWidth(85) + .wProportioned(20))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        guard let sectionID = contentView.dataSource?.sectionIdentifier(for: section) else {return .zero}
        switch sectionID {
        case .Host:
            return .zero
        default:
            return UIEdgeInsets(top: .wProportioned(15), left: .makeWidth(15), bottom: .wProportioned(15), right: .makeWidth(15))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        .makeWidth(15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .makeWidth(15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: .makeWidth(414), height: .wProportioned(40))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let profile = self.contentView.dataSource?.itemIdentifier(for: indexPath) else {return}
        if profile.id == User.shared.id {
            let controller = ProfileViewController()
            navigationController?.pushViewController(controller, animated: true)
        }else{
            let controller = ProfileViewController(profile: profile)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
