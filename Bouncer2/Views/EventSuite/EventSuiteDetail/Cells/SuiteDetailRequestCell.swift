//
//  SuiteDetailRequestCell.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/14/22.
//

import UIKit

class SuiteDetailRequestCell: UITableViewCell, SkeletonLoadable {
    static let id = "SuiteDetailRSVPCell"
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: .makeWidth(15), y: .wProportioned(10), width: .makeWidth(75), height: .makeWidth(75)), cornerRadius: .makeWidth(37.5), lineWidth: 1.5, direction: .horizontal)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(15))
        label.textAlignment = .left
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsRegular(size: .makeWidth(15))
        label.textColor = .nearlyWhite()
        label.textAlignment = .left
        return label
    }()
    
    private lazy var skeletonGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        let animation = makeAnimationGroup()
        animation.beginTime = 0.0
        gradient.add(animation, forKey: "backgroundColor")
        gradient.frame = profileImage.bounds
        return gradient
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonFill()
        
        
        return button
    }()
    
    func setup(_ profile: Profile, cellDelegate: SuiteCellDelegate){
        contentView.backgroundColor = .greyColor()
        contentView.addSubview(profileImage)
        profileImage.gradientColors = (profile.colors?.uiImageColors() ?? User.defaultColors, false)
        profileImage.layer.addSublayer(skeletonGradient)
        profileImage.sd_setImage(with: URL(string: profile.image_url)) { [weak self] I, E, C, U in
            self?.skeletonGradient.removeFromSuperlayer()
        }
        
        contentView.addSubview(userNameLabel)
        userNameLabel.text = profile.user_name
        userNameLabel.anchor(top: profileImage.topAnchor, paddingTop: .wProportioned(14))
        userNameLabel.anchor(left: profileImage.rightAnchor, paddingLeft: .makeWidth(15))
        contentView.addSubview(nameLabel)
        nameLabel.text = profile.display_name
        nameLabel.anchor(top: userNameLabel.bottomAnchor, paddingTop: .wProportioned(4))
        nameLabel.anchor(left: profileImage.rightAnchor, paddingLeft: .makeWidth(15))
        
    }
}
