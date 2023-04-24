//
//  ChatViewComponents.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/23/23.
//

import UIKit

struct ChatViewComponents: SkeletonLoadable {
    
    let headerChatBackground: Pastel = {
        let pastel = Pastel(frame: CGRect(origin: .zero, size: CGSize(width: .makeWidth(414), height: .wProportioned(75) + SafeArea.topSafeArea())))
        
        let shader = UIView()
        shader.frame = pastel.bounds
        
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        gradient.colors = [CGColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.5),
                           CGColor(red: 1, green: 1, blue: 1, alpha: 0)]
        gradient.frame = shader.bounds
        
        shader.layer.addSublayer(gradient)
        pastel.addSubview(shader)
        return pastel
    }()
    
    let backButton: UIButton = {
        let backButton = UIButton(frame: .zero)
        let config = UIImage.SymbolConfiguration(pointSize: .wProportioned(30), weight: .semibold)
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        backButton.tintColor = .white
        backButton.backgroundColor = .nearlyBlack().withAlphaComponent(0.2)
        backButton.setDimensions(height: .wProportioned(40), width: .wProportioned(40))
        backButton.layer.cornerRadius = .wProportioned(20)
        backButton.layer.masksToBounds = true
        return backButton
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.setDimensions(height: .wProportioned(45), width: .wProportioned(45))
        imageView.layer.cornerRadius = .wProportioned(22.5)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let displayNameLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .wProportioned(22.5))
        label.setWidth(.wProportioned(250))
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.minimumScaleFactor = 0.6
        return label
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .wProportioned(13.5))
        label.setWidth(.wProportioned(250))
        label.textColor = .nearlyWhite()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.minimumScaleFactor = 0.6
        return label
    }()
    
    
    let phoneCallButton: UIButton = {
        let button = UIButton(frame: .zero)
        let config = UIImage.SymbolConfiguration(pointSize: .wProportioned(22.5), weight: .semibold)
        button.setImage(UIImage(systemName: "phone.fill", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .nearlyBlack().withAlphaComponent(0.2)
        button.setDimensions(height: .wProportioned(40), width: .wProportioned(40))
        button.layer.cornerRadius = .wProportioned(20)
        button.layer.masksToBounds = true
        return button
    }()
    
    let videoCallButton: UIButton = {
        let button = UIButton(frame: .zero)
        let config = UIImage.SymbolConfiguration(pointSize: .wProportioned(20), weight: .semibold)
        button.setImage(UIImage(systemName: "video.fill", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .nearlyBlack().withAlphaComponent(0.2)
        button.setDimensions(height: .wProportioned(40), width: .wProportioned(40))
        button.layer.cornerRadius = .wProportioned(20)
        button.layer.masksToBounds = true
        return button
    }()
    
    lazy var profileSkeletonGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        let animation = makeAnimationGroup()
        animation.beginTime = 0.0
        gradient.add(animation, forKey: "backgroundColor")
        gradient.frame = profileImage.bounds
        return gradient
    }()
    
   
    
   
    
    
}
