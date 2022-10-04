//
//  ProfileTextEdit.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/15/22.
//

import Foundation
import NVActivityIndicatorView
import UIKit

class ProfileTextEdit: UIViewController{
    
    enum ProfileText: String{
        case bio
        case name
        case username
    }
    
    fileprivate let components = ProfileTextEditComponents()
    var textType: ProfileText!
    unowned var viewModel: ProfileViewModel!
    
    
    init(_ textType: ProfileText, viewModel: ProfileViewModel){
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .greyColor()
        
        self.viewModel = viewModel
        self.textType = textType
        
        setupTopBar(textType)
        
        switch textType{
            
        case .bio:
            //add textview
            let textView = components.textView
            view.addSubview(textView)
            textView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: .makeHeight(75))
            textView.delegate = self
            textView.text = viewModel.bio

        case .name:
            let textField = components.textField
            view.addSubview(textField)
            textField.delegate = self
            textField.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: .makeHeight(75))
            textField.textContentType = .givenName
            textField.text = viewModel.displayName

        case .username:
            let textField = components.textField
            textField.delegate = self
            view.addSubview(textField)
            textField.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: .makeHeight(75))
            textField.textContentType = .nickname
            textField.text = viewModel.userName
        }
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let textType = textType else {return}
        switch textType{
        case .bio:
            components.textView.becomeFirstResponder()
        default:
            components.textField.becomeFirstResponder()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateDoneButton(text: String){
        guard let textType = textType else {return}
        switch textType{
        case .bio:
            components.doneButton.setTitleColor(.white, for: .normal)
            components.doneButton.isUserInteractionEnabled = true
        case .name:
            let text = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if text.count >= 2 && !(text.filter({$0 == " "}).count >= 2){
                components.doneButton.setTitleColor(.white, for: .normal)
                components.doneButton.isUserInteractionEnabled = true
            }else{
                components.doneButton.setTitleColor(.lightText, for: .normal)
                components.doneButton.isUserInteractionEnabled = false
            }
        case .username:
            if text.count >= 3{
                components.doneButton.setTitleColor(.white, for: .normal)
                components.doneButton.isUserInteractionEnabled = true
            }else{
                components.doneButton.setTitleColor(.lightText, for: .normal)
                components.doneButton.isUserInteractionEnabled = false
            }
        }
    }
    
    @objc func finishNUpdate(){
        let text = textType == .bio ? components.textView.text : components.textField.text
        var field: ProfileFields{
            switch textType!{
            case .name:
                return .name
            case .bio:
                return .bio
            case .username:
                return .username
            }
        }
        
        Task{
            components.indicator.startAnimating()
            view.addSubview(components.indicator)
            try await AuthManager.shared.uploadUserData(text, field: field)
            switch field {
            case .name:
                viewModel.displayName = text
            case .username:
                viewModel.userName = text
            case .bio:
                viewModel.bio = text
            default:
                return
            }
            components.indicator.stopAnimating()
            components.indicator.removeFromSuperview()
            navigationController?.popViewController(animated: true)
        }
    }
    
    fileprivate func setupTopBar(_ textType: ProfileTextEdit.ProfileText) {
        let chevron = components.chevron
        view.addSubview(chevron)
        chevron.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: .makeHeight(13.5))
        chevron.anchor(left: view.leftAnchor, paddingLeft: .makeWidth(15))
        chevron.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        let headerLabel = components.headerLabel
        view.addSubview(headerLabel)
        headerLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: .makeHeight(10))
        headerLabel.text = textType.rawValue.capitalized
        
        let doneButton = components.doneButton
        view.addSubview(doneButton)
        doneButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: .makeHeight(8.5))
        doneButton.anchor(right: view.rightAnchor, paddingRight: .makeWidth(15))
        doneButton.addTarget(self, action: #selector(finishNUpdate), for: .touchUpInside)
    }
}

extension ProfileTextEdit: UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else {return}
        self.updateDoneButton(text: text)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {return true}
        if string.count > 0{
        
            let nameCharacterSet = text.contains(where: {$0 == " "}) ? CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ") : CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
            
            let set = textType == .name ? nameCharacterSet : CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ._1234567890")
            let letterRange = string.rangeOfCharacter(from: set)
            let onlyLetters = (letterRange != nil)
            let maxCharCount = self.textType == .username ? 20 : 40
            
            
            
            if range.lowerBound == maxCharCount{
                textField.shake()
                return false
            }
            
            return onlyLetters
        }
        return true
    }
}

extension ProfileTextEdit: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else {return}
        self.updateDoneButton(text: text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let bool = textView.text.count + text.count <= 200
        if !bool{
            textView.shake()
        }
        return bool
    }
}

private struct ProfileTextEditComponents{
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(24))
        label.textColor = .white
        label.textAlignment = .center
        label.setWidth(.makeWidth(200))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        return label
    }()
    
    let indicator: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: .layoutRect(width: 414, height: 896, rectCenter: .center), type: .ballPulseSync, color: .white, padding: 150)
        view.backgroundColor = .black.withAlphaComponent(0.2)
        return view
    }()
    
    let chevron: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: .makeHeight(30))
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .center
        return button
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .poppinsMedium(size: .makeWidth(20))
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.textColor = .white
        textField.tintColor = .systemBlue
        textField.clearButtonMode = .whileEditing
        textField.setWidth(.makeWidth(380))
        textField.backgroundColor = .greyColor()
        textField.font = .poppinsMedium(size: .makeWidth(21))
        return textField
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.setDimensions(height: .makeWidth(380) * 150/380, width: .makeWidth(380))
        textView.textColor = .white
        textView.tintColor = .systemBlue
        textView.textAlignment = .left
        textView.backgroundColor = .greyColor()
        textView.font = .poppinsRegular(size: .makeWidth(15))
        return textView
    }()
}
