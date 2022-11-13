//
//  SuggestedCard.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/11/22.
//

import UIKit

final class SuggestedCard: UICollectionViewCell, SkeletonLoadable{
    
    static let id = "suggested-card"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: .makeWidth(30), y: .wProportioned(20), width: .makeWidth(75), height: .makeWidth(75)), cornerRadius: .makeWidth(37.5), lineWidth: 1.5, direction: .horizontal)
//        imageView.layer.cornerRadius = .makeWidth(20)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.defaultShadow(.makeWidth(20))
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .poppinsMedium(size: .makeWidth(15))
        nameLabel.setWidth(.makeWidth(110))
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.75
        nameLabel.textAlignment = .center
        return nameLabel
    }()
    
    private let userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.font = .poppinsRegular(size: .makeWidth(12.5))
        userNameLabel.setWidth(.makeWidth(110))
        userNameLabel.adjustsFontSizeToFitWidth = true
        userNameLabel.minimumScaleFactor = 0.75
        userNameLabel.textAlignment = .center
        userNameLabel.textColor = .nearlyWhite()
        return userNameLabel
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(frame: CGRect(x: .makeWidth(25), y: .wProportioned(149), width: .makeWidth(85), height: .wProportioned(40)), cornerRadius: .wProportioned(20), lineWidth: 1.5, direction: .horizontal)
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(17))
        let image = UIImage(systemName: "paperplane.fill", withConfiguration: config)
        button.tintColor = .white
        button.setImage(image, for: .normal)
        button.backgroundColor = .black
        button.layer.defaultShadow(.wProportioned(20))
        return button
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
    
    private let deleteButton: UIButton = {
        let button = UIButton(frame: CGRect(x: .makeWidth(110), y: -.makeWidth(10), width: .makeWidth(35), height: .makeWidth(35)), cornerRadius: .makeWidth(17.5), lineWidth: 1.5, direction: .horizontal)
        button.backgroundColor = .black
        button.tintColor = .white
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(16))
        let image = UIImage(systemName: "xmark", withConfiguration: config)
        button.setImage(image, for: .normal)
        return button
    }()

    
    func setup(_ profile: Profile){
        
        let colors = profile.colors?.uiImageColors() ?? User.defaultColors
        contentView.backgroundColor = .greyColor()
        contentView.layer.cornerRadius = .makeWidth(20)
        contentView.layer.defaultShadow(.makeWidth(20))
        contentView.clipsToBounds = false
        
        addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
        deleteButton.gradientColors = colors
        
        contentView.addSubview(imageView)
        imageView.gradientColors = colors
        imageView.layer.addSublayer(skeletonGradient)
        imageView.sd_setImage(with: URL(string: profile.image_url)) { [weak self] I, E, C, U in
            self?.skeletonGradient.removeFromSuperlayer()
        }
        
        
        contentView.addSubview(actionButton)
        actionButton.addTarget(self, action: #selector(actionPressed), for: .touchUpInside)
        actionButton.gradientColors = colors
        
        contentView.addSubview(nameLabel)
        nameLabel.centerX(inView: contentView, topAnchor: imageView.bottomAnchor, paddingTop: .wProportioned(5))
        nameLabel.text = profile.display_name
        
        contentView.addSubview(userNameLabel)
        userNameLabel.centerX(inView: contentView, topAnchor: nameLabel.bottomAnchor)
        userNameLabel.text = profile.user_name
        
    }
    
    @objc func deletePressed(){
        print("Remove suggested user")
    }
    
    @objc func actionPressed(){
        print("Invite user to event")
    }
}
