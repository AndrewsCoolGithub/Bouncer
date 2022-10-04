//
//  AccountCreationEntry.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/9/22.
//

import Foundation
import NVActivityIndicatorView
import UIKit

/*
 Screen for entering account data
 */
class AccountSignUpEntry: UIViewController{
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your phone number"
        label.font = .poppinsMedium(size: .makeWidth(25))
        label.textColor = .white
        return label
    }()
    
    fileprivate let plusSignLabel: UILabel = {
        let label = UILabel()
        label.text = "+1"
        label.font = .poppinsRegular(size: .makeWidth(22))
        label.textColor = .white
        return label
    }()
    
    fileprivate let indicator: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: .layoutRect(width: 414, height: 896, rectCenter: .center), type: .ballPulseSync, color: .white, padding: 150)
        view.backgroundColor = .black.withAlphaComponent(0.2)
        return view
    }()
   
    
    fileprivate let textField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .blueMinty()
        textField.font = .poppinsRegular(size: .makeWidth(22))
        textField.placeholder = "Mobile Number"
        textField.keyboardType = .numberPad
        textField.textContentType = .telephoneNumber
        return textField
    }()
    
    fileprivate lazy var pastelButton: PastelButton = {
        let pastelButton = PastelButton(frame: .layoutRect(width: 170, height: 60, rectCenter: .center, keepAspect: true), cornerRadius: .makeWidth(170) * 27/170, upperView: self.view, selector: #selector(nextButtonTapped))
        pastelButton.setTitle("Next", for: .normal)
        pastelButton.background.backgroundColor = .greyColor()
        return pastelButton
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pastelButton.pastelView.startAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        view.backgroundColor = .greyColor()
        
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: .makeHeight(70))
        
        view.addSubview(plusSignLabel)
        plusSignLabel.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, paddingTop: .makeHeight(40), paddingLeft: 0)
        
        view.addSubview(textField)
        textField.anchor(top: titleLabel.bottomAnchor, left: plusSignLabel.rightAnchor, paddingTop: .makeHeight(40), paddingLeft: .makeWidth(10))
        textField.delegate = self
        textField.becomeFirstResponder()
       
        view.addSubview(pastelButton)
    }
    
    @objc func nextButtonTapped(){
        guard let text = textField.text else {return}
        if text.count != 14{
            textField.shake()
        }else{
           sendNumber(text)
        }
    }
    
    fileprivate func sendNumber(_ input: String){
        Task{
            do{
                view.addSubview(indicator)
                indicator.startAnimating()
                try await AccountInfo.process(input: input, .sendNumber)
                indicator.stopAnimating()
                indicator.removeFromSuperview()
                navigationController?.pushViewController(AccountVerify(number: input), animated: true)
            }catch{
                showMessage(withTitle: "Error", message: error.localizedDescription)
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
    
    fileprivate func updateButtonFill(){
        guard let text = textField.text else {
            return
        }
        
        if text.count == 14{
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

extension AccountSignUpEntry: UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.updateButtonFill()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {return true}
        
        if string.count == 14{
            print("Auto Entry")
            sendNumber(string)
        }
        
        if text == "" && string.count == 1{
            textField.text = "("
        }
        
        if text.first == "(" && range.lowerBound == 1{
            textField.text = ""
            return false
        }
        
        if range.lowerBound == 3{
            textField.text = text + string + ") "
            return false
        }
        
        if range.lowerBound == 5{
            textField.text = String(text.dropLast(3))
            return false
        }
        
        if range.lowerBound == 8{
            textField.text = text + string + "-"
            return false
        }
        
        if range.lowerBound == 9{
            textField.text = String(text.dropLast(2))
            return false
        }
        
        if range.lowerBound == 14{
            textField.shake()
            return false
        }
        
        return true
    }
}
