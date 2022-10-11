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
    
    @Published var userData = [String : Profile]()
    
    let messageDetail: MessageDetail
    
    
    init(_ messageDetail: MessageDetail, users: [String]){
        self.messageDetail = messageDetail
        Task{
            try await grabUserData(users)
            FirestoreSubscription.subscribeToCollection(id: messageDetail.id!, collection: .Messages).sink { [weak self] snapshot in
                self?.messages = snapshot.documents.compactMap { (doc) -> Message? in
                    return try? doc.data(as: MessageCodable.self).toMessage()
                }
            }.store(in: &cancellable)
        }
    }
    
    func modifyMessage(_ message: Message) throws{
        let codable = message.toCodable()
        try CHAT_COLLECTION.document(messageDetail.id!).collection("Messages").document(message.messageId).setData(from: codable)
    }
    
    func grabUserData(_ users: [String]) async throws{
        for userID in users{
            let data = try await USERS_COLLECTION.document(userID).getDocument().data(as: Profile.self)
            userData[userID] = data
        }
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
            return
        case .video:
            return
        }
    }
}
