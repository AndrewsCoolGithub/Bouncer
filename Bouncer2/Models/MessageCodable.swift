//
//  MessageCodable.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 9/1/22.
//

import Foundation
import FirebaseFirestoreSwift

struct MessageCodable: Codable, Identifiable, Hashable{
    static func == (lhs: MessageCodable, rhs: MessageCodable) -> Bool {
        lhs.messageID == rhs.messageID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageID)
    }
    
    @DocumentID var id: String? = UUID().uuidString //MessageID
    let senderID: String
    let messageID: String
    let displayName: String
    let sentDate: Date
    let readReceipts: [ReadReceipt]?
    let dataType: String
    let text: String?
    let mediaURL: String?
    let duration: Float?
    let replyReceipt: ReplyReceipt? 
    let emojiReactions: [EmoteReaction]?
    
    func toMessage() -> Message {
        return Message(senderID: senderID, displayName: displayName, messageId: messageID, sentDate: sentDate, emojiReactions: emojiReactions, replyReceipt: replyReceipt, dataType: DataType(rawValue: dataType)!, text: text, mediaURL: mediaURL)
        
    }
    
    func addURL(_ url: String) -> MessageCodable {
        return MessageCodable(senderID: senderID, messageID: messageID, displayName: displayName, sentDate: .now, readReceipts: readReceipts, dataType: dataType, text: text, mediaURL: url, duration: duration, replyReceipt: replyReceipt, emojiReactions: emojiReactions)
    }
}
enum FetchError: Error{
    case badID
    case badImage
}

