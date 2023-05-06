//
//  ChatCameraRollCVCell.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/29/23.
//

import UIKit
import Photos

class ChatCameraRollCVCell: UICollectionViewCell{
    
    static let id = "chat-camera-roll-cv-cell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.setDimensions(height: .makeWidth(414)/3, width: .makeWidth(414)/3)
        return imageView
    }()
    
    var asset: PHAsset!
    
    func setup(_ asset: PHAsset){
        self.asset = asset
        self.addSubview(imageView)
        imageView.bounds = self.bounds
        imageView.fetchImage(asset: asset, contentMode: .aspectFill, targetSize: CGSize(width: .makeWidth(414)/3, height: .makeWidth(414)/3))
    }

}
