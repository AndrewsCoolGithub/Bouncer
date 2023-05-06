//
//  ChatReplyView.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 10/10/22.
//


import MessageKit

class ChatReplyView: MessageReusableView{
    
    static let id = "chat-reply-view"
    
    var styleColors: [UIColor]?
    
    fileprivate lazy var label: UITextView = {
        let label = UITextView()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.8)
        label.isScrollEnabled = false
        label.isEditable = false
        label.isSelectable = false
        label.backgroundColor = .clear
        label.textContainer.maximumNumberOfLines = 3
        label.textContainer.lineBreakMode = .byTruncatingTail
        label.contentInset = UIEdgeInsets(top: 1, left: 3, bottom: 1, right: 3)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate let replyingToLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: 12)
        label.textColor = .nearlyWhite()
        return label
    }()
    
    fileprivate let spacerView: UIView = {
        let view = UIView()
        view.backgroundColor = .nearlyWhite().withAlphaComponent(0.8)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 1.5
        return view
    }()
    
    fileprivate lazy var pastel: ChatMessageBubble = {
        let pastel = ChatMessageBubble(frame: .zero, colors: self.styleColors ?? [.white])
        pastel.layer.cornerRadius = .makeWidth(15)
        pastel.layer.masksToBounds = true
        return pastel
    }()
    
    fileprivate let blur: UIVisualEffectView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialDark))
        blur.alpha = 0.75
        blur.layer.cornerRadius = .makeWidth(15)
        blur.layer.masksToBounds = true
        return blur
    }()
    
    var labelSize: CGSize! {
        didSet{
            let x = .makeWidth(414) - labelSize.width - 25
            let y = self.frame.height - labelSize.height - 5
            pastel = ChatMessageBubble(frame:  CGRect(x: x, y: CGFloat(y), width: labelSize.width, height: labelSize.height), colors: self.styleColors ?? [.white])
            pastel.layer.cornerRadius = .makeWidth(15)
            pastel.layer.masksToBounds = true
            blur.frame = CGRect(x: x, y: CGFloat(y), width: labelSize.width, height: labelSize.height + 1)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.subviews.forEach({$0.removeFromSuperview()})
    }
    
    func setup(_ content: String?, displayName: String?, senderDisplayName: String?){
        guard let content = content, let displayName = displayName, let senderDisplayName = senderDisplayName else {return}
        label.removeConstraints(label.constraints)

        let size = content.sizeOfString(usingFont: .systemFont(ofSize: 12, weight: .medium), maxHeight: 100, maxWidth: .makeWidth(300))
        labelSize = size
        label.setDimensions(height: size.height, width: size.width)
        
        label.text = content
        label.layer.cornerRadius = .makeWidth(15)
        label.layer.masksToBounds = true
        
        if senderDisplayName == User.shared.displayName && displayName == User.shared.displayName {
            replyingToLabel.text = "You replied to yourself"
        }else if senderDisplayName == User.shared.displayName{
            replyingToLabel.text = "You replied to \(displayName)"
        }else{
            replyingToLabel.text = "\(senderDisplayName) replied to \(User.shared.displayName == displayName ? "You" : displayName)"
        }
        
        addSubview(pastel)
        addSubview(blur)
        addSubview(label)
        addSubview(replyingToLabel)
        addSubview(spacerView)
        
        let y: CGFloat = self.frame.height - size.height - 5
        
        label.anchor(bottom: self.bottomAnchor, paddingBottom: 5)
        
        if senderDisplayName == User.shared.displayName {
            let x = .makeWidth(414) - size.width - 25
            pastel.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
            blur.frame = CGRect(x: x, y: y, width: size.width, height: size.height + 1)
            
            label.anchor(right: self.rightAnchor, paddingRight: 25)
        
            replyingToLabel.anchor(bottom: label.topAnchor, right: self.rightAnchor, paddingBottom: 5, paddingRight: 25)
            
            spacerView.anchor(top: label.topAnchor, left: label.rightAnchor, bottom: label.bottomAnchor, right: self.rightAnchor, paddingLeft: 8, paddingRight: 14)
        }else{
            let avatarWidth: CGFloat = 30
            let x: CGFloat = 25 + avatarWidth
            pastel.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
            blur.frame = CGRect(x: x, y: y, width: size.width, height: size.height + 1)
            
            label.anchor(left: self.leftAnchor, paddingLeft: 25 + avatarWidth)
            
            replyingToLabel.anchor(left: self.leftAnchor, bottom: label.topAnchor, paddingLeft: 25 + avatarWidth, paddingBottom: 5)
            
            spacerView.anchor(top: label.topAnchor, left: self.leftAnchor, bottom: label.bottomAnchor, right: label.leftAnchor, paddingLeft: 14 + avatarWidth, paddingRight: 8)
        }
    }
    
//    func blurWithPastel(_ messageContainerView: MessageReusableView){
//        if let pastel = messageContainerView.subviews.first(where: {$0 is Pastel}) {
//            pastel.removeFromSuperview()
//        }
//        
//        if let blur = messageContainerView.subviews.first(where: {$0 is UIVisualEffectView}) {
//            blur.removeFromSuperview()
//        }
//        
//        messageContainerView.insertSubview(pastel, at: 0)
//        messageContainerView.insertSubview(blur, aboveSubview: pastel)
//    }
}
