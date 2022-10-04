//
//  Message.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 8/22/22.
//

import Foundation
import MessageKit

struct Message: Hashable, MessageType{
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.messageId == rhs.messageId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    let sender: SenderType
    
    let messageId: String
    
    let sentDate: Date
    
    var kind: MessageKind
    
    let readReceipts: [ReadReceipt]?
    
    let isDelivered: Bool
    
    var emojiReactions: [EmoteReaction]?
    
    let dataType: DataType
    private let mediaURL: String?
    private let text: String?
    private let duration: Float?
    
    init(senderID: String, displayName: String, messageId: String, sentDate: Date, readReceipts: [ReadReceipt]? = nil, emojiReactions: [EmoteReaction]?, dataType: DataType, text: String? = nil, mediaURL: String? = nil, duration: Float? = nil, image: UIImage? = nil, placeholderImage: UIImage? = nil, isDelivered: Bool = true) {
        self.sender = Sender(senderId: senderID, displayName: displayName)
        self.messageId = messageId
        self.sentDate = sentDate
        self.isDelivered = isDelivered
        self.kind = Message.getData(dataType, text: text, mediaURL: mediaURL, duration: duration, image: image, placeholderImage: placeholderImage)
        self.readReceipts = readReceipts
        self.emojiReactions = emojiReactions
        
        //PRIVATE FOR CONVERSION
        self.dataType = dataType
        self.text = text
        self.mediaURL = mediaURL
        self.duration = duration
        
    }
    
    func toCodable() -> MessageCodable{
        return MessageCodable(id: messageId, senderID: sender.senderId, messageID: messageId, displayName: sender.displayName, sentDate: sentDate, readReceipts: readReceipts, dataType: dataType.rawValue, text: text, mediaURL: mediaURL, duration: duration, emojiReactions: emojiReactions)
    }
    
    private static func getData(_ dataType: DataType, text: String? = nil, mediaURL: String? = nil, duration: Float? = nil, image: UIImage? = nil, placeholderImage: UIImage? = nil) -> MessageKind{
        
        switch dataType {
        case .text:
            return .text(text ?? "")
        case .audio:
            return .audio(Audio(url: URL(string: mediaURL!)!, duration: duration ?? 0.0))
            //TODO: Add a placeholder Image
        case .image:
            return .photo(Media(url: URL(string: mediaURL!)!, image: image!, placeholderImage: placeholderImage!, size: CGSize(width: 300, height: 500)))
        case .video:
            return .video(Media(url: URL(string: mediaURL!)!, image: nil, placeholderImage: placeholderImage!, size: CGSize(width: 300, height: 500)))
        }
    
    }
    
    fileprivate struct Audio: AudioItem{
        var url: URL
        
        var duration: Float
        
        var size: CGSize
        
        init(url: URL, duration: Float, size: CGSize = CGSize(width: 200, height: 90)) {
            self.url = url
            self.duration = duration
            self.size = size
        }
    }
    
    fileprivate struct Media: MediaItem{
        var url: URL?
        
        var image: UIImage?
        
        var placeholderImage: UIImage
        
        var size: CGSize
    
        init(url: URL? = nil, image: UIImage? = nil, placeholderImage: UIImage, size: CGSize) {
            self.url = url
            self.image = image
            self.placeholderImage = placeholderImage
            self.size = size
        }
    }
}

enum DataType: String, Codable{
    case text = "text"
    case audio = "audio"
    case image = "image"
    case video = "video"
}

public struct Sender: SenderType {
    public let senderId: String
    public let displayName: String
}

struct ReadReceipt: Codable{
    
    let uid: String
    let timeRead: Date
    
    init(uid: String, timeRead: Date) {
        self.uid = uid
        self.timeRead = timeRead
    }
}

struct EmoteReaction: Codable, Hashable {
    let emote: String
    let uid: String
    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(uid)
//    }
//
//    static func == (lhs: EmoteReaction, rhs: EmoteReaction) -> Bool {
//        return lhs.uid == rhs.uid
//    }
    
    
    init(emote: String, uid: String){
        self.emote = emote
        self.uid = uid
    }
}

