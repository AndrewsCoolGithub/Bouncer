//
//  EventOverviewGuestCell.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/12/22.
//

import UIKit

class EventOverviewGuestCell: UICollectionViewCell{
    
    static let id = "EventOverviewGuestCell"
    
    var components = EventOverviewGuestCellComponents()
    
    func setup(_ profile: Profile){
        let imageView = components.imageView
        contentView.addSubview(imageView)
        imageView.centerX(inView: contentView, topAnchor: contentView.topAnchor)
        
       
        
        let nameLabel = components.nameLabel
        contentView.addSubview(nameLabel)
        nameLabel.text = profile.display_name
        nameLabel.centerX(inView: contentView, topAnchor: imageView.bottomAnchor, paddingTop: .wProportioned(5))
        
        let skeletonGradient = components.skeletonGradient
        imageView.layer.addSublayer(skeletonGradient)
        imageView.sd_setImage(with: URL(string: profile.image_url)) { i, e, c, u in
            skeletonGradient.removeFromSuperlayer()
        }
        
        
        let border = components.border
        border.colors = profile.colors?.cgColors() ?? User.defaultColors.colorModel.cgColors()
        contentView.layer.addSublayer(border)
    }
}

struct EventOverviewGuestCellComponents: SkeletonLoadable{
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setDimensions(height: .makeWidth(85), width: .makeWidth(85))
        imageView.layer.cornerRadius = .makeWidth(42.5)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let border: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: .makeWidth(85), height: .makeWidth(85)))
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        let shape = CAShapeLayer()
        shape.lineWidth = .makeWidth(2)
        shape.path = UIBezierPath(roundedRect: gradient.bounds.insetBy(dx: 0.45, dy: 0.45),
                                  cornerRadius: .makeWidth(42.5)).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        return gradient
    }()
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(13))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.setWidth(.makeWidth(85))
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var skeletonGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        let animation = makeAnimationGroup()
        animation.beginTime = 0.0
        gradient.add(animation, forKey: "backgroundColor")
        gradient.frame = imageView.bounds
        return gradient
    }()
}
