//
//  FullDetailViewComponents.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/30/22.
//

import Foundation
import UIKit

struct FullDetailViewComponents: SkeletonLoadable{
    
    let eventImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: .makeWidth(414), height: .wProportioned(233)))
        imageView.image = UIImage(named: "anImage")
        imageView.clipsToBounds = true
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
        gradient.frame = eventImageView.bounds
        return gradient
    }()
    
    let backButton: UIButton = {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        guard let safeAreaTop = window?.safeAreaInsets.top else {
            fatalError("Window - \(String(describing: window)) is unavailable")
        }
        let point = CGPoint(x: .makeWidth(20), y: safeAreaTop + .makeHeight(17))
        let backButton = UIButton(frame: CGRect(x: .makeWidth(20), y: safeAreaTop + .makeHeight(17), width: .makeWidth(21), height: .makeHeight(36)))
        let config = UIImage.SymbolConfiguration(pointSize: .makeHeight(30))
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        backButton.tintColor = .white
        return backButton
    }()
   
    
    //MARK: - Content View
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.setWidth(.makeWidth(385))
        label.textAlignment = .center
        label.numberOfLines = 5
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.font = .poppinsRegular(size: .makeWidth(16.5))
        return label
    }()
    
    
    let actionButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.imagePadding = .makeWidth(15)
        config.title = "Hello"
        let transformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.foregroundColor = UIColor.white
            outgoing.font = UIFont.poppinsMedium(size: .makeWidth(15.5))
            return outgoing
        }
        
        config.titleTextAttributesTransformer = transformer
        let button = UIButton(frame: CGRect(x: .makeWidth(87), y: .makeWidth(414) * 242/414, width: .makeWidth(240), height: .makeWidth(414) * 60/414))
        button.aspectSetDimensions(height: 60, width: 240)
        button.configuration = config
        button.backgroundColor = .buttonFill()
        button.layer.cornerRadius = (.makeWidth(414) * 60/414) * 0.33
        button.layer.masksToBounds = true
       
        button.tintColor = .white
        button.configuration?.title = "Hello"
        button.configuration?.attributedTitle = AttributedString("Hello", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.poppinsSemiBold(size: .makeWidth(50))]))
        button.layer.applySketchShadow(color: .black.withAlphaComponent(0.3), alpha: 1, x: 0, y: .makeHeight(5), blur: .makeWidth(8), spread: .makeWidth(4), withRounding: (.makeWidth(414) * 60/414) * 0.33)
        //button.titleLabel?.font = .poppinsSemiBold(size: .makeWidth(50))
      
        return button
    }()
   
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(15.5))
        label.textAlignment = .center
        label.textColor = .nearlyWhite()
        return label
    }()
    
    let peopleCountLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(17.5))
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    let peopleCV: UICollectionView = {
        let layout =  UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: .makeWidth(414) * 65/414, height: .makeWidth(414) * 65/414)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FullDetailPeopleCVCell.self, forCellWithReuseIdentifier: FullDetailPeopleCVCell.id)
        collectionView.backgroundColor = .greyColor()
        collectionView.alwaysBounceHorizontal = true
        collectionView.isDirectionalLockEnabled = true
        return collectionView
    }()
    
    let hostLabel: UILabel = {
        let label = UILabel()
        label.text = "Hosted by"
        label.font = .poppinsMedium(size: .makeWidth(17.5))
        label.textAlignment = .left
        return label
    }()
    
    
    
    
    
}
