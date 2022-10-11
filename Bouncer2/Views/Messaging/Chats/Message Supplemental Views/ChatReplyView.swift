//
//  ChatReplyView.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 10/10/22.
//


import MessageKit

class ChatReplyView: MessageReusableView{
    
    static let id = "chat-reply-view"
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    fileprivate let label: UITextView = {
        let label = UITextView()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.8)
        label.isScrollEnabled = false
        label.isEditable = false
        label.isSelectable = false
        label.backgroundColor = .blueMinty().withAlphaComponent(0.8)
        label.textContainer.maximumNumberOfLines = 5
        label.textContainer.lineBreakMode = .byTruncatingTail
        label.setWidth(.makeWidth(300))
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subviews.forEach({$0.removeFromSuperview()})
    }
    
    func setup(_ content: String?, displayName: String?){
        guard let content = content, let displayName = displayName else {return}
        addSubview(contentView)
        contentView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor)
        
        
//        self.backgroundColor = .green
        label.text = content
        contentView.addSubview(label)
        contentView.addSubview(replyingToLabel)
        contentView.addSubview(spacerView)
        label.layer.cornerRadius = .makeWidth(15)
        label.layer.masksToBounds = true
        
        replyingToLabel.text = "You replied to \(displayName)"
        
        if label.intrinsicContentSize.width < .makeWidth(300){
//            print(label.intrinsicContentSize.width)
//            let w: CGFloat  = .makeWidth(300)
//            print(d)
            label.textAlignment = .right
            label.setWidth(label.intrinsicContentSize.width)
        }else{
            label.textAlignment = .left
        }
        
        label.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 30, paddingRight: 25)
        replyingToLabel.anchor(top: contentView.topAnchor, bottom: label.topAnchor, right: contentView.rightAnchor, paddingRight: 25)
        spacerView.anchor(top: label.topAnchor, left: label.rightAnchor, bottom: label.bottomAnchor, right: contentView.rightAnchor, paddingLeft: 8, paddingRight: 14)
        
//        label.anchor(right: contentView.rightAnchor, paddingRight: 0)
        
        
    }
    
    
    
    
}
