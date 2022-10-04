//
//  ChatEmoteSelectorPanel.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 9/25/22.
//

import Foundation
import FloatingPanel
import Firebase

final class ChatEmoteSelector: FloatingPanelController{
    
    var chatEmoteSelectorCC: ChatEmoteSelectorCC!
    
    var popupProp: ChatPopupVC.ChatPopupProperties!
    
     let blurEffectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .regular)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.frame = CGRect(x: 0, y: 0, width: .makeWidth(414), height: .makeHeight(896))
        return effectView
    }()
    
    lazy var customizeHeaderView: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: 0, y: SafeArea.topSafeArea()), size: CGSize(width: .makeWidth(414), height: .makeHeight(80))))
        view.layer.applySketchShadow(color: .nearlyBlack().withAlphaComponent(0.3), alpha: 1, x: 0, y: 0, blur: 16, spread: 4, withRounding: 0)
        
        let resetButton = UIButton()
        resetButton.setTitle("Reset", for: .normal)
        resetButton.titleLabel?.font = .poppinsRegular(size: .makeWidth(16))
        resetButton.addTarget(self, action: #selector(resetCustom), for: .touchUpInside)
        
        let customReactionsLabel = UILabel()
        customReactionsLabel.text = "Customize Reactions"
        customReactionsLabel.font = .poppinsMedium(size: .makeWidth(18))
        
        let doneButton = UIButton()
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = .poppinsMedium(size: .makeWidth(16))
        doneButton.addTarget(self, action: #selector(doneCustom), for: .touchUpInside)
        
        view.addSubview(resetButton)
        resetButton.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft: .makeWidth(20))
        view.addSubview(customReactionsLabel)
        customReactionsLabel.center(inView: view)
        view.addSubview(doneButton)
        doneButton.centerYright(inView: view, rightAnchor: view.rightAnchor, paddingRight: .makeWidth(20))
        
        view.backgroundColor = .clear
        return view
    }()
    
    let searchCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ProfileSearchCell.self, forCellWithReuseIdentifier: ProfileSearchCell.id)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .purple
        return collectionView
    }()
   
    var currentSelectedIndex = 5
    
    var didFinishEntryAnimation = false
    
    init(viewModel: ChatViewModel?){
        super.init(delegate: nil)
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = .makeWidth(25)
        appearance.backgroundColor = .greyColor()
        
       
        layout = PanelLayout()
        surfaceView.appearance = appearance
        set(contentViewController: chatEmoteSelectorCC)
        chatEmoteSelectorCC.customizeEmojiDelegate = self
    }
    
    let backgroundEmojiView:  UIView = {
        let view = UIView()
        view.backgroundColor = .nearlyBlack()
        view.layer.cornerRadius = ChatPopupVC.ViewDimensions.reactionH / 2
        view.layer.masksToBounds = true
        view.frame = CGRect(x:  0, y: .makeHeight(450), width: ChatPopupVC.ViewDimensions.reactionW, height: ChatPopupVC.ViewDimensions.reactionH)
        return view
    }()
    var emojiCustomStack: UIStackView!
    
    
    var buttonData = [Emoji]()
    func createCustomView(_ emojis: [Emoji]){
        
        var buttons = [UIButton]()
        for i in 0..<emojis.count{
            let button = UIButton()
            let emojiImage = emojis[i].emote.emojiStringToImage(CGSize(width: .makeWidth(40), height: .makeWidth(414) * 51/414))
            button.setImage(emojiImage, for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(selectedEmoji(_:)), for: .touchUpInside)
            buttons.append(button)
            buttonData.append(emojis[i])
            
            if i == currentSelectedIndex{
                button.alpha = 1
            }else{
                button.alpha = 0.55
            }
        }
        
        let plusButton = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(30))
        plusButton.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        plusButton.tintColor = .white
        plusButton.alpha = 0
        emojiCustomStack = UIStackView(arrangedSubviews: buttons)
        emojiCustomStack.distribution = .fillProportionally
        emojiCustomStack.axis = .horizontal
        emojiCustomStack.spacing = .makeWidth(10)
       
        
        backgroundEmojiView.addSubview(emojiCustomStack)
        emojiCustomStack.centerY(inView: backgroundEmojiView, leftAnchor: backgroundEmojiView.leftAnchor, paddingLeft: .makeWidth(20.5))
        backgroundEmojiView.insertSubview(plusButton, at: 0)
        plusButton.centerYright(inView: backgroundEmojiView, rightAnchor: backgroundEmojiView.rightAnchor, paddingRight: .makeWidth(19.5))
        plusButton.isUserInteractionEnabled = false
        
    }
    
    
    @objc func selectedEmoji(_ sender: UIButton){
        let tag = sender.tag
        emojiCustomStack.arrangedSubviews[currentSelectedIndex].alpha = 0.55
        sender.alpha = 1
        currentSelectedIndex = tag
        
        
        print(tag)
    }
    
    
    @objc func resetCustom(){
        guard let contentVC = contentViewController as? ChatEmoteSelectorCC else {return}
        contentVC.myReactions = User.defaultEmojis
    }
    
    @objc func doneCustom(){
       //TODO: Animate to popup view origin
        guard let contentVC = contentViewController as? ChatEmoteSelectorCC else {return}
        
        
    }
    
    class PanelLayout: FloatingPanelLayout {
        var position: FloatingPanelPosition = .bottom
        var initialState: FloatingPanelState = .half
        var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
            return [.full: FloatingPanelLayoutAnchor(absoluteInset: 10, edge: .top, referenceGuide: .safeArea), .half: FloatingPanelLayoutAnchor(absoluteInset: .makeHeight(260), edge: .top, referenceGuide: .superview)]
        }
        func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
            switch state {
            case .full, .half: return 0.3
            default: return 0.15
            }
        }
    }
    
    class PanelLayoutForCustomize: FloatingPanelLayout {
        var position: FloatingPanelPosition = .bottom
        var initialState: FloatingPanelState = .full
        var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
            return [.full: FloatingPanelLayoutAnchor(absoluteInset: 10, edge: .top, referenceGuide: .safeArea), .half: FloatingPanelLayoutAnchor(absoluteInset: .makeHeight(380), edge: .top, referenceGuide: .superview)]
        }
        
        func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
            
           return 0
            
        }
    }
}


extension ChatEmoteSelector: FloatingPanelControllerDelegate{
    fileprivate func transitionCustomEmojiView(_ loc: CGPoint, _ startY: CGFloat) {
        let percentProgressToBottom = (loc.y - startY) / (.makeHeight(896) - startY)
        let emojiViewStartY: CGFloat = .makeHeight(200)
        let emojiViewEndY: CGFloat = popupProp.touchPoint.y - (ChatPopupVC.ViewDimensions.reactionH * 1.25)
        let transitionalY = ((emojiViewEndY - emojiViewStartY) * percentProgressToBottom) + emojiViewStartY
        
        if popupProp.touchPoint.y < emojiViewStartY {
            backgroundEmojiView.frame.origin.y = min(transitionalY, emojiViewStartY)
        }else{
            backgroundEmojiView.frame.origin.y = max(transitionalY, emojiViewStartY)
        }
        
        let emojiViewStartWidth: CGFloat = .makeWidth(331)
        let emojiViewEndWidth: CGFloat = ChatPopupVC.ViewDimensions.reactionW
        let transitionalW = ((emojiViewEndWidth - emojiViewStartWidth) * percentProgressToBottom) + emojiViewStartWidth
        backgroundEmojiView.frame.size.width = max(transitionalW, emojiViewStartWidth)
        
        let emojiViewStartX: CGFloat = .makeWidth(41.5)
        let emojiViewEndX: CGFloat = ChatPopupVC.ViewDimensions.reactionX
        
        let transitionalX = ((emojiViewEndX - emojiViewStartX ) * percentProgressToBottom ) + emojiViewStartX
        backgroundEmojiView.frame.origin.x = min(transitionalX, emojiViewStartX)
        
        if !backgroundEmojiView.subviews.isEmpty{
            let plusButton = backgroundEmojiView.subviews[0]
            plusButton.alpha = percentProgressToBottom
        }
    }
    
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        
        let loc = vc.surfaceLocation
        let startY = vc.surfaceLocation(for: .half).y ///283.3724500482181
        let diff = max(startY - loc.y, 0)
        let startHeight: CGFloat = .makeHeight(530)
        let maxHeight: CGFloat = -(SafeArea.topSafeArea() + 10) + .makeHeight(790)
        
        if didFinishEntryAnimation{
            transitionCustomEmojiView(loc, startY)
        }
        
        
        guard let contentVC = (vc.contentViewController as? ChatEmoteSelectorCC) else {return}
        let velocity = vc.panGestureRecognizer.velocity(in: view).y
        contentVC.searchCollectionView.frame.size.height = (min(startHeight + diff, maxHeight))
        
        if contentVC.inCustomMode{
            let startY: CGFloat = .makeHeight(516)
            let progressiveAlpha = 1 - min(1, ((loc.y - .makeHeight(380)) / startY))
            blurEffectView.alpha = progressiveAlpha
            customizeHeaderView.alpha = progressiveAlpha
            if (loc.y >= .makeHeight(680) && velocity > 700) {
                removePanel(vc, contentVC)
            }
        }else{
            if (loc.y >= .makeHeight(550) && velocity > 500){
                removePanel(vc, contentVC)
            }
        }
    }
    
    func floatingPanelWillBeginAttracting(_ fpc: FloatingPanelController, to state: FloatingPanelState) {
        guard let contentVC = (fpc.contentViewController as? ChatEmoteSelectorCC), state == .half  else {return}
        contentVC.searchBar.searchTextField.endEditing(true)
    }
    
    func floatingPanelWillRemove(_ fpc: FloatingPanelController) {
        
        if (fpc.contentViewController as! ChatEmoteSelectorCC).inCustomMode{
            let chatVC = fpc.parent as! ChatViewController
            let chatPopup = ChatPopupVC(popupProp.message,
                                        popupProp.touchPoint,
                                        cellFrame: popupProp.cellFrame,
                                        delegate: chatVC,
                                        keyboardUpdater: chatVC.keyboardUpdater,
                                        fromCustom: true)
            
            //chatVC.hideMessageInputBar(origin: chatVC.messageInputBarOrgin)
            
            chatVC.addChild(chatPopup)
            chatPopup.willMove(toParent: chatVC)
            chatVC.view.addSubview(chatPopup.view)
        }
    }
    
    fileprivate func removePanel(_ fpc: FloatingPanelController, _ contentVC: ChatEmoteSelectorCC) {
        fpc.removePanelFromParent(animated: true) {
            contentVC.delegate = nil
            contentVC.customizeEmojiDelegate = nil
            if !contentVC.inCustomMode{
                NotificationCenter.default.post(name: Notification.Name("showMessageInputBar"), object: nil)
            }
        }
    }
}

protocol CustomizeEmojiDelegate: NSObject{
    func openCustomizeView()
    func replaceEmoji(with emoji: Emoji, _ cvPosition: Int)
}



extension ChatEmoteSelector: CustomizeEmojiDelegate{
    func replaceEmoji(with emoji: Emoji, _ cvPosition: Int) {
        print("Replace emoji at postion: \(currentSelectedIndex), with \(emoji.emote) ")
        
        guard let contentVC = contentViewController as? ChatEmoteSelectorCC, !contentVC.myReactions.contains(emoji) else {return}
        move(to: .half, animated: true)
        let lastEmoji = buttonData[currentSelectedIndex]
        contentVC.myReactions[currentSelectedIndex] = emoji
        removeEmojiFromDataSource(emoji, lastEmoji, cvPosition, contentVC)
        
        let button = UIButton()
        let emojiImage = emoji.emote.emojiStringToImage(CGSize(width: .makeWidth(40), height: .makeWidth(414) * 51/414))
        button.setImage(emojiImage, for: .normal)
        button.tag = currentSelectedIndex
        button.addTarget(self, action: #selector(selectedEmoji(_:)), for: .touchUpInside)
        buttonData.insert(emoji, at: currentSelectedIndex)
        
        emojiCustomStack.arrangedSubviews[currentSelectedIndex].removeFromSuperview()
        emojiCustomStack.insertArrangedSubview(button, at: currentSelectedIndex)
        
        
        
        Task{
            try await AuthManager.shared.updateEmojis(contentVC.myReactions)
        }
    }
    
    private func removeEmojiFromDataSource(_ emoji: Emoji, _ lastEmoji: Emoji, _ cvPositon: Int, _ contentVC: ChatEmoteSelectorCC){
        //var snapshot = NSDiffableDataSourceSnapshot<ChatEmoteSelectorCC.Section, Emoji>()
        
        
        if contentVC.inSearchMode{
            guard let searchText = contentVC.searchBar.searchTextField.text else {
                fatalError("inSearchMode with no searchText?")
            }
            var snapshot = contentVC.dataSource?.snapshot()
            if lastEmoji.name.range(of: searchText, options: .caseInsensitive) != nil{
                snapshot?.insertItems([lastEmoji], afterItem: emoji)
                snapshot?.deleteItems([emoji])
            }else{
                snapshot?.deleteItems([emoji])
            }
            contentVC.allEmojis = EmojiGallery.shared.emojis.filter({!contentVC.myReactions.contains($0) && $0 != emoji})
            contentVC.dataSource?.apply(snapshot!, animatingDifferences: true)
        }else{
            var snapshot = NSDiffableDataSourceSnapshot<ChatEmoteSelectorCC.Section, Emoji>()
            snapshot.appendSections([.all])
            contentVC.allEmojis = EmojiGallery.shared.emojis.filter({!contentVC.myReactions.contains($0) && $0 != emoji})
            snapshot.appendItems(contentVC.allEmojis, toSection: .all)
            contentVC.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func openCustomizeView() {
        guard let contentVC = (contentViewController as? ChatEmoteSelectorCC) else {fatalError("ContentVC is nil")}
        view.insertSubview(blurEffectView, at: 0)
        view.insertSubview(customizeHeaderView, at: 1)
        createCustomView(contentVC.myReactions)
        view.insertSubview(backgroundEmojiView, at: 2)
        
        
        contentVC.inCustomMode = true
        var snapshot = NSDiffableDataSourceSnapshot<ChatEmoteSelectorCC.Section, Emoji>()
        contentVC.allEmojis = EmojiGallery.shared.emojis.filter({!contentVC.myReactions.contains($0)})
        snapshot.appendSections([.all])
        snapshot.appendItems(contentVC.allEmojis, toSection: .all)
        contentVC.dataSource?.apply(snapshot, animatingDifferences: true)
        contentVC.searchCollectionView.reloadData()
        layout = PanelLayoutForCustomize()
        invalidateLayout()
        
        delegate = self
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1) {
            self.backgroundEmojiView.frame = CGRect(x: ChatPopupVC.ViewDimensions.reactionXCustom, y: .makeHeight(200), width: ChatPopupVC.ViewDimensions.reactionWCustom, height: ChatPopupVC.ViewDimensions.reactionH)
        }completion: { _ in
            self.didFinishEntryAnimation = true
        }
    }
}
