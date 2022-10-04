//
//  CustomEmoteCell.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 9/27/22.
//

import UIKit

class CustomEmoteCell: UICollectionViewCell{
    
    static let id = "custom-emote-cell"
    var name: String!
    
    private let emojiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    func setup(with emoji: Emoji){
        name = emoji.name
        
    }
    
}
