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
        label.textColor = .white
        label.font = .poppinsRegular(size: .makeWidth(18))
        return label
    }()
    
    let bubbleCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 100, height: .wProportioned(50))
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.setDimensions(height: .wProportioned(60), width: .makeWidth(414))
        cv.register(NMSelectedUserCell.self, forCellWithReuseIdentifier: NMSelectedUserCell.id)
        cv.register(NMDefaultUserCell.self, forCellWithReuseIdentifier: NMDefaultUserCell.id)
        cv.register(NMTextFieldCell.self, forCellWithReuseIdentifier: NMTextFieldCell.id)
        cv.alwaysBounceHorizontal = true
        cv.backgroundColor = .greyColor()
        cv.tag = 1
        return cv
    }()
    
    let usersCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: .makeWidth(414), height: .wProportioned(95))
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.setWidth(.makeWidth(414))
        cv.register(NewMessageUserCell.self, forCellWithReuseIdentifier: NewMessageUserCell.id)
        cv.backgroundColor = .purple
        cv.alwaysBounceVertical = true
        cv.tag = 2
        return cv
    }()
}
