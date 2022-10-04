//
//  ProfileModel.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/23/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Profile: Codable, Identifiable, Equatable, Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Profile, rhs: Profile) -> Bool {
        return lhs.id == rhs.id
    }
    
    @DocumentID var id: String? = UUID().uuidString
    let image_url: String
    let display_name: String
    let user_name: String
    let latitude: Double
    let longitude: Double
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
}
