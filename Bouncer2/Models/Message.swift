//
//  Message.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 8/22/22.
//

import Foundation
import MessageKit
import Firebase

struct Message: Hashable, MessageType{
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.messageId == rhs.messageId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    var kind: MessageKind
    
    let sender: SenderType
    
    let messageId: String
    
    let sentDate: Date
    
    let readReceipts: [ReadReceipt]?
    
    let isDelivered: Bool
    
    var emojiReactions: [EmoteReaction]?
    
    let replyReceipt: ReplyReceipt?
    
    let dataType: DataType
    
    let mediaURL: String?
    private let text: String?
    private let duration: Float?
    
    init(senderID: String, displayName: String, messageId: String, sentDate: Date, readReceipts: [ReadReceipt]? = nil, emojiReactions: [EmoteReaction]?, replyReceipt: ReplyReceipt?, dataType: DataType, text: String? = nil, mediaURL: String? = nil, duration: Float? = nil, image: UIImage? = nil, placeholderImage: UIImage? = nil, isDelivered: Bool = true) {
        self.sender = Sender(senderId: senderID, displayName: displayName)
        self.messageId = messageId
        self.sentDate = sentDate
        self.isDelivered = isDelivered
        self.kind = Message.getData(dataType, text: text, mediaURL: mediaURL, duration: duration, image: nil, placeholderImage: placeholderImage)
        self.readReceipts = readReceipts
        self.emojiReactions = emojiReactions
        self.replyReceipt = replyReceipt
        self.dataType = dataType
        
        
        //PRIVATE FOR CONVERSION
        self.text = text
        self.mediaURL = mediaURL
        self.duration = duration
        
    }
    
    func toCodable() -> MessageCodable{
        return MessageCodable(id: nil, senderID: sender.senderId, messageID: messageId, displayName: sender.displayName, sentDate: sentDate, readReceipts: readReceipts, dataType: dataType.rawValue, text: text, mediaURL: mediaURL, duration: duration, replyReceipt: replyReceipt, emojiReactions: emojiReactions)
    }
    
    private static func getData(_ dataType: DataType, text: String? = nil, mediaURL: String? = nil, duration: Float? = nil, image: UIImage? = nil, placeholderImage: UIImage? = nil) -> MessageKind{
        
        switch dataType {
        case .text:
            return .text(text ?? "")
        case .audio:
            return .audio(Audio(url: URL(string: mediaURL!)!, duration: duration ?? 0.0))
            //TODO: Add a placeholder Image
        case .image:
            let imageview = UIImageView()
            imageview.image = UIImage()
            imageview.sd_setImage(with: URL(string: mediaURL!)!)
            return .photo(Media(url: URL(string: mediaURL!)!, image: imageview.image ?? UIImage(), placeholderImage: placeholderImage ?? UIImage(), size: CGSize(width: 300, height: 500)))
        case .video:
            return .video(Media(url: URL(string: mediaURL!)!, image: nil, placeholderImage: placeholderImage ?? UIImage(), size: CGSize(width: 300, height: 500)))
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
    let uid: String
    let emote: String
    
    init(emote: String, uid: String){
        self.emote = emote
        self.uid = uid
    }
}

struct ReplyReceipt: Codable {
    
    let messageID: String
    let userID: String
    let displayName: String
    let senderDisplayName: String
    let dataType: String
    let text: String?
    let mediaURL: String?
    let duration: Float?
}
