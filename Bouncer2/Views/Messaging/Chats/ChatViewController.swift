//
//  ChatViewController.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 8/25/22.
//

import Foundation
import MessageKit
import Combine
import UIKit
import InputBarAccessoryView


//TODO: FOR FILE:
/** Move: REPLY FUNCTIONALITY,  DELEGATE METHODS, EXTENSIONS, etc.
 
 Important: HeaderView navigation bar doesnt load wihtout internet connection
 */

protocol MessageBarDelegate: AnyObject{
    func showBar()
    func hideBar()
}

class ChatViewController: MessagesViewController, MessagesLayoutDelegate, SkeletonLoadable, InputBarAccessoryViewDelegate, MessageBarDelegate, UINavigationControllerDelegate{
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
       print("Our text is: \(text)")
   }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        print(size)
    }
   
    let sender = Sender(senderId: User.shared.id!, displayName: User.shared.displayName ?? "Me")
    var messages: [MessageType] = []
    var viewModel: ChatViewModel?
    let keyboardUpdater = ChatKeyboardUpdater()
    var keyboardStatus: Bool = false
    var messageInputBarOrgin: CGPoint!
    var viewComponents = ChatViewComponents()
    
    func loadMessages(for messageDetail: MessageDetail, profiles: [Profile]){
        let viewModel = ChatViewModel(messageDetail, profiles: profiles)
        self.viewModel = viewModel
        viewModel.$messages.sink { [weak self] messages in
            guard messages != nil else {return}
            self?.messages = messages!
            self?.messagesCollectionView.reloadData()
        }.store(in: &viewModel.cancellable)
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
            return false
    }
    
    //MARK: - Access to Cell
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! MessageContentCell
    
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressDo))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delaysTouchesBegan = true
        cell.contentView.addGestureRecognizer(longPressedGesture)
       
        blurWithPastel(cell.messageContainerView)
        
        
        return cell
    }
    
    func blurWithPastel(_ messageContainerView: MessageContainerView){
        if let pastel = messageContainerView.subviews.first(where: {$0 is ChatMessageBubble}) {
            pastel.removeFromSuperview()
        }
      
        let pastel = ChatMessageBubble(frame: .zero, colors: viewModel?.styleColors ?? User.defaultColors.colors)
        pastel.frame = messageContainerView.bounds
        
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        blur.frame = pastel.bounds
        blur.alpha = 0.5
        pastel.addSubview(blur)
        
        messageContainerView.insertSubview(pastel, at: 0)
    }
    
   
    
    //MARK: - Long Press Action
    
    
    @objc func longPressDo(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }
        
        let p = gestureRecognizer.location(in: messagesCollectionView) ///For grabbing IndexPath
       
        if let indexPath = messagesCollectionView.indexPathForItem(at: p) {
            
            let cell = messagesCollectionView.cellForItem(at: indexPath)! as! MessageContentCell
            let message = self.messages[indexPath.section] as! Message
            let point = gestureRecognizer.location(in: view) ///Positioning Reaction Bubble
            cell.setupSubviews()
            if cell.gestureRecognizerShouldBegin(gestureRecognizer){
                HapticsManager.shared.selectionVibration()
                showPopupView(cell, message, point)
            }
        }
    }
    
    fileprivate func showPopupView(_ cell: MessageContentCell, _ message: Message, _ point: CGPoint) {
        let convertedPoint = cell.convert(cell.messageContainerView.frame.origin, to: view)
        let chatPopup = ChatPopupVC(message,
                                    point,
                                    cellFrame: CGRect(origin: convertedPoint,
                                                      size: cell.frame.size),
                                    delegate: self,
                                    keyboardUpdater: keyboardUpdater, barActions: self)
        
        UIView.animate(withDuration: 0.3, animations: {
            cell.transform = CGAffineTransform(translationX: cell.frame.width * 0.1, y: 0)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                cell.transform = CGAffineTransform.identity
            }
        })
        
        hideBar()
        self.addChild(chatPopup)
        chatPopup.willMove(toParent: self)
        view.addSubview(chatPopup.view)
        
        ///TODO: -
//        ///Dismiss pop up if user decides to open emojis or any keyboard activity that chages the frame
//        var cancellable: AnyCancellable?
//        cancellable = keyboardUpdater.$willChangeFrame.sink { bool in
//            if bool {
//                chatPopup.animateOut()
//                cancellable?.cancel()
//            }
//        }
    }
    
     func showBar() {
         UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 1.5) { [weak self] in
            self?.messageInputBar.frame.origin = self?.messageInputBarOrgin ?? self!.messageInputBar.frame.origin
            self?.messageInputBar.inputTextView.isEditable = true
            self?.messageInputBar.isHidden = false
           
        }
    }
    
    func hideBar(){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 1.5) { [weak self] in
            self?.messageInputBar.frame.origin.y = .makeHeight(900)
            self?.messageInputBar.inputTextView.isEditable = false
            self?.messageInputBar.isHidden = true
        }
    }
//    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//
//        // Get the view for the first header
//        let indexPath = IndexPath(row: 0, section: section)
//        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
//
//        // Use this view to calculate the optimal size based on the collection view's width
//        
//        return headerView.systemLayoutSizeFitting(CGSize(width: 1, height: UIView.layoutFittingExpandedSize.height),
//                                                  withHorizontalFittingPriority: .required, // Width is fixed
//                                                  verticalFittingPriority: .fittingSizeLevel) // Height can be as large as needed
//    }
    let inputDelegate = ChatViewControllerInputTextViewDelegate()
    fileprivate func setupMessageInputBar() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        showMessageTimestampOnSwipeLeft = true
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageIncomingAvatarPosition(AvatarPosition(horizontal: .natural, vertical: .messageBottom))
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageOutgoingAvatarSize(.zero)
        messageInputBar.sendButton.addTarget(self, action: #selector(sendClicked), for: .touchUpInside)
        
        inputDelegate.i = self
        messageInputBar.inputTextView.delegate = inputDelegate
        
//        let sendButton = messageInputBar.sendButton
//        sendButton.tintColor = .white
//        sendButton.setTitleColor(.systemCyan, for: .normal)
//        let shareIcon = UIImage(named: "share-icon")?.tintedWithLinearGradientColors(uiColors: userColors ?? User.defaultColors.colors)
//        sendButton.setImage(shareIcon, for: .normal)
//        sendButton.title = ""
//        sendButton.setSize(CGSize(width: 30, height: 30), animated: false)
        
        messageInputBar.sendButton.isHidden = true
        messageInputBar.inputTextView.returnKeyType = .send
        messageInputBar.delegate = self
       
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.register(ChatEmoteView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        messagesCollectionView.register(ChatReplyView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = .white
        let cameraIcon = UIImage(named: "camera-filled-icon")
        cameraItem.image = cameraIcon
        //TODO: - Camera button won't react to tintedWithLinearGradientColors (posibly order of operations within InputBarItem
        cameraItem.addTarget(
            self,
            action: #selector(cameraPressed),
            for: .primaryActionTriggered
        )
        
        cameraItem.setSize(CGSize(width: 30, height: 30), animated: false)
        
        
        let cameraRollItem = InputBarButtonItem(type: .system)
        cameraRollItem.tintColor = .white
        let cameraRollIcon = UIImage(systemName: "photo.on.rectangle.angled", withConfiguration: UIImage.SymbolConfiguration(pointSize: .wProportioned(20)))
        cameraRollItem.image = cameraRollIcon
        cameraRollItem.addTarget(
            self,
            action: #selector(openCameraRoll),
            for: .primaryActionTriggered
        )
        cameraRollItem.setSize(CGSize(width: 30, height: 30), animated: false)
        messageInputBar.sendButton.removeFromSuperview()
        
        let microphoneItem = InputBarButtonItem(type: .system)
        microphoneItem.tintColor = .white
        microphoneItem.image = UIImage(systemName: "mic.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: .wProportioned(25)))
        microphoneItem.addTarget(
            self,
            action: #selector(cameraPressed),
            for: .primaryActionTriggered
        )
       
        microphoneItem.setSize(CGSize(width: 30, height: 30), animated: false)
        messageInputBar.sendButton.removeFromSuperview()
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.rightStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        messageInputBar.setRightStackViewWidthConstant(to: 100, animated: false)
        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
        messageInputBar.setStackViewItems([cameraRollItem, microphoneItem], forStack: .right, animated: false)
        messageInputBar.backgroundColor = .nearlyBlack()
        messageInputBar.backgroundView.backgroundColor = .nearlyBlack()
        messageInputBar.separatorLine.isHidden = true
        
        
        let inputTextView = messageInputBar.inputTextView
        
        inputTextView.textColor = .white
        inputTextView.backgroundColor = .lightGreyColor()
        inputTextView.layer.cornerRadius = 14.0
        inputTextView.layer.borderWidth = 0.0
        inputTextView.font = .poppinsMedium(size: .makeWidth(16))
        inputTextView.placeholderLabel.textColor = .nearlyWhite()
        inputTextView.placeholderLabel.text = "Message..."
        inputTextView.textContainerInset = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 6, left: 15, bottom: 6, right: 15)
        
        inputTextView.tintColor = viewModel?.styleColors.brightestColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            print("MessageInputBar frame : \(self.messageInputBar.frame), textView: \(inputTextView.frame)")
            
        }
    }
    
    @objc func openCameraRoll(){
        
        let cameraRollVC = ChatCameraRollPanel(ChatCameraRollVC())
        cameraRollVC.addPanel(toParent: self, animated: true)
        
        
        hideBar()
        
    }
    
    var replyMessage: Message?
    internal func setupReplyHeader(_ displayName: String, _ message: Message) {
        replyMessage = message
        let myButton = UIButton()
        myButton.setDimensions(height: .makeHeight(.makeHeight(85)), width: .makeWidth(414))
        myButton.backgroundColor = .nearlyBlack()
        
        let label = UILabel()
        label.text = "Replying to \(displayName)"
        label.font = .poppinsRegular(size: .makeWidth(12))
        label.textColor = .nearlyWhite()
        myButton.addSubview(label)
        label.anchor(top: myButton.topAnchor, paddingTop: .makeHeight(6))
        label.anchor(left: myButton.leftAnchor, paddingLeft: .makeWidth(15))
        
        lazy var contentText: String = {
            let messageKind = message.kind
            switch messageKind {
            case .text(let string):
                return string.count > 30 ? "\(string.prefix(30))..." : string
            case .photo( _):
                return "Photo"
            case .video( _):
                return "Video"
            case .location( _):
                return "Location"
            case .emoji(let string):
                return string.count > 30 ? "\(string.prefix(30))..." : string
            case .audio(_):
                return "Audio"
            default:
                return "Message"
        }}()
        
        let subLabel = UILabel()
        subLabel.text = "\(contentText)"
        subLabel.font = .poppinsRegular(size: .makeWidth(12))
        subLabel.textColor = .white
        myButton.addSubview(subLabel)
        subLabel.anchor(top: label.bottomAnchor, paddingTop: .makeHeight(4))
        subLabel.anchor(left: myButton.leftAnchor, paddingLeft: .makeWidth(15))
        
        let xButton = UIButton()
        xButton.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: .makeWidth(20))), for: .normal)
        xButton.tintColor = .white
        xButton.addTarget(self, action: #selector(endReply), for: .touchUpInside)
        myButton.addSubview(xButton)
        xButton.centerYright(inView: myButton, rightAnchor: myButton.rightAnchor, paddingRight: .makeWidth(15))
        
        messageInputBar.topStackView.addArrangedSubview(myButton)
    }
    
     
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .nearlyBlack()
        messagesCollectionView.backgroundColor = .nearlyBlack()
        messageInputBarOrgin = messageInputBar.frame.origin
        guard viewModel != nil else {fatalError("loadMessages must be called ")}
        setupMessageInputBar()
        guard let recipientProfile = viewModel?.profiles.first(where: {$0.id != User.shared.id}) else {return}
        setupHeaderBar(recipientProfile)
    }
    
    func setupHeaderBar(_ recipient: Profile){
        let headerChatBackground = ChatHeaderBackground(frame: CGRect(origin: .zero, size: CGSize(width: .makeWidth(414), height: .wProportioned(75) + SafeArea.topSafeArea())), colors: recipient.colors?.uiColors() ?? User.defaultColors.colors)
        view.addSubview(headerChatBackground)

        
        let backButton = viewComponents.backButton
        headerChatBackground.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: .wProportioned(20))
        backButton.anchor(left: view.leftAnchor, paddingLeft: .wProportioned(20))
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        let profileImage = viewComponents.profileImage
        headerChatBackground.addSubview(profileImage)
        profileImage.centerY(inView: backButton, leftAnchor: backButton.rightAnchor, paddingLeft: .wProportioned(20))
        
        let skeletonGradient = viewComponents.profileSkeletonGradient
        profileImage.layer.addSublayer(skeletonGradient)
        
        profileImage.sd_setImage(with: URL(string: recipient.image_url)) { i, e, c, u in
            skeletonGradient.removeFromSuperlayer()
        }

        let displayNameLabel = viewComponents.displayNameLabel
        headerChatBackground.addSubview(displayNameLabel)
        displayNameLabel.text = recipient.display_name
        displayNameLabel.anchor(top: profileImage.topAnchor)
        displayNameLabel.anchor(left: profileImage.rightAnchor, paddingLeft: .wProportioned(15))

        let userNameLabel = viewComponents.userNameLabel
        headerChatBackground.addSubview(userNameLabel)
        userNameLabel.text = recipient.user_name
        userNameLabel.anchor(bottom: profileImage.bottomAnchor)
        userNameLabel.anchor(left: profileImage.rightAnchor, paddingLeft: .wProportioned(15))
        
        let videoCallButton = viewComponents.videoCallButton
        headerChatBackground.addSubview(videoCallButton)
        videoCallButton.centerYright(inView: backButton, rightAnchor: view.rightAnchor, paddingRight: .wProportioned(20))
        videoCallButton.addTarget(self, action: #selector(startVideoCall), for: .touchUpInside)
        
        let phoneCallButton = viewComponents.phoneCallButton
        headerChatBackground.addSubview(phoneCallButton)
        phoneCallButton.centerYright(inView: videoCallButton, rightAnchor: videoCallButton.leftAnchor, paddingRight: .wProportioned(15))
        phoneCallButton.addTarget(self, action: #selector(startPhoneCall), for: .touchUpInside)
        
    }
    
    @objc func goBack(_ sender: UIButton){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func startPhoneCall(_ sender: UIButton) {
        print("MKE THE PHONE CALL")
    }
    
    @objc func startVideoCall(_ sender: UIButton) {
        print("DO THE VIDEO CALL STUFF")
    }
    
    @objc func endReply(){
        replyMessage = nil
        UIView.animate(withDuration: 0.6, delay: 0) {
            self.messageInputBar.topStackView.alpha = 0.0
            self.messageInputBar.backgroundView.alpha = 0.0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.messageInputBar.topStackViewPadding = UIEdgeInsets(top: -.makeHeight(62), left: 0, bottom: 0, right: 0)
            }
        }completion: { _ in
            self.messageInputBar.topStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
            self.messageInputBar.topStackView.setup()
            self.messageInputBar.topStackViewPadding = .zero
            self.messageInputBar.topStackView.alpha = 1
            self.messageInputBar.backgroundView.alpha = 1
           
        }
    }
    
    @objc func cameraPressed(){
        
    }
    
    @objc func sendClicked(){
        print(messageInputBar.inputTextView.images)
        guard let content = messageInputBar.inputTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines), !content.isBlank else {return}
        
        
        messageInputBar.inputTextView.text = ""
       
        if let replyMessage = replyMessage?.toCodable() {
            let replyReceipt = ReplyReceipt(messageID: replyMessage.messageID, userID: replyMessage.senderID, displayName:  replyMessage.displayName, senderDisplayName: sender.displayName, dataType: replyMessage.dataType, text: replyMessage.text, mediaURL: replyMessage.mediaURL, duration: replyMessage.duration)
            viewModel?.sendMessage(.text, content: content, replyReceipt: replyReceipt)
            endReply()
        }else{
            viewModel?.sendMessage(.text, content: content, replyReceipt: nil)
        }
    }
    
    
   

    
    //MARK: - Avatar
    
    //MARK: DONT THINK THIS FUCTION WORKS, actual dimensions are 30/30 on iPhone 11 (Frame: (0.0, 6.0, 30.0, 30.0) )
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
            return CGSize(width: .makeHeight(50), height: .makeHeight(50))
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
    
    func messageBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment? {
        return LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6))
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messages.count else { return false }
        return messages[indexPath.section].sender.senderId == messages[indexPath.section + 1].sender.senderId
      }
}
//MARK: - Display Delegate
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
    
    
}

extension ChatViewController: MessageCellDelegate{
    //TODO: Open profile by avatar tap
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        
    }
    
    func didTapBackground(in cell: MessageCollectionViewCell) {
        
    }
    
}







