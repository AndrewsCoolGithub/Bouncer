//
//  FirestoreShortcuts.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/12/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

fileprivate let profileCache = Cache<String, Profile>()
extension Array where Element == String {
    
    func getUsers() async -> [Profile] {
        var profiles = [Profile]()
        
        for id in self{
            if let profile = profileCache[id]{
                profiles.append(profile)
            }else{
                guard let profile = try? await USERS_COLLECTION.document(id).getDocument(as: Profile.self) else {continue}
                profileCache[id] = profile
                profiles.append(profile)
            }
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

extension String {
    func getUser() async -> Profile?{
        try? await USERS_COLLECTION.document(self).getDocument(as: Profile.self)
    }
}

