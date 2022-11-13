//
//  EventSuiteDetailViewComponents.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/11/22.
//

import UIKit

public struct EventSuiteDetailViewComponents: SkeletonLoadable{
    let imageView: UIImageView = {
        let iv = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: .makeWidth(414), height: .wProportioned(170))))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let backButton: UIButton = {
        let backButton = UIButton(frame: .zero)
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(30), weight: .semibold)
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        backButton.tintColor = .white
        return backButton
    }()
    
    let shareButton: UIButton = {
        let backButton = UIButton(frame: .zero)
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(25))
        backButton.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: config), for: .normal)
        backButton.tintColor = .white
        return backButton
    }()
    
    let editButton: UIButton = {
        let backButton = UIButton(frame: .zero)
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(25))
        backButton.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: config), for: .normal)
        backButton.tintColor = .white
        return backButton
    }()
    
    let eventTitleLabel: UILabel = {
        let label = UILabel()
        label.setWidth(.makeWidth(300))
        label.font = .poppinsMedium(size: .makeWidth(21))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textAlignment = .center
        return label
    }()
    
    let timeTillLiveLabel: UILabel = {
        let label = UILabel()
        label.setWidth(.makeWidth(160))
        label.font = .poppinsMedium(size: .makeWidth(23))
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var dimmingOverlay: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: .makeWidth(414), height: .wProportioned(170))))
        view.layer.compositingFilter = "multiplyBlendMode"
        let gradientOverlay = CAGradientLayer()
        gradientOverlay.frame = view.bounds
        gradientOverlay.colors = [UIColor.black.cgColor, UIColor.white.cgColor]
        gradientOverlay.startPoint = CGPoint(x: 0.5, y: 0)
        gradientOverlay.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientOverlay, at: 1)
        view.alpha = 0.75
        return view
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
