//
//  EmoteCVSectionHeader.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 9/16/22.
//


import UIKit

class EmoteCVSectionHeader: UICollectionReusableView{
    
    static let id = "emote-cv-section-header"
    
    fileprivate let titleLabel: UILabel = {
        let label =  UILabel()
        label.font = .poppinsMedium(size: .makeWidth(18))
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    fileprivate let customizeButton: UIButton = {
        let button = UIButton()
        button.text("Customize")
        button.titleLabel?.font = .poppinsMedium(size: .makeWidth(14))
        button.titleLabel?.textAlignment = .right
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    var customizeEmojiDelegate: CustomizeEmojiDelegate!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        titleLabel.removeFromSuperview()
        customizeButton.removeTarget(nil, action: nil, for: .allEvents)
        customizeButton.removeFromSuperview()
        customizeEmojiDelegate = nil
    }
    
    func setup(_ title: String, delegate: CustomizeEmojiDelegate?){
        self.customizeEmojiDelegate = delegate
        if title == "My Reactions"{
            addSubview(customizeButton)
            customizeButton.centerYright(inView: self, rightAnchor: rightAnchor, paddingRight: .makeWidth(15))
            customizeButton.addTarget(self, action: #selector(customizeEmojiSet), for: .touchUpInside)
        }
        
        titleLabel.text = title
        addSubview(titleLabel)
        titleLabel.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: .makeWidth(10))
        
    }
    
    @objc fileprivate func customizeEmojiSet(){
        guard let customizeEmojiDelegate = customizeEmojiDelegate else {return}
        customizeEmojiDelegate.openCustomizeView()
    }
}
