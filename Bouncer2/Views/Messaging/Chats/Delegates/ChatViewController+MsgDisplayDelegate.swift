//
//  ChatViewController+DisplayDelegate.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 10/11/23.
//

import MessageKit
import AVKit

extension ChatViewController: MessagesDisplayDelegate{
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if message.sender.senderId == User.shared.id{
            return .blueMinty()
        }
        
        return .lightGreyColor()
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if message.sender.senderId == User.shared.id{
            return .white
        }
        
        return .offWhite()
    }
    
    func messageFooterView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageReusableView {
        
        let reusableView = messagesCollectionView.dequeueReusableFooterView(ChatEmoteView.self, for: indexPath)
        guard let cell = messagesCollectionView.cellForItem(at: indexPath) as? MessageContentCell else {return reusableView}
        guard let reactions = (self.messages[indexPath.section] as? Message)?.emojiReactions else { return  reusableView}
        let convertedPoint = cell.convert(cell.messageContainerView.frame.origin, to: view)
        reusableView.setup(with: reactions, viewModel!, convertedPoint.x)
        return reusableView
    }
    
    func messageHeaderView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageReusableView {
        
        let reusableView = messagesCollectionView.dequeueReusableHeaderView(ChatReplyView.self, for: indexPath)
        
        guard let data = (self.messages[indexPath.section] as? Message)?.replyReceipt else {return reusableView}
        guard let text = data.text else {return reusableView}

        reusableView.styleColors = viewModel?.styleColors
        reusableView.setup(text, displayName: data.displayName, senderDisplayName: data.senderDisplayName)
//        reusableView.maxWidth = .makeWidth(414)
//        reusableView.textView.text = text
        return reusableView
    }
    
    //MARK: Setup video
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        
        
        guard let data = message as? Message,
              data.dataType == .video,
              let rawURL = data.mediaURL,
              let mediaURL = URL(string: rawURL) else {return}
        
        
        //If has avplayer, remove from view and remove parent from ChatVC
        
        if imageView.subviews.first?.next is ChatViewVideoPlayerVC {
            guard let oldController = imageView.subviews.first?.next as? ChatViewVideoPlayerVC else {return}
            oldController.view.removeFromSuperview()
            oldController.removeFromParent()
        }
        
        let vc = ChatViewVideoPlayerVC(mediaURL)
        
        self.addChild(vc)
        imageView.addSubview(vc.view)
        vc.didMove(toParent: self)
        
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        

        let message = message as! Message
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        let animation = makeAnimationGroup()
        animation.beginTime = 0.0
        gradient.add(animation, forKey: "backgroundColor")
        gradient.frame = avatarView.bounds
        avatarView.layer.addSublayer(gradient)
        
        guard let imageURL = viewModel!.profiles.first(where: {$0.id == message.sender.senderId})?.image_url else {return}
        avatarView.sd_setImage(with: URL(string: imageURL)) { i, e, c, u in
            gradient.removeFromSuperlayer()
        }
    }
    
    
}
