//
//  ChatPopupView.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 9/8/22.
//

import Foundation
import UIKit
import MessageKit
import Combine

class ChatPopupVC: UIViewController{
    
    public struct ViewDimensions{
        static var bottomOptionH: CGFloat = .makeHeight(95)
        static var reactionH: CGFloat = .makeHeight(90)
        static var reactionW: CGFloat = .makeWidth(375)
        static var reactionWCustom: CGFloat = .makeWidth(331)
        static var reactionX: CGFloat = .makeWidth(17)
        static var reactionXCustom: CGFloat = .makeWidth(41.5)
    }
    
     let myView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = ViewDimensions.reactionH/2
        view.layer.masksToBounds = true
        view.backgroundColor = .nearlyBlack()
        return view
    }()
    
    private let bottomOptions: UIView = {
        let view = UIView()
        view.backgroundColor = .nearlyBlack()
        return view
    }()
    
    var emoteStackView: UIStackView!
    
//    private let emoteStackView: UIStackView = {
//
//        return stackView
//    }()
    
    var touchPoint: CGPoint!
    var cellFrame: CGRect!
    var isCurrentUser: Bool!
    var isText: Bool!
    var message: Message!
    var delegate: ChatReactDelegate!
    var keyboardUpdater: ChatKeyboardUpdater!
    var barActions: MessageBarDelegate!
    var cancellable = Set<AnyCancellable>()
    var fromCustom: Bool!
    
    struct ChatPopupProperties{
        let touchPoint: CGPoint
        let cellFrame: CGRect!
        let isCurrentUser: Bool!
        let isText: Bool!
        let message: Message!
        unowned let barActions: MessageBarDelegate!
        unowned let delegate: ChatReactDelegate!
        unowned let keyboardUpdater: ChatKeyboardUpdater!
    }
    
    var chatPopupProp: ChatPopupProperties!
    
    init(_ message: Message, _ touchPoint: CGPoint, cellFrame: CGRect, delegate: ChatReactDelegate, keyboardUpdater: ChatKeyboardUpdater, barActions: MessageBarDelegate, fromCustom: Bool = false){
        super.init(nibName: nil, bundle: nil)
        self.message = message
        self.delegate = delegate
        self.isCurrentUser = message.sender.senderId == User.shared.id
        self.isText = message.dataType == .text
        self.keyboardUpdater = keyboardUpdater
        self.cellFrame = cellFrame
        self.touchPoint = touchPoint
        self.fromCustom = fromCustom
        self.barActions = barActions
        
        chatPopupProp = ChatPopupProperties(touchPoint: touchPoint, cellFrame: cellFrame, isCurrentUser: self.isCurrentUser, isText: self.isText, message: message, barActions: barActions, delegate: delegate, keyboardUpdater: keyboardUpdater)
        

            myView.frame = CGRect(origin: CGPoint(x: touchPoint.x, y: touchPoint.y), size: .zero)
            bottomOptions.frame = CGRect(x: 0, y: .makeHeight(900), width: .makeWidth(414), height: ViewDimensions.bottomOptionH)
            setupBottomOptionsUI(determineOptions(isCurrentUser, isText))

        
    }
    
  

    
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let overlayView = OverlayView()
        overlayView.frame = view.frame
        overlayView.framesToCutOut = [self.cellFrame]
        self.view = overlayView
        
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve) {
            self.view.backgroundColor = .nearlyBlack().withAlphaComponent(0.1)
        }
        
        view.addSubview(myView)
        setupEmoteReactUI()
        view.addSubview(bottomOptions)
        if !fromCustom{
            UIView.animate(withDuration: 0.3, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.9) {
                self.myView.frame = CGRect(origin: CGPoint(x: ViewDimensions.reactionX, y: self.touchPoint.y - (ViewDimensions.reactionH * 1.25)), size: CGSize(width: ViewDimensions.reactionW, height: ViewDimensions.reactionH))
                
            }
        }else{
            self.myView.frame = CGRect(origin: CGPoint(x: ViewDimensions.reactionX, y: self.touchPoint.y - (ViewDimensions.reactionH * 1.25)), size: CGSize(width: ViewDimensions.reactionW, height: ViewDimensions.reactionH))
        }
        
        
        keyboardUpdater.$frame.sink(receiveValue: { [weak self] rect in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.9) {
                let keyBoardOrNatty = max(rect.height, ViewDimensions.bottomOptionH)
                self?.bottomOptions.frame.origin.y = .makeHeight(896)  - keyBoardOrNatty
            }
        }).store(in: &cancellable)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tapGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        view.addGestureRecognizer(panGesture)
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.3, options: .overrideInheritedOptions) { [weak self] in
            guard let touchPoint = self?.touchPoint else {return}
            self?.myView.frame = CGRect(origin: CGPoint(x: touchPoint.x, y: touchPoint.y), size: .zero)
            self?.bottomOptions.frame.origin.y = .makeHeight(900)
        }
        
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve) {
            self.view.backgroundColor = .clear
        }
        
        UIView.transition(with: self.myView, duration: 0.3, options: .transitionCrossDissolve) {
            self.myView.backgroundColor = .clear
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            self.cancellable.forEach({$0.cancel()})
            self.view.removeFromSuperview()
            self.willMove(toParent: nil)
            self.removeFromParent()
        }
    }
    
    
    /*
     Button Options:
     1. If the message is text from curent user possible options include: Reply, Delete*, Copy
     2. If the message is text from another user options include: Reply, Report*, Copy
     3. If the message is an event link or profile link from current user options include: Reply, Delete
     4. If the message is an event link or profile link from another user options include: Reply
     */
    fileprivate enum MessageOptions: Int{
        case reply = 0
        case delete = 1
        case report = 2
        case copy = 3
    }
    
    fileprivate func setupBottomOptionsUI(_ options: [MessageOptions]){
        let buttons: [UIButton] = {
            var buttons = [UIButton]()
            let optCount = options.count
            options.forEach { int in
                let button = UIButton()
                switch int{
                case .reply:
                    button.setTitle("Reply", for: .normal)
                case .delete:
                    button.setTitle("Delete", for: .normal)
                case .report:
                    button.setTitle("Report", for: .normal)
                case .copy:
                    button.setTitle("Copy", for: .normal)
                }
                button.setDimensions(height: ViewDimensions.bottomOptionH * 0.75, width: .makeWidth(414) / CGFloat(optCount))
                button.setTitleColor(.white, for: .normal)
                button.setTitleColor(.nearlyWhite(), for: .highlighted)
                button.setTitleColor(.nearlyWhite(), for: .selected)
                
                button.titleLabel?.font = .poppinsMedium(size: .makeWidth(17))
                button.tag = int.rawValue
                
                button.titleLabel?.textAlignment = .center
                button.addTarget(self, action: #selector(optionTriggered), for: .touchUpInside)
                buttons.append(button)
                
            }
            return buttons
        }()
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.distribution = .fillProportionally
        stackView.alignment = .top
        stackView.axis = .horizontal
        stackView.frame = bottomOptions.bounds
        bottomOptions.addSubview(stackView)
    }
    
    var emojis = [Emoji]() //Used to refrence emote with button action via button tag
    fileprivate func setupEmoteReactUI(){
        User.shared.$emojis.sink { [weak self] emojis in
            self?.emojis = emojis ?? User.defaultEmojis
            
            var buttons = [UIButton]()
            guard let emojiCharacters = self?.emojis.map({$0.emote}) else {return}
            for emoteString in emojiCharacters{
                let button = UIButton()
                let emojiImage = emoteString.emojiStringToImage(CGSize(width: .makeWidth(40), height: .makeWidth(414) * 51/414))
                button.setImage(emojiImage, for: .normal)
                button.tag = buttons.count
                button.addTarget(self, action: #selector(self?.tappedEmote), for: .touchUpInside)
                buttons.append(button)
            }
            
            let plusButton = UIButton()
            let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(30))
            plusButton.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
            plusButton.tintColor = .white
            plusButton.addTarget(self, action: #selector(self?.openAllEmotes), for: .touchUpInside)
            buttons.append(plusButton)
            
            self?.emoteStackView = UIStackView(arrangedSubviews: buttons)
            self?.emoteStackView.distribution = .fillProportionally
            self?.emoteStackView.axis = .horizontal
            self?.emoteStackView.spacing = .makeWidth(10)
            
            self?.myView.addSubview(self!.emoteStackView)
            self?.emoteStackView.center(inView: self?.myView)
             
            
            
        }.store(in: &cancellable)
    }
    
    @objc func tappedEmote(_ sender: UIButton){
        let emote = emojis[sender.tag].emote
        delegate.emoteReaction(for: message, emote)
        barActions.showBar()
        animateOut()
    }
    
    @objc func openAllEmotes(){
        animateOut()
        delegate.openEmoteSelector(self.message, chatPopupProp)
    }
    
    fileprivate func determineOptions(_ isCurrentUser: Bool, _ isText: Bool) -> [MessageOptions]{
        var options: [MessageOptions] = [.reply]
        if isCurrentUser && isText{
            options.append(contentsOf: [.delete, .copy])
        }else if isText{
            options.append(contentsOf: [.report, .copy])
        }else if !isText && isCurrentUser{
            options.append(contentsOf: [.delete])
        }
        return options
    }
    
    @objc fileprivate func optionTriggered(_ sender: UIButton){
        guard let option = MessageOptions(rawValue: sender.tag) else {return}
        switch option {
        case .reply:
            barActions.showBar()
            animateOut()
            delegate.replyTo(self.message)
        case .delete:
            print("Delete")
        case .report:
            print("Report")
        case .copy:
            print("Copy")
        }
    }
    
    @objc fileprivate func didPan(_ sender: UIPanGestureRecognizer){
        guard sender.state == .changed else {return}
        let location = sender.location(in: view)
        guard location.y < view.frame.size.height - ViewDimensions.bottomOptionH else {
            print("Is in options view?")
            return
        }
        
        if !(myView == view.hitTest(location, with: nil) || bottomOptions == view.hitTest(location, with: nil) || bottomOptions.subviews[0] == view.hitTest(location, with: nil)){
            barActions.showBar()
            animateOut()
            
        }
    }
    
    @objc fileprivate func didTap(_ sender: UITapGestureRecognizer){
        guard sender.state == .ended else {return}
        let location = sender.location(in: view)
        guard location.y < view.frame.size.height - ViewDimensions.bottomOptionH else {return }
        if !(myView == view.hitTest(location, with: nil) || bottomOptions == view.hitTest(location, with: nil) || bottomOptions.subviews[0] == view.hitTest(location, with: nil)){
            barActions.showBar()
            animateOut()
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class OverlayView: UIView {
    let fillColor: UIColor = .init(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.3)
    public var framesToCutOut: [CGRect] = [CGRect]()
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        fillColor.setFill()
        UIRectFill(rect)
        
        if let context: CGContext = UIGraphicsGetCurrentContext() {
            context.setBlendMode(.clear)
            
            for value in framesToCutOut {
                let path: UIBezierPath = UIBezierPath(roundedRect: value, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 12, height: 12))
                path.fill()
            }
            context.setBlendMode(.normal)
        }
    }
}
