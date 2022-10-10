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

protocol MessageBarDelegate: AnyObject{
    func showBar()
    func hideBar()
}

class ChatViewController: MessagesViewController, MessagesLayoutDelegate, SkeletonLoadable, InputBarAccessoryViewDelegate, MessageBarDelegate{

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
    }
   
    let sender = Sender(senderId: User.shared.id!, displayName: User.shared.displayName ?? "Me")
    var messages: [MessageType] = []
    var viewModel: ChatViewModel?
    let keyboardUpdater = ChatKeyboardUpdater()
    var keyboardStatus: Bool = false
    var messageInputBarOrgin: CGPoint!
    
    func loadMessages(for messageDetail: MessageDetail, users: [String]){
        let viewModel = ChatViewModel(messageDetail, users: users)
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
       
        
        return cell
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
         print("Show bar")
    }
    
    func hideBar(){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 1.5) { [weak self] in
            self?.messageInputBar.frame.origin.y = .makeHeight(900)
            self?.messageInputBar.inputTextView.isEditable = false
            self?.messageInputBar.isHidden = true
        }
    }
    
    
    fileprivate func setupMessageInputBar() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        showMessageTimestampOnSwipeLeft = true
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageIncomingAvatarPosition(AvatarPosition(horizontal: .natural, vertical: .messageBottom))
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageOutgoingAvatarSize(.zero)
        messageInputBar.sendButton.addTarget(self, action: #selector(sendClicked), for: .touchUpInside)
       
        
        let sendButton = messageInputBar.sendButton
        sendButton.tintColor = .systemCyan
        sendButton.setTitleColor(.systemCyan, for: .normal)
        let shareIcon = UIImage(named: "share-icon")!.withRenderingMode(.alwaysTemplate)
        sendButton.setImage(shareIcon, for: .normal)
        sendButton.title = ""
        sendButton.setSize(CGSize(width: 30, height: 30), animated: false)
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.register(ChatEmoteView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = .systemCyan
        let cameraIcon = UIImage(named: "camera-filled-icon")?.withRenderingMode(.alwaysTemplate)
        cameraItem.image = cameraIcon
        cameraItem.addTarget(
            self,
            action: #selector(cameraPressed),
            for: .primaryActionTriggered
        )
        
        cameraItem.setSize(CGSize(width: 30, height: 30), animated: false)
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        messageInputBar.setRightStackViewWidthConstant(to: 35, animated: false)
        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
        messageInputBar.backgroundColor = .nearlyBlack()
        messageInputBar.backgroundView.backgroundColor = .nearlyBlack()
        messageInputBar.separatorLine.isHidden = true
        
        let inputTextView = messageInputBar.inputTextView
        inputTextView.tintColor = .systemCyan
        inputTextView.textColor = .white
        inputTextView.backgroundColor = .lightGreyColor()
        inputTextView.layer.cornerRadius = 14.0
        inputTextView.layer.borderWidth = 0.0
        inputTextView.font = .poppinsMedium(size: .makeWidth(16))
        inputTextView.placeholderLabel.textColor = .nearlyWhite()
        inputTextView.placeholderLabel.text = "Message..."
        inputTextView.textContainerInset = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 6, left: 15, bottom: 6, right: 15)
    }
    
    fileprivate func setupReplyHeader(_ displayName: String, _ messageKind: MessageKind) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .nearlyBlack()
        messagesCollectionView.backgroundColor = .nearlyBlack()
        messageInputBarOrgin = messageInputBar.frame.origin
        guard viewModel != nil else {fatalError("loadMessages must be called ")}
        setupMessageInputBar()
    }
    
    @objc func endReply(){
        
        UIView.animate(withDuration: 0.6, delay: 0) {
            self.messageInputBar.topStackView.alpha = 0.0
            self.messageInputBar.backgroundView.alpha = 0.0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                self.messageInputBar.topStackView.removeFromSuperview()
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
        guard let content = messageInputBar.inputTextView.text else {return}
        viewModel?.sendMessage(.text, content: content)
        messageInputBar.inputTextView.text = ""
       
    }
    
    
   

    
    //MARK: Avatar
    
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
        
        guard let imageURL = viewModel!.userData[message.sender.senderId]?.image_url else {return}
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
            return .greyColor()
        }
        
        return .nearlyWhite()
    }
    
    func messageFooterView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageReusableView {
        
        let resuableView = messagesCollectionView.dequeueReusableFooterView(ChatEmoteView.self, for: indexPath)
        guard let cell = messagesCollectionView.cellForItem(at: indexPath) as? MessageContentCell else {return resuableView}
        guard let reactions = (self.messages[indexPath.section] as? Message)?.emojiReactions else { return  resuableView}
        let convertedPoint = cell.convert(cell.messageContainerView.frame.origin, to: view)
        resuableView.setup(with: reactions, viewModel!, convertedPoint.x)
        return resuableView
    }
    
    
}

extension ChatViewController: MessageCellDelegate{
    //TODO: Open profile by avatar tap
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        
    }
    func didTapBackground(in cell: MessageCollectionViewCell) {
        
    }
    
}

extension ChatViewController: MessagesDataSource {
    func currentSender() -> MessageKit.SenderType {
        sender
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
   
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        guard let data = messages[section] as? Message, data.emojiReactions != nil else {return .zero}
        return CGSize(width: 35, height: 20)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section == messages.count - 1{
            return 15
        }
        return 0
    }
    
//    func messageTimestampLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        //TODO: - Replace day of the week if today / yesterday
//
//
//        return nil
//    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let message = message as! Message
        if !isNextMessageSameSender(at: indexPath), isFromCurrentSender(message: message), message.isDelivered {
            guard let readReceipts = message.readReceipts else {
                return NSAttributedString(
                  string: "Delivered",
                  attributes: [NSAttributedString.Key.font: UIFont.poppinsRegular(size: .makeHeight(15)), NSAttributedString.Key.foregroundColor: UIColor.nearlyWhite()])
            }
            
            let timeRead = readReceipts.sorted(by: {$0.timeRead < $1.timeRead})[0].timeRead
            let timeSince = (-timeRead.timeIntervalSince(.now)).timeInUnits
            
            return NSAttributedString(
              string: "Seen \(timeSince) ago",
              attributes: [NSAttributedString.Key.font: UIFont.poppinsRegular(size: .makeHeight(15)), NSAttributedString.Key.foregroundColor: UIColor.nearlyWhite()])
            
        }else if !message.isDelivered{
            return NSAttributedString(
              string: "Sending",
              attributes: [NSAttributedString.Key.font: UIFont.poppinsRegular(size: .makeHeight(15)),
                            NSAttributedString.Key.foregroundColor: UIColor.nearlyWhite()])
        }
        return nil
    }
}

extension ChatViewController: ChatReactDelegate{
    
    func openEmoteSelector(_ message: Message, _ popUpProp: ChatPopupVC.ChatPopupProperties) {
        let emoteSelector = ChatEmoteSelector(viewModel: viewModel)
        emoteSelector.chatEmoteSelectorCC = ChatEmoteSelectorCC()
        emoteSelector.popupProp = popUpProp
        emoteSelector.chatEmoteSelectorCC.delegate = self
        emoteSelector.chatEmoteSelectorCC.message = message
        emoteSelector.addPanel(toParent: self, animated: true)
        
    }
    
    func replyTo(_ message: Message) {
        self.setupReplyHeader(message.sender.displayName, message.kind)
    }
    
    func emoteReaction(for message: Message, _ emote: String) {
        guard let index = messages.firstIndex(where: {$0.messageId == message.messageId}) else {return}
        var temp = message
        if temp.emojiReactions != nil{
            if let existingIndex = message.emojiReactions!.firstIndex(where: {$0.uid == message.sender.senderId}){
                if temp.emojiReactions![existingIndex].emote == emote{
                    temp.emojiReactions!.remove(at: existingIndex)
                    if temp.emojiReactions!.isEmpty{
                        temp.emojiReactions = nil
                    }
                }else{
                    temp.emojiReactions![existingIndex] = EmoteReaction(emote: emote, uid: message.sender.senderId)
                }
            }else{
                temp.emojiReactions!.append(EmoteReaction(emote: emote, uid: message.sender.senderId))
            }
        }else{
            temp.emojiReactions = [EmoteReaction(emote: emote, uid: message.sender.senderId)]
        }
        
        self.messages[index] = temp
        do{
            try viewModel?.modifyMessage(temp)
        }catch{
            showMessage(withTitle: "Error", message: "Your reaction failed, check your connection.")
        }
    }
}

protocol ChatReactDelegate: NSObject{
    func replyTo(_ message: Message)
    
    func emoteReaction(for message: Message, _ emote: String)
    
    func openEmoteSelector(_ message: Message, _ popUpProp: ChatPopupVC.ChatPopupProperties)
}

public class ChatKeyboardUpdater{
    
    @Published var frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: .makeHeight(95))
    
    @Published var willChangeFrame: Bool = false
    
    
    init(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide(notification:)),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidChangeFrame(notification:)),
                                               name: UIResponder.keyboardDidChangeFrameNotification,
                                               object: nil)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    @objc func keyboardWillShow(notification: Notification){
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        self.frame = keyboardFrame
    }
    
    @objc func keyboardDidShow(notification: Notification){
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        self.frame = keyboardFrame
    }
    
    @objc func keyboardWillHide(notification: Notification){
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        self.frame = keyboardFrame
    }
    
    @objc func keyboardDidHide(notification: Notification){
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        self.frame = keyboardFrame
    }
    
    @objc func keyboardWillChangeFrame(notification: Notification){
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        self.frame = keyboardFrame
        self.willChangeFrame = true
    }
    
    @objc func keyboardDidChangeFrame(notification: Notification){
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        self.frame = keyboardFrame
        self.willChangeFrame = false
    }
}
