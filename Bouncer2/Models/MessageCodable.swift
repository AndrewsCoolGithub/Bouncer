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
    let emojiReactions: [EmoteReaction]?
    
    func toMessage() -> Message{
        return Message(senderID: senderID, displayName: displayName, messageId: messageID, sentDate: sentDate, emojiReactions: emojiReactions, dataType: DataType(rawValue: dataType)!, text: text)
    }
}
