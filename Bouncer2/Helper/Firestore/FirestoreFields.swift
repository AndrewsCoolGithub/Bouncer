//
//  FirestoreFields.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/23/22.
//

import Foundation

struct EventFields{
    static let imageURL = "imageURL"
    static let title = "title"
    static let description = "description"
    static let location = "location"
    static let geoHash = "geoHash"
    static let startsAt = "startsAt"
    static let endsAt = "endsAt"
    static let type = "type"
    static let hostId = "hostId"
    static let rsvpIds = "rsvpIds"
    static let waitlistIds = "waitlistIds"
    static let invitedIds = "invitedIds"
    static let guestIds = "guestIds"
}

enum ProfileFields: String, CaseIterable{
    case number = "number"
    case imageURL = "image_url"
    case backDropURL = "backdrop_url"
    case name = "display_name"
    case username = "user_name"
    case latitude = "latitude"
    case longitude = "longitude"
    case joinedAt = "joinedAt"
    case bio = "bio"
    case connections = "connections"
    case eventActivity = "eventActivity"
    case groupActivity = "groupActivity"
    case rsvpActivity = "rsvpActivity"
    case blocked = "blocked"
    case blockedBy = "blockedBy"
    case following = "following"
    case followers = "followers"
    case colors = "colors"
}

enum ChatFields: String{
    case users = "users"
    case lastMessage = "lastMessage"
    case chatName = "chatName"
    case imageURLs = "imageURLs"
    case lastActive = "lastActive"
}

enum MessageFields: String{
    case senderID = "senderID"
    case displayName = "displayName"
    case imageURL = "imageURL"
    case messageID = "messageID"
    case sentDate = "sentDate"
    case readReceipts = "readReceipt"
    case dataType = "dataType"
    case text = "text"
    case mediaURL = "mediaURL"
    case duration = "duration"
}

enum ReadReceiptFields: String{
    case uid = "uid"
    case timeRead = "timeRead"
}
