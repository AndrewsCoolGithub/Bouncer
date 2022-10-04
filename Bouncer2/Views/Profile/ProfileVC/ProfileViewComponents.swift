//
//  ProfileViewComponents.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/9/22.
//

import Foundation
import UIKit
import UIImageColors

struct ProfileViewComponents: SkeletonLoadable{
    
    
    
    let backButton: UIButton = {
        let backButton = UIButton(frame: .zero)
        let config = UIImage.SymbolConfiguration(pointSize: .makeHeight(30), weight: .semibold)
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        backButton.tintColor = .white
        backButton.backgroundColor = .nearlyBlack().withAlphaComponent(0.2)
        backButton.setDimensions(height: .makeWidth(40), width: .makeWidth(40))
        backButton.layer.cornerRadius = .makeWidth(20)
        backButton.layer.masksToBounds = true
        return backButton
    }()
    
    let settingsButton: UIButton = {
        let backButton = UIButton(frame: .zero)
        let config = UIImage.SymbolConfiguration(pointSize: .makeHeight(30))
        backButton.setImage(UIImage(systemName: "gearshape.fill", withConfiguration: config), for: .normal)
        backButton.tintColor = .white
        return backButton
    }()
    
    let bannerImageView: UIImageView = {
        let bannerImageView = UIImageView(frame: CGRect(origin: .zero, size: .aspectGetSize(height: 207, width: 414)))
        bannerImageView.layer.masksToBounds = true
        bannerImageView.clipsToBounds = true
        bannerImageView.contentMode = .scaleAspectFill
        return bannerImageView
    }()
    
    lazy var bannerSkeletonGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        let animation = makeAnimationGroup()
        animation.beginTime = 0.0
        gradient.add(animation, forKey: "backgroundColor")
        gradient.frame = bannerImageView.bounds
        return gradient
    }()
    
    let profilePictureImageView: UIImageView = {
        let profilePictureImageView = UIImageView(frame: CGRect(origin: CGPoint(x: .makeWidth(20), y: .makeWidth(414) * 130/414), size: .aspectGetSize(height: 140, width: 140)), cornerRadius: .makeWidth(70), colors: UIImageColors.clear, lineWidth: .makeWidth(2.5), direction: .horizontal)
        profilePictureImageView.layer.masksToBounds = true
        profilePictureImageView.clipsToBounds = true
        profilePictureImageView.contentMode = .scaleAspectFill
        profilePictureImageView.focusOnFaces = true
        profilePictureImageView.layer.cornerRadius = .makeWidth(70)
        return profilePictureImageView
    }()
    
    lazy var profileSkeletonGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        let animation = makeAnimationGroup()
        animation.beginTime = 0.0
        gradient.add(animation, forKey: "backgroundColor")
        gradient.frame = profilePictureImageView.bounds
        return gradient
    }()
    
    let displayNameLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(21))
        label.setWidth(.makeWidth(214))
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.minimumScaleFactor = 0.6
        
        return label
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(16))
        label.setWidth(.makeWidth(214))
        label.textColor = .nearlyWhite()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.minimumScaleFactor = 0.6
        return label
    }()
    
   let bioLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsRegular(size: .makeWidth(14))
        label.setWidth(.makeWidth(374))
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.minimumScaleFactor = 0.8
        label.numberOfLines = 4
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let followRLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(14))
        label.textColor = .nearlyWhite()
        label.textAlignment = .left
        return label
    }()
    
    let followIngLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(14))
        label.textColor = .nearlyWhite()
        label.textAlignment = .left
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: .aspectGetSize(height: 50, width: 240)), cornerRadius: .makeWidth(25), colors: UIImageColors.clear, lineWidth: 1, direction: .horizontal)
        button.backgroundColor = .greyColor()
        button.titleLabel?.font = .poppinsMedium(size: .makeWidth(22))
        button.layer.applySketchShadow(color: .black.withAlphaComponent(0.5), alpha: 1, x: 0, y: .makeWidth(4), blur: .makeWidth(7), spread: .makeWidth(6), withRounding: .makeWidth(25))
        
        return button
    }()
}
