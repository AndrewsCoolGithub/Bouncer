//
//  AccountFirstName.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/7/22.
//

import Foundation
import NVActivityIndicatorView
import UIKit

class AccountFirstName: UIViewController{

    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your first name"
        label.font = .poppinsMedium(size: .makeWidth(25))
        label.textColor = .white
        return label
    }()

    fileprivate let textField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .blueMinty()
        textField.font = .poppinsRegular(size: .makeWidth(22))
        textField.placeholder = "My Name"
        textField.keyboardType = .alphabet
        textField.textContentType = .name
        return textField
    }()

    fileprivate lazy var pastelButton: PastelButton = {
        let pastelButton = PastelButton(frame: .layoutRect(width: 170, height: 60, rectCenter: .center, keepAspect: true), cornerRadius: .makeWidth(170) * 27/170, upperView: self.view, selector: #selector(nextButtonTapped))
        pastelButton.setTitle("Next", for: .normal)
        pastelButton.background.backgroundColor = .greyColor()
        return pastelButton
    }()
    
    fileprivate let indicator: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: .layoutRect(width: 414, height: 896, rectCenter: .center), type: .ballPulseSync, color: .white, padding: 150)
        view.backgroundColor = .black.withAlphaComponent(0.2)
        return view
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pastelButton.pastelView.startAnimation()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        indicator.stopAnimating()
        indicator.removeFromSuperview()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        view.backgroundColor = .greyColor()
        
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: .makeHeight(70))
        
        view.addSubview(textField)
        textField.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, paddingTop: .makeHeight(40), paddingLeft: .makeWidth(10))
        textField.delegate = self
        textField.becomeFirstResponder()
       
        view.addSubview(pastelButton)
        
    }

    @objc func nextButtonTapped(){
        guard let text = textField.text else {return}
        if text.count < 3{
            textField.shake()
        }else{
            continueWith(text)
        }
    }

    fileprivate func continueWith(_ input: String){
       
        Task{
            do{
                view.addSubview(indicator)
                indicator.startAnimating()
                try await AccountInfo.process(input: input, .uploadFirstName)
                AccountInfo.storeValue(input, DefaultsKeys.displayName)
            }catch{
                indicator.stopAnimating()
                indicator.removeFromSuperview()
                print(error.localizedDescription)
            }
        }
    }

    fileprivate func updateButtonFill(){
        guard let text = textField.text else {
            return
        }
        
        if text.count >= 3{
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

extension AccountFirstName: UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.updateButtonFill()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count > 0{
            let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ")
            let letterRange = string.rangeOfCharacter(from: set)
            let onlyLetters = (letterRange != nil)
            
            if range.lowerBound == 40{
                textField.shake()
                return false
            }
            
            return onlyLetters
        }
        return true
    }
}
