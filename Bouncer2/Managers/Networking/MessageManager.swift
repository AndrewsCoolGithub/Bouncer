//
//  MessageManager.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 8/22/22.
//

import Foundation
import Firebase
import FirebaseStorage

let CHAT_COLLECTION = Firestore.firestore().collection("Chats")
final class MessageManager{
    
    static let shared = MessageManager()
    private init(){}
    
    public func send(_ detail: MessageDetail, message: MessageCodable, image: UIImage? = nil) throws{
        guard let id = detail.id else { return }
        
        guard let dataType = DataType(rawValue: message.dataType) else {return}
        switch  dataType{
        case .text:
            let newDetail = MessageDetail(id: id, users: detail.users, chatName: detail.chatName, lastMessage: message, lastActive: .now)
            try CHAT_COLLECTION.document(id).setData(from: newDetail)
            try CHAT_COLLECTION.document(id).collection("Messages").document(message.messageID).setData(from: message)
        case .audio:
            break
        case .image:
            Task{
                let path = Storage.storage().reference().child("Messages").child(message.messageID)
                let url = try await MediaManager.uploadImage(image, path: path)
                let newMessage = MessageCodable(senderID: message.senderID, messageID: message.messageID, displayName: message.displayName, sentDate: .now, readReceipts: nil, dataType: message.dataType, text: message.text, mediaURL: url, duration: message.duration, replyReceipt: message.replyReceipt, emojiReactions: message.emojiReactions)
                let newDetail = MessageDetail(id: id, users: detail.users, chatName: detail.chatName, lastMessage: newMessage, lastActive: .now)
                try CHAT_COLLECTION.document(id).setData(from: newDetail)
                try CHAT_COLLECTION.document(id).collection("Messages").document(message.messageID).setData(from: newMessage)
            }
        case .video:
            break
        }
        
        
    }
    
    
    
    
    
    /*/ newMostRecentMessage param exists when message to be removed is the most recent. Is messages last index  - 1 */
    public func remove(_ detail: MessageDetail, message: MessageCodable, newMostRecentMessage: MessageCodable? = nil) async throws{
        guard let id = detail.id else { return }
        if let newMostRecentMessage = newMostRecentMessage{
            var detail = detail
            detail.lastMessage = newMostRecentMessage
            try CHAT_COLLECTION.document(id).setData(from: detail)
        }
        try await CHAT_COLLECTION.document(id).collection("Messages").document(message.messageID).delete()
        let path = Storage.storage().reference().child("Messages").child(message.messageID)
        try await path.delete()
    }
    
    public func fetchChats() async throws -> [MessageDetail]{
        let chats = try await CHAT_COLLECTION.getDocuments().documents
        return chats.compactMap { doc -> MessageDetail? in
            return try? doc.data(as: MessageDetail.self)
        }
    }
    
    public func createNewChat(_ users: [Profile]) throws -> MessageDetail{

        var users = users
        if users.count > 1{
            users.append(User.shared.profile)
        }
        
        let names = users.map { $0.display_name }.joined(separator: ", ")
        if users.count == 1{
            users.append(User.shared.profile)
        }
        
        let ref = Firestore.firestore().collection("Chats").document()
        let messageDetail = MessageDetail(id: ref.documentID, users: users.map({$0.id!}), chatName: names, lastMessage: nil, lastActive: .now)
        try ref.setData(from: messageDetail, merge: false)
        return messageDetail
    }
   
    
    
    
    
    private func createMedia() -> String{
        return "amediaurl"
    }
    
//    public func fetchMessageDetail
    
//     public func getMessageDetails() async throws -> [MessageDetail]{
//        let uid = User.shared.id!
//        USERS_COLLECTION.document(uid).collection("Messages")
//        
//         let messageDetail = MessageDetail(users: ["id"],
//              lastActivity: Message(sender: Sender(senderId: "myID", displayName: "Chad", imageURL: "https://firebasestorage.googleapis.com:443/v0/b/bouncer-f8461.appspot.com/o/ProfileImages%2FPug89a9g2WYyf7NZ9y6sKJm6ATu2%2F769C8F94-F604-49EA-9111-EFD394A68201?alt=media&token=524a0ad1-508b-434f-9d23-97c0d84c9dbb"), messageId: "BEA44648-1880-4AA8-ACCD-E374A62643A6", sentDate: .now.addingTimeInterval(-3601), kind: .text("This is a really dope message!")))
//        
//        return [messageDetail]
//    }
}
