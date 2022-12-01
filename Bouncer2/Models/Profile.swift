//
//  ProfileModel.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/23/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Profile: Codable, Identifiable, Equatable, Hashable, Comparable{
    static func < (lhs: Profile, rhs: Profile) -> Bool {
        return lhs.display_name <= rhs.display_name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Profile, rhs: Profile) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func > (lhs: Profile, rhs: Profile) -> Bool {
        return lhs.display_name >= rhs.display_name
    }
    
    @DocumentID var id: String? = UUID().uuidString
    let image_url: String
    let display_name: String
    let user_name: String
    let latitude: Double
    let longitude: Double
    var timeJoined: Date? = .now
    let backdrop_url: String?
    let bio: String?
    let followers: [String]?
    let following: [String]?
    let blocked: [String]?
    let blockedBy: [String]?
    let colors: [ColorModel]?
    let number: String?
    let email: String?
    let emojis: [Emoji]?
    let recentEmojis: [Emoji]?
    
    var isConnection: Bool {
        guard let uid = User.shared.id else {return false}
        return (following ?? []).contains(uid) && (followers ?? []).contains(uid)
    }
    
    
    static let dummy: Profile = {
        Profile(image_url: "", display_name: "", user_name: "", latitude: 90, longitude: 90, backdrop_url: nil, bio: nil, followers: nil, following: nil, blocked: nil, blockedBy: nil, colors: nil, number: nil, email: nil, emojis: nil, recentEmojis: nil)
    }()
}
