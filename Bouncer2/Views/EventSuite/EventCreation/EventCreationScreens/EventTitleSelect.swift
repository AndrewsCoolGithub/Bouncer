//
//  EventTitleSelect.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/29/22.
//

import Foundation
import FloatingPanel
import UIKit
import Combine
import UIImageColors

class EventTitleSelect: UIViewController{
    
    private let textView: UITextView = {
        let ratio: CGFloat = 170/343
      
        let textView = UITextView(frame: CGRect(x: (.makeWidth(414) - .makeWidth(343))/2, y: .makeHeight(50), width: .makeWidth(343), height: .makeWidth(343) * ratio), cornerRadius: .makeWidth(20), colors: EventCreationVC.colors, lineWidth: 1, direction: .horizontal)
        textView.backgroundColor = .greyColor()
        textView.layer.applySketchShadow(color: .black.withAlphaComponent(0.3), alpha: 1, x: 0, y: 6, blur: 9, spread: 7, withRounding: .makeWidth(20))
        textView.textColor = .white
        textView.tintColor = EventCreationVC.colors.detail
        textView.font = .poppinsMedium(size: .makeWidth(22))
        textView.alpha = 1
        textView.autocapitalizationType = .words
        textView.textContainerInset = UIEdgeInsets(top: .makeHeight(15), left: .makeWidth(15), bottom: .makeHeight(15), right: .makeWidth(15))
        return textView
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "0/35"
        label.font = .poppinsMedium(size: .makeWidth(15))
        label.textColor = .nearlyWhite()
        return label
    }()
   
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        textView.gradientColors = (EventCreationVC.shared.viewModel.colors, true)
        textView.tintColor = EventCreationVC.shared.viewModel.colors?.detail
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
       
        view.addSubview(textView)
        textView.delegate = self
        textView.gestureRecognizers?.forEach({$0.require(toFail: EventCreationVC.shared.panel.panGestureRecognizer)})
        view.addSubview(progressLabel)
        progressLabel.anchor(bottom: textView.bottomAnchor, right: textView.rightAnchor, paddingBottom: .makeHeight(10), paddingRight: .makeWidth(15))
        
        if let eventTitle = EventCreationVC.shared.viewModel.eventTitle{
            self.textView.text = eventTitle
            progressLabel.text = "\(eventTitle.count)/35"
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if EventCreationValidator.checkProp(.eventTitle){
            EventCreationVC.shared.navigator.activateButton()
        }else{
            EventCreationVC.shared.navigator.deactivateButton()
        }
    }
    
    func updateCharacterCount(_ int: Int){
        progressLabel.text = "\(int)/35"
        EventCreationVC.shared.viewModel.eventTitle = textView.text
        
        if EventCreationValidator.checkProp(.eventTitle){
            EventCreationVC.shared.navigator.activateButton()
        }else{
            EventCreationVC.shared.navigator.deactivateButton()
        }
    }
}

extension EventTitleSelect: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        updateCharacterCount(textView.text.count)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        print("range: \(range.length)")
        print("text: \(text.count)")
        let charCount = textView.text.count + (text.count - range.length)
       
        if charCount > 35{
            HapticsManager.shared.vibrate(for: .warning)
        }
        
        return charCount <= 35
    }
}
extension EventTitleSelect: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UITextView {
            // we touched a button, slider, or other UIControl
            return false // ignore the touch
        }
        return true // handle the touch
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            
            let hitView = self.view.hitTest(firstTouch.location(in: self.view), with: event)

            if hitView === self.textView {
                textView.becomeFirstResponder()
            } else {
                textView.resignFirstResponder()
            }
        }
    }
}
