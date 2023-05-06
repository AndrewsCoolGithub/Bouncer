//
//  ChatCameraRollViewComponents.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/1/23.
//

import UIKit

struct ChatCameraRollViewComponents{
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: .makeWidth(414), height: .makeHeight(275)), collectionViewLayout: layout)
        cv.register(ChatCameraRollCVCell.self, forCellWithReuseIdentifier: ChatCameraRollCVCell.id)
        cv.backgroundColor = .systemPink
        
        return cv
    }()
    
    
}
