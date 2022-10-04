//
//  Event.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/23/22.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct Event: Hashable, Codable, Equatable, Identifiable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Event, rhs: Event) -> Bool {
//        return lhs.id == rhs.id && lhs.guestIds?.count ?? 0 == rhs.guestIds?.count ?? 0
        return lhs.id == rhs.id
    }
    
    @DocumentID var id: String? = UUID().uuidString
    let imageURL: String!
    let title: String
    let description: String
    let location: GeoPoint
    let locationName: String
    let startsAt: Date
    let endsAt: Date
    let type: EventType
    let colors: [ColorModel]
    let hostId: String
    
    
    let rsvpIds: [String]?
    let waitlistIds: [String]?
    let invitedIds: [String]?
    let guestIds: [String]?
    
    
    init(imageURL: String? = nil, title: String, description: String, location: GeoPoint, locationName: String, startsAt: Date, endsAt: Date, type: EventType, colors: [ColorModel], hostId: String, rsvpIds: [String]? = nil, waitlistIds: [String]? = nil, invitedIds: [String]? = nil, guestIds: [String]? = nil) {
        self.imageURL = imageURL
        self.title = title
        self.description = description
        self.location = location
        self.locationName = locationName
        self.startsAt = startsAt
        self.endsAt = endsAt
        self.type = type
        self.colors = colors
        self.hostId = hostId
        self.rsvpIds = rsvpIds
        self.waitlistIds = waitlistIds
        self.invitedIds = invitedIds
        self.guestIds = guestIds
    }
}




enum EventType: String, Codable{
    case exclusive
    case open
}
