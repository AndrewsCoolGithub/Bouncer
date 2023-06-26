//
//  ChatViewModel.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 8/29/22.
//

import Foundation
import Combine
import Firebase

class ChatViewModel: ObservableObject{
    
    var cancellable = Set<AnyCancellable>()
    
    @Published var messages: [Message]?
    
//    @Published var userData = [String : Profile]()
   
    var profiles: [Profile] = []
    var styleColors: [UIColor] = []
    let messageDetail: MessageDetail
    
 
    init(_ messageDetail: MessageDetail, profiles: [Profile]){
        self.messageDetail = messageDetail
        self.profiles = profiles
        self.styleColors = profiles.first(where: {$0.id != User.shared.profile.id})?.colors?.uiColors() ?? User.defaultColors.colors
        Task{
            FirestoreSubscription.subscribeToCollection(id: messageDetail.id!, collection: .Messages).sink { [weak self] snapshot in
                self?.messages = snapshot.documents.compactMap { (doc) -> Message? in
                    return try? doc.data(as: MessageCodable.self).toMessage()
                }
            }.store(in: &cancellable)
        }
    }
    
    func remove(_ message: Message){
        Task{
            guard let messages = messages else {return}
            if messages.last == message && messages.count <= 1{
                try await MessageManager.shared.remove(messageDetail, message: message.toCodable(), newMostRecentMessage: nil)
                DispatchQueue.main.async {
                    self.messages?.removeAll(where: {$0 == message})
                }
            }else if messages.last == message && messages.count > 1{
                try await MessageManager.shared.remove(messageDetail, message: message.toCodable(), newMostRecentMessage: messages[messages.count-2].toCodable())
                DispatchQueue.main.async {
                    self.messages?.removeAll(where: {$0 == message})
                }
            }else{
                try await MessageManager.shared.remove(messageDetail, message: message.toCodable())
                DispatchQueue.main.async {
                    self.messages?.removeAll(where: {$0 == message})
                }
            }
        }
    }
        
    
    
    func modifyMessage(_ message: Message) throws{
        let codable = message.toCodable()
        try CHAT_COLLECTION.document(messageDetail.id!).collection("Messages").document(message.messageId).setData(from: codable)
    }
    
    func sendMessage(_ dataType: DataType, content: Any, replyReceipt: ReplyReceipt?){
        let doc = CHAT_COLLECTION.document(messageDetail.id!).collection("Messages").document()
        let messageID = doc.documentID
        let displayName = User.shared.displayName!
        let senderID = User.shared.id!
        let typeOfData = dataType
        
        switch dataType {
        case .text:
            let text = content as! String
            let message = Message(senderID: senderID, displayName: displayName, messageId: messageID, sentDate: .now, emojiReactions: nil, replyReceipt: replyReceipt, dataType: typeOfData, text: text, isDelivered: false)
            let index = messages?.count ?? 0
            messages?.insert(message, at: index)
            
            do{
                try MessageManager.shared.send(self.messageDetail, message: message.toCodable())
            }catch{
                messages?.remove(at: index)
            }
        case .audio:
            return
        case .image:
            let image = content as! UIImage
            let message = MessageCodable(senderID: senderID, messageID: messageID, displayName: displayName, sentDate: .now, readReceipts: nil, dataType: "image", text: nil, mediaURL: nil, duration: 0, replyReceipt: nil, emojiReactions: nil)
            do{
                try MessageManager.shared.send(self.messageDetail, message: message, image: image)
                
            }catch{
                
            }
            
            return
        case .video:
            return
        }
    }
}
