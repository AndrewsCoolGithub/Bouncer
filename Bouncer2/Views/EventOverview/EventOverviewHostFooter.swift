//
//  EventOverviewHostCell.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/12/22.
//

import UIKit

final class EventOverviewHostCell: UICollectionViewCell{
    
    static let id = "EventOverviewHostCell"
    
    var components = EventOverviewHostCellComponents()
    
    init(_ profile: Profile){
        super.init(frame: .zero)
        
        setDimensions(height: .makeWidth(103), width: .makeWidth(414))
        
        let imageView = components.imageView
        contentView.addSubview(imageView)
        imageView.anchor(top: topAnchor, paddingTop: .makeWidth(1.5))
        imageView.anchor(left: leftAnchor, paddingLeft: .makeWidth(15))
        
        let border = components.border
        border.colors = profile.colors?.cgColors() ?? User.defaultColors.colors.map({$0.cgColor})
        contentView.layer.addSublayer(border)
        
        let skeletonGradient = components.skeletonGradient
        imageView.layer.addSublayer(skeletonGradient)
        imageView.sd_setImage(with: URL(string: profile.image_url)) { i, e, c, u in
            skeletonGradient.removeFromSuperlayer()
        }
       
        let nameLabel = components.nameLabel
        nameLabel.text = profile.display_name
        contentView.addSubview(nameLabel)
        nameLabel.anchor(top: imageView.topAnchor, paddingTop: .makeWidth(17.5))
        nameLabel.anchor(left: imageView.rightAnchor, paddingLeft: .makeWidth(10))
        
        let userNameLabel = components.userNameLabel
        userNameLabel.text = profile.user_name
        contentView.addSubview(userNameLabel)
        userNameLabel.anchor(top: nameLabel.bottomAnchor, paddingTop: .makeWidth(3.5))
        userNameLabel.anchor(left: imageView.rightAnchor, paddingLeft: .makeWidth(10))
        
        let joinedLabel = components.joinedLabel
        joinedLabel.text = "Joined \((profile.timeJoined ?? .now).timeIntervalSince(.now).timeInBigUnits) ago"
        contentView.addSubview(joinedLabel)
        joinedLabel.anchor(top: userNameLabel.bottomAnchor, paddingTop: .makeWidth(3.5))
        joinedLabel.anchor(left: imageView.rightAnchor, paddingLeft: .makeWidth(10))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct EventOverviewHostCellComponents: SkeletonLoadable{
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = .makeWidth(32.5)
        imageView.setDimensions(height: .makeWidth(100), width: .makeWidth(100))
        return imageView
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
    
    let nameLabel: UILabel = { ///17.5px from top
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(16))
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    let userNameLabel: UILabel = { ///3.5px from bottom of name
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(13))
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    let joinedLabel: UILabel = { ///3.5px from bottom of name
        let label = UILabel()
        label.font = .poppinsRegular(size: .makeWidth(11))
        label.textColor = .nearlyWhite()
        label.textAlignment = .left
        return label
    }()
    
    let border: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint(x: .makeWidth(13.5), y: 0), size: CGSize(width: .makeWidth(103), height: .makeWidth(103)))
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        let shape = CAShapeLayer()
        shape.lineWidth = .makeWidth(2)
        shape.path = UIBezierPath(roundedRect: gradient.bounds.insetBy(dx: 0.45, dy: 0.45),
                                  cornerRadius: .makeWidth(32.5)).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        return gradient
    }()
}
