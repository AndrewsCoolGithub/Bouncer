//
//  ChatKeyboardUpdater.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/24/23.
//
import UIKit

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
