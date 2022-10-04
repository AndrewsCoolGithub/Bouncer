//
//  SearchCellViews.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 8/1/22.
//

import Foundation
import UIKit

struct SearchCellViews: SkeletonLoadable{
    
    let profileImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.setDimensions(height: .makeWidth(75), width: .makeWidth(75))
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = .makeWidth(37.5)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var skeletonGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        let animation = makeAnimationGroup()
        animation.beginTime = 0.0
        gradient.add(animation, forKey: "backgroundColor")
       
        return gradient
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .poppinsMedium(size: .makeWidth(15))
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .nearlyWhite()
        label.font = .poppinsRegular(size: .makeWidth(15))
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .nearlyWhite()
        label.font = .poppinsRegular(size: .makeWidth(13))
        return label
    }()
}
