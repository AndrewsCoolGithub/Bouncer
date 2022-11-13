//
//  EventSuiteViewComponents.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 8/11/22.
//

import Foundation
import UIKit

struct EventSuiteViewComponents{
    
     let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        let cv = UICollectionView(frame: CGRect(x: 0, y: .makeHeight(150), width: .makeWidth(414), height: .makeHeight(896 - 60)), collectionViewLayout: layout)
        cv.register(EventSuiteCell.self, forCellWithReuseIdentifier: EventSuiteCell.id)
        cv.backgroundColor = .greyColor()
        cv.register(EventHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EventHeaderCell.id)

        return cv
    }()
    
    let pastelView: Pastel = {
        let pastel = Pastel(frame: CGRect(origin: .zero, size: CGSize(width: .makeWidth(414), height: .makeHeight(150))))
        return pastel
    }()
    
    
    let buttonPastelView = Pastel()
    let createButton: UIButton = {
        let button = UIButton(frame: CGRect.layoutRect(width: 70, height: 70, rectCenter: .centerX, padding: Padding(anchor: .bottom, padding: .makeWidth(100)), keepAspect: true))
        button.layer.cornerRadius = button.frame.height * 0.5
        button.backgroundColor = .greyColor()
        button.setImage(UIImage(systemName: "camera.aperture", withConfiguration: UIImage.SymbolConfiguration(pointSize: .makeWidth(25))), for: .normal)
        button.tintColor = .white
        button.layer.applySketchShadow(color: .black.withAlphaComponent(0.3), alpha: 1, x: 0, y: 3, blur: 6, spread: 5, withRounding: button.frame.height * 0.5)
        return button
    }()
}
