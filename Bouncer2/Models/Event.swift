//
//  Event.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/23/22.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import UIImageColors
import CoreLocation

struct Event: Hashable, Codable, Equatable, Identifiable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
    
    @DocumentID var id: String? = UUID().uuidString
    let imageURL: String!
    let title: String
    let description: String
    let location: GeoPoint
    let geoHash: String
    let locationName: String
    let startsAt: Date
    let endsAt: Date
    let type: EventType
    let colors: [ColorModel]
    let hostId: String
    let hostProfile: Profile
    
    let prospectIds: [String]?
    let invitedIds: [String]?
    let guestIds: [String]?
    
    
    init(id: String? = nil, imageURL: String? = nil, title: String, description: String, location: GeoPoint, geoHash: String, locationName: String, startsAt: Date, endsAt: Date, type: EventType, colors: [ColorModel], hostId: String, hostProfile: Profile, prospectIds: [String]? = nil, invitedIds: [String]? = nil, guestIds: [String]? = nil) {
        if let id = id{
            self.id = id
        }
        self.imageURL = imageURL
        self.title = title
        self.description = description
        self.location = location
        self.geoHash = geoHash
        self.locationName = locationName
        self.startsAt = startsAt
        self.endsAt = endsAt
        self.type = type
        self.colors = colors
        self.hostProfile = hostProfile
        self.hostId = hostId
        self.prospectIds = prospectIds
        self.invitedIds = invitedIds
        self.guestIds = guestIds
    }
    
    func uiImageColors() -> UIImageColors{
        return UIImageColors(background: .clear, primary: colors[0].uiColor(), secondary: colors[1].uiColor(), detail: colors[2].uiColor())
    }
    
    func getLocation() -> CLLocation {
        return CLLocation(latitude: self.location.latitude, longitude: self.location.longitude)
    }
    
    
    
    
   
    

    static let dummy = Event(id: "", imageURL: "", title: "EVENT TITLE", description: "THIS IS A DESCRIPTION", location: GeoPoint(latitude: 90, longitude: 90), geoHash: "GHE2", locationName: "NO WHERE", startsAt: .now, endsAt: .distantFuture, type: .open, colors: [ColorModel(r: 0.5, g: 0.5, b: 1), ColorModel(r: 0.5, g: 0.5, b: 1), ColorModel(r: 0.5, g: 0.5, b: 1)], hostId: "idHost", hostProfile: Profile.dummy, prospectIds: [""], invitedIds: [""], guestIds: ["5Xz4HmjQaKhgIAjwVU3MWMey67s1", "I1SxWEC11gYp51MCzwLaWITmgL73", "KNpZVdYEd3OYJFNjnkaqyLwe6uJ3", "jxAu2um0fgUBtxzKbwCrNGfykGw1", "9ab2sSVBfuUM9BAKkroygrpEocw2", "ywSeDAtCqqf5xy33MFJESV23ah32", "EeKWuRqFoHX1UZm2XLuDUVt7UoI3",  "OAvcj1nYapWwJazcj7uUMSR3btX2", "grmLsRIbDOZGkQUjeSEOcVw0zN33", "FlVtnLVDekR9BBaL6mtZTHUVvNG3", "S4idI8WTqcO6TxWaw3Yd2i85OmG2", "MjeHgFEqCufhN1gBx3an8qHjZti2", "uD2qiznkOSNClKTO4IiTQYwxQBi1", "sKTY3HR9g9QW9bhOw3fEaE90Yrx1", "4hkxQdGpkmNKbQIBD14RNm4CTx02", "Rlhm9W1IYLVCfcBvuk2hfdjUSWg2", "8rk6NtuNa4bnVR6St6nOs51mDK63", "BKl2ZAMEJZQYInids9VsrNRr3lf2", "FNQGbEaQS7YnZzowJCTUbp1i7uN2"])
}




enum EventType: String, Codable{
    case exclusive
    case open
}
