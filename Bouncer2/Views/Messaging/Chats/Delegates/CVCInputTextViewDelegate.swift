//
//  ChatViewControllerInputTextView.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/26/23.
//

import InputBarAccessoryView

class ChatViewControllerInputTextViewDelegate: NSObject, UITextViewDelegate{
    
    weak var i: ChatViewController?
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            i?.sendClicked()
            return false
        }
        return true
    }
}
