//
//  AccountVerfiy.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/9/22.
//

import Foundation
import UIKit

import NVActivityIndicatorView

/*
 Screen for verifing account data
 */
class AccountVerify: UIViewController{
    
    fileprivate var number: String!
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter the code sent to \(number!)"
        label.font = .poppinsMedium(size: .makeWidth(25))
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.setWidth(.makeWidth(325))
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        return label
    }()
    
    fileprivate let textField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .blueMinty()
        textField.font = .poppinsRegular(size: .makeWidth(21.5))
        textField.placeholder = "Confirmation Code"
        textField.keyboardType = .numberPad
        textField.textContentType = .oneTimeCode
        return textField
    }()
    
    fileprivate let indicator: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: .layoutRect(width: 414, height: 896, rectCenter: .center), type: .ballPulseSync, color: .white, padding: 150)
        view.backgroundColor = .black.withAlphaComponent(0.2)
        return view
    }()
    
    fileprivate lazy var pastelButton: PastelButton = {
        let pastelButton = PastelButton(frame: .layoutRect(width: 170, height: 60, rectCenter: .center, keepAspect: true), cornerRadius: .makeWidth(170) * 27/170, upperView: self.view, selector: #selector(nextButtonTapped))
        pastelButton.setTitle("Next", for: .normal)
        pastelButton.background.backgroundColor = .greyColor()
        return pastelButton
    }()
    
    
    init(number: String){
        super.init(nibName: nil, bundle: nil)
        self.number = number
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pastelButton.pastelView.startAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(gotData), name: AccountInfo.accountNotificationID, object: AccountInfo.self)
        view.backgroundColor = .greyColor()
        
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: .makeHeight(70))
    
        view.addSubview(textField)
        textField.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, paddingTop: .makeHeight(40))
        textField.delegate = self
        textField.becomeFirstResponder()
       
        view.addSubview(pastelButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        indicator.stopAnimating()
        indicator.removeFromSuperview()
    }
    
    fileprivate func proceed() {
        if let text = textField.text {
            let code = text.components(separatedBy: .decimalDigits.inverted).joined()
            
            Task{
                do{
                    view.addSubview(indicator)
                    indicator.startAnimating()
                    //Triggers a listener, when data arrives 'self.gotData' runs via Notification in AccountInfo
                    try await AccountInfo.process(input: code, .signIn)
                   
                    
                   
                }catch{
                    indicator.stopAnimating()
                    indicator.removeFromSuperview()
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @objc func nextButtonTapped(){
        proceed()
    }
    
    fileprivate func updateButtonFill(){
        guard let text = textField.text else {
            return
        }
       
        if text.count == 13{
            UIView.transition(with: pastelButton.background, duration: 0.7, options: .allowUserInteraction) {
                self.pastelButton.background.alpha = 0.35
            }
        }else{
            UIView.transition(with: pastelButton.background, duration: 0.7, options: .allowUserInteraction) {
                self.pastelButton.background.alpha = 1
            }
        }
    }
    
    @objc func willEnterForeground(){
        pastelButton.pastelView.startAnimation()
    }
}
extension AccountVerify: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.updateButtonFill()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {return true}
        
        if (text + string).count > 13{
            textField.shake()
            return false
        }
        
        
        //Spacing
        if string.count >= 1{
            if range.lowerBound == 12{ //no spacing for last digit
                textField.text = text + string
            }else{
                textField.text = text + string + " "
            }
        }
        
        //Bridge after 3rd digit
        if string.count >= 1, range.lowerBound == 4{
            textField.text = text + string + " - "
        }
        
        //Removing Digits
        if string.count == 0{
            if range.lowerBound == 12{ //- just remove last digit
                textField.text = String(text.dropLast())
            }else if range.lowerBound == 7{ //- remove bridge
                textField.text = String(text.dropLast(4))
            }else{ //- remove spacing
                textField.text = String(text.dropLast(2))
            }
        }
        
        
        return false

    }
}
