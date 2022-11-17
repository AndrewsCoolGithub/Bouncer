//
//  SuggestedCard.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/11/22.
//

import UIKit

final class SuggestedCard: UICollectionViewCell, SkeletonLoadable{
    
    static let id = "suggested-card"
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: .makeWidth(30), y: .wProportioned(20), width: .makeWidth(75), height: .makeWidth(75)), cornerRadius: .makeWidth(37.5), lineWidth: 1.5, direction: .horizontal)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.defaultShadow(.makeWidth(20))
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .poppinsMedium(size: .makeWidth(15))
        nameLabel.setWidth(.makeWidth(110))
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.75
        nameLabel.textAlignment = .center
        return nameLabel
    }()
    
    fileprivate let userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.font = .poppinsRegular(size: .makeWidth(12.5))
        userNameLabel.setWidth(.makeWidth(110))
        userNameLabel.adjustsFontSizeToFitWidth = true
        userNameLabel.minimumScaleFactor = 0.75
        userNameLabel.textAlignment = .center
        userNameLabel.textColor = .nearlyWhite()
        return userNameLabel
    }()
    
    fileprivate let actionButton: UIButton = {
        let button = UIButton(frame: CGRect(x: .makeWidth(25), y: .wProportioned(149), width: .makeWidth(85), height: .wProportioned(40)), cornerRadius: .wProportioned(20), lineWidth: 1.5, direction: .horizontal)
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(17))
        let image = UIImage(systemName: "paperplane.fill", withConfiguration: config)
        button.tintColor = .white
        button.setImage(image, for: .normal)
        button.backgroundColor = .black
        button.layer.defaultShadow(.wProportioned(20))
        return button
    }()
    
    fileprivate lazy var skeletonGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        let animation = makeAnimationGroup()
        animation.beginTime = 0.0
        gradient.add(animation, forKey: "backgroundColor")
        gradient.frame = imageView.bounds
        return gradient
    }()
    
//    private let deleteButton: UIButton = {
//        let button = UIButton(frame: CGRect(x: .makeWidth(110), y: -.makeWidth(10), width: .makeWidth(35), height: .makeWidth(35)), cornerRadius: .makeWidth(17.5), lineWidth: 1.5, direction: .horizontal)
//        button.backgroundColor = .black
//        button.tintColor = .white
//        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(16))
//        let image = UIImage(systemName: "xmark", withConfiguration: config)
//        button.setImage(image, for: .normal)
//        return button
//    }()

    public func skeleton(){
        contentView.addSubview(skeletonView)
    }
    
    fileprivate var delegate: SuiteCellDelegate?
    fileprivate var profile: Profile!
    public func setup(_ profile: Profile, delegate: SuiteCellDelegate?){
        self.delegate = delegate
        self.profile = profile
        skeletonView.removeFromSuperview()
        let colors = profile.colors?.uiImageColors() ?? User.defaultColors
        contentView.backgroundColor = .greyColor()
        contentView.layer.cornerRadius = .makeWidth(20)
        contentView.layer.defaultShadow(.makeWidth(20))
        contentView.clipsToBounds = false
        
//        addSubview(deleteButton)
//        deleteButton.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
//        deleteButton.gradientColors = (colors, false)
        
        contentView.addSubview(imageView)
        imageView.gradientColors = (colors, false)
        imageView.layer.addSublayer(skeletonGradient)
        imageView.sd_setImage(with: URL(string: profile.image_url)) { [weak self] I, E, C, U in
            self?.skeletonGradient.removeFromSuperlayer()
        }
        
        
        contentView.addSubview(actionButton)
        actionButton.addTarget(self, action: #selector(actionPressed), for: .touchUpInside)
        actionButton.gradientColors = (colors, false)
        
        contentView.addSubview(nameLabel)
        nameLabel.centerX(inView: contentView, topAnchor: imageView.bottomAnchor, paddingTop: .wProportioned(5))
        nameLabel.text = profile.display_name
        
        contentView.addSubview(userNameLabel)
        userNameLabel.centerX(inView: contentView, topAnchor: nameLabel.bottomAnchor)
        userNameLabel.text = profile.user_name
        
    }
    
    @objc fileprivate func deletePressed(){
        print("Remove suggested user")
    }
    
    @objc fileprivate func actionPressed(){
        print("Invite user to event")
        guard let id = self.profile.id else {return}
        delegate?.inviteUser(id)
    }
    
    fileprivate lazy var skeletonView: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: .makeWidth(135), height: .wProportioned(210))))
        view.backgroundColor = .greyColor()
        view.layer.cornerRadius = .makeWidth(20)
        view.layer.defaultShadow(.makeWidth(20))
        view.clipsToBounds = false
        
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        let animation = makeAnimationGroup()
        animation.beginTime = 0.0
        gradient.add(animation, forKey: "backgroundColor")
        
        let skeletonImage = UIView(frame: CGRect(x: .makeWidth(30), y: .wProportioned(20), width: .makeWidth(75), height: .makeWidth(75)))
        skeletonImage.layer.cornerRadius = .makeWidth(37.5)
        skeletonImage.layer.masksToBounds = true
        skeletonImage.layer.defaultShadow(.makeWidth(20))
        view.addSubview(skeletonImage)
        gradient.frame = skeletonImage.bounds
        skeletonImage.layer.addSublayer(gradient)
        skeletonImage.clipsToBounds = true
        
        

        let gradient2 = CAGradientLayer()
        gradient2.startPoint = CGPoint(x: 0, y: 0.5)
        gradient2.endPoint = CGPoint(x: 1, y: 0.5)
        let animation2 = makeAnimationGroup()
        animation2.beginTime = 0.0
        gradient2.add(animation2, forKey: "backgroundColor")
        
        let skeletonButton = UIView(frame: CGRect(x: .makeWidth(25), y: .wProportioned(149), width: .makeWidth(85), height: .wProportioned(40)))
        skeletonButton.layer.cornerRadius = .wProportioned(20)
        skeletonButton.layer.masksToBounds = true
        skeletonButton.layer.defaultShadow(.wProportioned(20))
        view.addSubview(skeletonButton)
        gradient2.frame = skeletonButton.bounds
        skeletonButton.layer.addSublayer(gradient2)
        skeletonButton.clipsToBounds = true
        
        
        let gradient3 = CAGradientLayer()
        gradient3.startPoint = CGPoint(x: 0, y: 0.5)
        gradient3.endPoint = CGPoint(x: 1, y: 0.5)
        let animation3 = makeAnimationGroup()
        animation3.beginTime = 0.0
        gradient3.add(animation3, forKey: "backgroundColor")
        
        let line1 = UIView(frame: CGRect(x: .makeWidth(27.5), y: .wProportioned(107.5), width: .makeWidth(80), height: .wProportioned(7.5)))
        view.addSubview(line1)
        gradient3.frame = line1.bounds
        line1.layer.addSublayer(gradient3)
        
        let gradient4 = CAGradientLayer()
        gradient4.startPoint = CGPoint(x: 0, y: 0.5)
        gradient4.endPoint = CGPoint(x: 1, y: 0.5)
        let animation4 = makeAnimationGroup()
        animation4.beginTime = 0.0
        gradient4.add(animation4, forKey: "backgroundColor")
        
        let line2 = UIView(frame: CGRect(x: .makeWidth(42.5), y: .wProportioned(123), width: .makeWidth(50), height: .wProportioned(7.5)))
        view.addSubview(line2)
        gradient4.frame = line2.bounds
        line2.layer.addSublayer(gradient4)
        
        return view
    }()
}
