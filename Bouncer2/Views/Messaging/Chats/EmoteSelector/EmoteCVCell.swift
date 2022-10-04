//
//  EmoteCVCell.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 9/16/22.
//


import UIKit
class EmoteCVCell: UICollectionViewCell{
    
    static let id = "emote-cv-cell"
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setDimensions(height: (.makeWidth(69) * 1.29), width: .makeWidth(69))
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func setup(_ emote: Emoji){
        let emojiImage = emote.emote.emojiStringToImage(CGSize(width: .makeWidth(55), height: (.makeWidth(55) * 1.29)))
        imageView.image = emojiImage
        imageView.contentMode = .center
        
        contentView.addSubview(imageView)
        imageView.center(inView: contentView)
    }
}
