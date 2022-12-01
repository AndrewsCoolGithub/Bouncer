//
//  MessageSuiteVComponents.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 8/22/22.
//

import UIKit
import NVActivityIndicatorView

struct MessageSuiteViewComponents{
    
    let messagesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.id)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .greyColor()
        return collectionView
    }()
    
    let titleHeader: UILabel = {
        let label = UILabel()
        label.text = "Messages"
        label.font = .poppinsMedium(size: .makeWidth(20))
        label.textColor = .white
        return label
    }()
    
    let indicator: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: .layoutRect(width: 414, height: 896, rectCenter: .center), type: .ballPulseSync, color: .white, padding: 150)
        view.backgroundColor = .black.withAlphaComponent(0.2)
        return view
    }()
    
    let backButton: UIButton = {
        let backButton = UIButton(frame: .zero)
        let config = UIImage.SymbolConfiguration(pointSize: .makeHeight(30), weight: .semibold)
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        backButton.tintColor = .white
        backButton.backgroundColor = .nearlyBlack().withAlphaComponent(0.2)
        backButton.setDimensions(height: .makeWidth(40), width: .makeWidth(40))
        backButton.layer.cornerRadius = .makeWidth(20)
        backButton.layer.masksToBounds = true
        return backButton
    }()
    
    let newMessageButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: .makeHeight(28), weight: .semibold)
        button.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .nearlyBlack().withAlphaComponent(0.2)
        button.setDimensions(height: .makeWidth(40), width: .makeWidth(40))
        button.layer.cornerRadius = .makeWidth(20)
        button.layer.masksToBounds = true
        return button
    }()
}
