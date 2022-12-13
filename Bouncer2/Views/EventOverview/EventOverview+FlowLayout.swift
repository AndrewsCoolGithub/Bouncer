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
            return CGSize(width: .makeWidth(85), height: .makeWidth(85))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        guard let sectionID = contentView.dataSource?.sectionIdentifier(for: section) else {return .zero}
//        if section == 0{
//            if sectionID == .Host{
//                return UIEdgeInsets(top: -.wProportioned(52.5), left: 0, bottom: 0, right: 0)
//            }
//            return UIEdgeInsets(top: -.wProportioned(52.5), left: .makeWidth(15), bottom: 0, right: .makeWidth(15))
//        }
        
        switch sectionID {
        case .Host:
            return .zero
        default:
            return UIEdgeInsets(top: 0, left: .makeWidth(15), bottom: 0, right: .makeWidth(15))
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
}
