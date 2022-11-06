//
//  ProfileManager.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/23/22.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import Combine

actor ProfileManager: ObservableObject{
    
    static let shared = ProfileManager()
    private init(){}
    
    //MARK: - Following
    enum FollowingOpertionAction{
        case follow
        case unfollow
    }
    
    func fetchProfiles(_ ids: [String]) async throws -> [Profile]{
        var currentProfiles = [Profile]()
        
        for id in ids {
            var data = try await USERS_COLLECTION.document(id).getDocument(as: Profile.self)
            currentProfiles.append(data)
        }
        
        return currentProfiles
    }
    
    func followOperation(with id: String, action: FollowingOpertionAction) async throws {
        guard let uid = User.shared.id else {fatalError("no UID")}
        switch action{
        case .follow:
            try await USERS_COLLECTION.document(uid).setData([ProfileFields.following.rawValue: FieldValue.arrayUnion([id])], merge: true)
            try await USERS_COLLECTION.document(id).setData([ProfileFields.followers.rawValue : FieldValue.arrayUnion([uid])], merge: true)
        case .unfollow:
            try await USERS_COLLECTION.document(uid).setData([ProfileFields.following.rawValue: FieldValue.arrayRemove([id])], merge: true)
            try await USERS_COLLECTION.document(id).setData([ProfileFields.followers.rawValue : FieldValue.arrayRemove([uid])], merge: true)
        }
    }
    
    //MARK: - Blocking
    enum BlockingOperationAction{
        case block
        case unblock
    }
    
    func blockOperation(with id: String, action: BlockingOperationAction) async throws {
        guard let uid = User.shared.id else { fatalError("no UID")}
        switch action{
        case .block:
            try await USERS_COLLECTION.document(uid).setData([ProfileFields.blocked.rawValue : FieldValue.arrayUnion([id])], merge: true)
            try await USERS_COLLECTION.document(id).setData([ProfileFields.blockedBy.rawValue : FieldValue.arrayUnion([uid])], merge: true)
        case .unblock:
            try await USERS_COLLECTION.document(uid).updateData([ProfileFields.blocked.rawValue : FieldValue.arrayRemove([id])])
            try await USERS_COLLECTION.document(id).setData([ProfileFields.blockedBy.rawValue : FieldValue.arrayRemove([uid])], merge: true)
        }
    }
}
