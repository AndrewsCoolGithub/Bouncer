//
//  FullDetailPeopleCV.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/5/22.
//

import UIKit
import UIImageColors

class FullDetailPeopleCVCell: UICollectionViewCell, SkeletonLoadable {
    
    static let id = "full-detail-people-cell"
    
    
    public func setup(with profile: Profile){
        contentView.addSubview(imageView)
        imageView.gradientColors = (profile.colors?.uiImageColors() ?? User.defaultColors, false)
        skeletonGradient.frame = imageView.bounds
        imageView.layer.addSublayer(skeletonGradient)
        
        imageView.sd_setImage(with: URL(string: profile.image_url)) { [weak self] I, E, C, U in
            self?.skeletonGradient.removeFromSuperlayer()
        }
    }

    private lazy var imageView: UIImageView = {
       
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: .makeWidth(414) * 65/414, height: .makeWidth(414) * 65/414), cornerRadius: (.makeWidth(414) * 65/414)/2, uiColors: nil, lineWidth: 2, direction: .horizontal)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var skeletonGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        let animation = makeAnimationGroup()
        animation.beginTime = 0.0
        gradient.add(animation, forKey: "backgroundColor")
        return gradient
    }()
}
