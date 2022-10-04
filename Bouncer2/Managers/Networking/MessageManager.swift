//
//  MessageManager.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 8/22/22.
//

import Foundation
import Firebase

let CHAT_COLLECTION = USERS_COLLECTION.document(User.shared.id!).collection("Chats")
final class MessageManager{
    
    static let shared = MessageManager()
    private init(){}
    
    public func send(_ detail: MessageDetail, message: MessageCodable) throws{
        guard let id = detail.id else { return }
        let newDetail = MessageDetail(id: detail.id, users: detail.users, chatName: detail.chatName, imageURLs: detail.imageURLs, lastMessage: message, lastActive: .now)
        try CHAT_COLLECTION.document(id).setData(from: newDetail)
        try CHAT_COLLECTION.document(id).collection("Messages").document(message.messageID).setData(from: message)
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
