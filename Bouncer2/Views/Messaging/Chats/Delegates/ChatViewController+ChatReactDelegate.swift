//
//  ChatViewController+ChatReactDelegate.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/24/23.
//

import Foundation
extension ChatViewController: ChatReactDelegate{
    
    func openEmoteSelector(_ message: Message, _ popUpProp: ChatPopupVC.ChatPopupProperties) {
        let emoteSelector = ChatEmoteSelector(viewModel: viewModel)
        emoteSelector.chatEmoteSelectorCC = ChatEmoteSelectorCC()
        emoteSelector.popupProp = popUpProp
        emoteSelector.chatEmoteSelectorCC.delegate = self
        emoteSelector.chatEmoteSelectorCC.message = message
        emoteSelector.addPanel(toParent: self, animated: true)
        
    }
    
    func replyTo(_ message: Message) {
        self.setupReplyHeader(message.sender.displayName, message)
    }
    
    func emoteReaction(for message: Message, _ emote: String) {
        guard let index = messages.firstIndex(where: {$0.messageId == message.messageId}) else {return}
        var temp = message
        if temp.emojiReactions != nil{
            if let existingIndex = message.emojiReactions!.firstIndex(where: {$0.uid == message.sender.senderId}){
                if temp.emojiReactions![existingIndex].emote == emote{
                    temp.emojiReactions!.remove(at: existingIndex)
                    if temp.emojiReactions!.isEmpty{
                        temp.emojiReactions = nil
                    }
                }else{
                    temp.emojiReactions![existingIndex] = EmoteReaction(emote: emote, uid: message.sender.senderId)
                }
            }else{
                temp.emojiReactions!.append(EmoteReaction(emote: emote, uid: message.sender.senderId))
            }
        }else{
            temp.emojiReactions = [EmoteReaction(emote: emote, uid: message.sender.senderId)]
        }
        
        self.messages[index] = temp
        do{
            try viewModel?.modifyMessage(temp)
        }catch{
            showMessage(withTitle: "Error", message: "Your reaction failed, check your connection.")
        }
    }
}

protocol ChatReactDelegate: NSObject{
    func replyTo(_ message: Message)
    
    func emoteReaction(for message: Message, _ emote: String)
    
    func openEmoteSelector(_ message: Message, _ popUpProp: ChatPopupVC.ChatPopupProperties)
}
