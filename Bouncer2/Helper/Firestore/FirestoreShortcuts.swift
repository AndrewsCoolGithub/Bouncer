//
//  FirestoreShortcuts.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/12/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

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

extension Array where Element == QueryDocumentSnapshot{
    
    func data<T: Decodable>(as: T.Type) throws -> [T]{
        return self.compactMap { doc -> T? in
            return try? doc.data(as: T.self)
        }
    }
}

