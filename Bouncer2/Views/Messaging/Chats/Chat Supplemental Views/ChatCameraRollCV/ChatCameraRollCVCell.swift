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
    
    override var isSelected: Bool {
        didSet{
            changeState(isSelected)
        }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.setDimensions(height: .makeWidth(414)/3, width: .makeWidth(414)/3)
        return imageView
    }()
    
    lazy var checkmarkView: UIView = {
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(30))
        let checkImage: UIImageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)!)
        checkImage.contentMode = .center
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .offWhite().withAlphaComponent(0.5)
        checkImage.frame = view.bounds
        view.addSubview(checkImage)
        
        return view
    }()
    
    var asset: PHAsset!
    
    
    func setup(_ asset: PHAsset){
        self.asset = asset
        self.addSubview(imageView)
        imageView.bounds = self.bounds
        imageView.fetchImage(asset: asset, contentMode: .aspectFill, targetSize: CGSize(width: .makeWidth(414)/3, height: .makeWidth(414)/3))
    }
    
    private func changeState(_ isSelected: Bool){
        switch isSelected{
        case true:
            self.addSubview(checkmarkView)
        case false:
            checkmarkView.removeFromSuperview()
        }
    }

}
