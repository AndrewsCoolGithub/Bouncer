//
//  FirestoreShortcuts.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/12/22.
//

import Foundation

extension Array where Element == String {
    
    func getUsers() async -> [Profile] {
        var profiles = [Profile]()
        for id in self{
            guard let profile = try? await USERS_COLLECTION.document(id).getDocument(as: Profile.self) else {continue}
            profiles.append(profile)
        }
        return profiles
    }
}
