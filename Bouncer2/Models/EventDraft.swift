//
//  EventDraft.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/16/22.
//

import Foundation
import Firebase
import UIImageColors

struct EventDraft: Hashable, Codable, Equatable, Identifiable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: EventDraft, rhs: EventDraft) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String = "42069"
    let title: String?
    let description: String?
    let location: GeoPoint?
    let startsAt: Date?
    let duration: Double?
    let type: EventType?
    let colors: [ColorModel]
    
    init(title: String?, description: String?, location: GeoPoint?, startsAt: Date?, duration: Double?, type: EventType?, colors: [ColorModel]?) {
        self.title = title
        self.description = description
        self.location = location
        self.startsAt = startsAt
        self.duration = duration
        self.type = type
        self.colors = colors!
    }
    
    func uiImageColors() -> UIImageColors{
        return UIImageColors(background: .clear, primary: colors[0].uiColor(), secondary: colors[1].uiColor(), detail: colors[2].uiColor())
    }
}
