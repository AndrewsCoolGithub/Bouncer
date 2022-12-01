//
//  NewMessageComponents.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/25/22.
//

import UIKit

struct NewMessageComponents{
    let backButton: UIButton = {
        let backButton = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: .makeHeight(30), weight: .semibold)
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        backButton.tintColor = .white
        return backButton
    }()
    
    let doneButton: UIButton = {
        let doneButton = UIButton()
        doneButton.setTitle("Chat", for: .normal)
        doneButton.titleLabel?.font = .poppinsMedium(size: .makeWidth(17))
        return doneButton
    }()
    
    let titleHeader: UILabel = {
        let label = UILabel()
        label.text = "New Message"
        label.font = .poppinsMedium(size: .makeWidth(20))
        label.textColor = .white
        return label
    }()
    
    let toLabel: UILabel = {
        let label = UILabel()
        label.text = "To"
        label.textColor = .nearlyWhite()
        label.font = .poppinsRegular(size: .makeWidth(18))
        return label
    }()
    
    let bubbleCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect(x: 0, y: .wProportioned(110), width: .makeWidth(414), height: .wProportioned(60)), collectionViewLayout: layout)
        cv.register(NMSelectedUserCell.self, forCellWithReuseIdentifier: NMSelectedUserCell.id)
        cv.alwaysBounceHorizontal = true
        cv.backgroundColor = .greyColor()
        return cv
    }()
    
    let usersCV: UICollectionView = {
        let cv = UICollectionView(frame: CGRect(x: 0, y: .wProportioned(180), width: .makeWidth(414), height: .makeHeight(896) - .wProportioned(180)), collectionViewLayout: UICollectionViewFlowLayout())
        cv.register(NewMessageUserCell.self, forCellWithReuseIdentifier: NewMessageUserCell.id)
        cv.backgroundColor = .purple
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    
}
