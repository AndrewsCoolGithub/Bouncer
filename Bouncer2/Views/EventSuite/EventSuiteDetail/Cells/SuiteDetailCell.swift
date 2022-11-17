//
//  SuiteDetailCell.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/16/22.
//

import UIKit

final class SuiteDetailCell: UITableViewCell, SkeletonLoadable {
    static let id = "SuiteDetailCell"
    
    fileprivate let profileImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: .makeWidth(15), y: .wProportioned(10), width: .makeWidth(75), height: .makeWidth(75)), cornerRadius: .makeWidth(37.5), lineWidth: 1.5, direction: .horizontal)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    fileprivate let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(15))
        label.textAlignment = .left
        return label
    }()
    
    fileprivate let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsRegular(size: .makeWidth(15))
        label.textColor = .nearlyWhite()
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var skeletonGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        let animation = makeAnimationGroup()
        animation.beginTime = 0.0
        gradient.add(animation, forKey: "backgroundColor")
        gradient.frame = profileImage.bounds
        return gradient
    }()
    
    fileprivate let actionButton: UIButton = {
        let button = UIButton(frame: CGRect(x: .makeWidth(319), y: .wProportioned(28.75), width: .makeWidth(75), height: .wProportioned(37.5)))
        button.backgroundColor = .buttonFill()
        button.layer.cornerRadius = .wProportioned(12)
        button.tintColor = .white
        button.titleLabel?.font = .poppinsMedium(size: .makeWidth(16))
        return button
    }()
    
    fileprivate weak var delegate: SuiteCellDelegate!
    fileprivate var _profile: Profile!
    fileprivate var _section: EventSuiteDetail.Section!
    
    public func setup(_ profile: Profile, _ section: EventSuiteDetail.Section, _ type: EventSuiteDetailVM.DetailType?, delegate: SuiteCellDelegate?){
        guard let type = type, let delegate = delegate else {return}
        self.delegate = delegate
        self._profile = profile
        self._section = section
        
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
        
    
        guard section != .one && type != .open else {return}
        
        contentView.addSubview(actionButton)
        actionButton.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        
        
        if section == .one && type == .exclusive{
            actionButton.setTitle("Invite", for: .normal)
        }else{
            actionButton.setTitle("Cancel", for: .normal)
        }
    }
    
    @objc fileprivate func action(_ sender: UIButton){
        guard let id = _profile.id else {return}
        if _section == .one{
            delegate?.inviteUser(id)
        }else{
            delegate?.cancelInvite(id)
        }
    }
    
    deinit{
        delegate = nil
    }
}
