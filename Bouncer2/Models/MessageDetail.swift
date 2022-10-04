//
//  MessageDetail.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 8/22/22.
//

import Foundation
import FirebaseFirestoreSwift

struct MessageDetail: Hashable, Codable, Identifiable {
    static func == (lhs: MessageDetail, rhs: MessageDetail) -> Bool { 
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    @DocumentID var id: String? = UUID().uuidString
    let users: [String]
    let chatName: String
    let imageURLs: [String]
    var lastMessage: MessageCodable?
    let lastActive: Date
}
