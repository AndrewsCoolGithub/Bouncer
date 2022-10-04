//
//  EventDescriptionVC.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/30/22.
//

import Foundation
//
//  EventTitleSelect.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/29/22.
//

import Foundation
import FloatingPanel
import UIKit

class EventDescriptionSelect: UIViewController{
    
    private let textView: UITextView = {
        let ratio: CGFloat = 240/343
        guard let colors = EventCreationVC.colors else {return UITextView()}
        let textView = UITextView(frame: CGRect(x: (.makeWidth(414) - .makeWidth(343))/2, y: .makeHeight(45), width: .makeWidth(343), height: .makeWidth(343) * ratio), cornerRadius: .makeWidth(20), colors: colors, lineWidth: 1, direction: .horizontal)
        textView.backgroundColor = .greyColor()
        textView.layer.applySketchShadow(color: .black.withAlphaComponent(0.3), alpha: 1, x: 0, y: 6, blur: 9, spread: 7, withRounding: .makeWidth(20))
        textView.textColor = .white
        textView.tintColor = colors.detail
        textView.font = .poppinsMedium(size: .makeWidth(13.5))
        textView.alpha = 1
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: .makeHeight(15), left: .makeWidth(15), bottom: .makeHeight(15), right: .makeWidth(15))
        
        return textView
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "0/200"
        label.font = .poppinsMedium(size: .makeWidth(15))
        label.textColor = .nearlyWhite()
        return label
    }()
   
    init(descrip: String? = nil){
        super.init(nibName: nil, bundle: nil)
        if let descrip = descrip {
            self.textView.text = descrip
        }else if let descrip = EventCreationVC.shared.viewModel.descrip{
            self.textView.text = descrip
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        textView.gradientColors = EventCreationVC.shared.viewModel.colors
        textView.tintColor = EventCreationVC.shared.viewModel.colors?.detail
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(textView)
        textView.delegate = self
        
        view.addSubview(progressLabel)
        
        progressLabel.anchor(bottom: textView.bottomAnchor, right: textView.rightAnchor, paddingBottom: .makeHeight(10), paddingRight: .makeWidth(15))
        
        if let descrip = EventCreationVC.shared.viewModel.descrip{
            self.textView.text = descrip
            progressLabel.text = "\(descrip.count)/200"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if EventCreationValidator.checkProp(.eventDescription){
            EventCreationVC.shared.navigator.activateButton()
        }else{
            EventCreationVC.shared.navigator.deactivateButton()
        }
    }
    
    func updateCharacterCount(_ int: Int){
        progressLabel.text = "\(int)/200"
        
        EventCreationVC.shared.viewModel.descrip = textView.text
        
        if EventCreationValidator.checkProp(.eventDescription){
            EventCreationVC.shared.navigator.activateButton()
        }else{
            EventCreationVC.shared.navigator.deactivateButton()
        }
    }
}

extension EventDescriptionSelect: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        updateCharacterCount(textView.text.count)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        let charCount = textView.text.count + (text.count - range.length)
       
        if charCount > 200{
            HapticsManager.shared.vibrate(for: .warning)
        }
        
        return charCount <= 200
    }
}
