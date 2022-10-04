//
//  SearchManager.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/21/22.
//

import Foundation
import Firebase

final class SearchManager{
    
    static let shared = SearchManager()
    
    private init(){}
    
    public var suggested = [Profile]()
    
    fileprivate func finalize(_ nameDocuments: [QueryDocumentSnapshot]?, _ userDocuments: [QueryDocumentSnapshot]?, _ nameQuery: Query?, _ userQuery: Query?) -> ([Profile], SearchManager.LastDocumentGroup) {
        let nameLastDocument = nameDocuments?.count ?? 0 >= 5 ? nameDocuments?.last : nil
        let userLastDocument = userDocuments?.count ?? 0 >= 5 ? userDocuments?.last : nil
        
        let userResult = userDocuments?.compactMap { doc in
            try? doc.data(as: Profile.self)
        } ?? []
        
        
        let nameResult = nameDocuments?.compactMap { doc in
            try? doc.data(as: Profile.self)
        } ?? []
        
        
        return (uniqueSortAlphabet(userResult, nameResult), LastDocumentGroup(nameLastDoc: nameLastDocument, nameQuery: nameQuery, userLastDoc: userLastDocument, userQuery: userQuery))
    }
    
    public func fetchMore(lastDocuments: LastDocumentGroup, filtered: [Profile]) async throws -> ([Profile], LastDocumentGroup){
        var nameDocuments: [QueryDocumentSnapshot]?
        var userDocuments: [QueryDocumentSnapshot]?
        var nameQuery: Query?
        var userQuery: Query?
        let filteredIDs = filtered.map({$0.id!})
        if let uDoc = lastDocuments.userLastDoc, let uQuery = lastDocuments.userQuery, let nDoc = lastDocuments.nameLastDoc,  let nQuery = lastDocuments.nameQuery{
            userQuery = uQuery.start(afterDocument: uDoc)
            nameQuery =  nQuery.start(afterDocument: nDoc)
            userDocuments = try await userQuery!.getDocuments().documents.filter({!filteredIDs.contains($0.documentID)})
            nameDocuments = try await nameQuery!.getDocuments().documents.filter({!filteredIDs.contains($0.documentID)})
            return finalize(nameDocuments, userDocuments, nameQuery, userQuery)
        }else if let uDoc = lastDocuments.userLastDoc, let uQuery = lastDocuments.userQuery{
            userQuery = uQuery.start(afterDocument: uDoc)
            userDocuments = try await userQuery!.getDocuments().documents.filter({!filteredIDs.contains($0.documentID)})
            return finalize(nil, userDocuments, nil, userQuery)
        }else if let nDoc = lastDocuments.nameLastDoc, let nQuery = lastDocuments.nameQuery{
            nameQuery = nQuery.start(afterDocument: nDoc)
            nameDocuments = try await nameQuery!.getDocuments().documents.filter({!filteredIDs.contains($0.documentID)})
            return finalize(nameDocuments, nil, nameQuery, nil)
        }else{
            return ([], LastDocumentGroup(nameLastDoc: nil, nameQuery: nil, userLastDoc: nil, userQuery: nil))
        }
    }
    
    public func fetchUsers(_ param: String, for field: ProfileFields, lastDocument: LastDocumentGroup? = nil) async throws -> ([Profile], LastDocumentGroup){
        
        var nameDocuments: [QueryDocumentSnapshot]?
        var userDocuments: [QueryDocumentSnapshot]?
      
        let nameQuery = USERS_COLLECTION
            .whereField(ProfileFields.name.rawValue, isGreaterThanOrEqualTo: param.capitalized)
            .whereField(ProfileFields.name.rawValue, isLessThanOrEqualTo: param.capitalized + "\u{f8ff}")
        .limit(to: 7)
        
        nameDocuments = try await nameQuery
                        .getDocuments()
                        .documents
            
        let userQuery = USERS_COLLECTION
        .whereField(ProfileFields.username.rawValue, isGreaterThanOrEqualTo: param.lowercased())
        .whereField(ProfileFields.username.rawValue, isLessThanOrEqualTo: param.lowercased() + "\u{f8ff}")
        .limit(to: 7)
        
        userDocuments = try await userQuery
                        .getDocuments()
                        .documents
        
        return finalize(nameDocuments, userDocuments, nameQuery, userQuery)
    }
    
   
    
    public func suggestedUsers(except: [String] = []) async throws -> [Profile]{
        let following = User.shared.following.shuffled().suffix(10)
        
        guard following.count > 0 else {
            let vipslol = [ "OGilTZWBcHbRbcJwZGE6rkjxqsl2"]
            let vips = try await USERS_COLLECTION.whereField("user_id", in: vipslol).getDocuments().documents
            return vips.compactMap { doc in
                try? doc.data(as: Profile.self)
            }
        }
        
        
        
        let suggested = try await USERS_COLLECTION.whereField(ProfileFields.following.rawValue, arrayContainsAny: Array(following)).limit(to: 10).getDocuments().documents
        
        return suggested.compactMap { doc in
            if doc.documentID == User.shared.id! || User.shared.following.contains(doc.documentID) || except.contains(doc.documentID) {
                return nil
            }else{
                return try? doc.data(as: Profile.self)
            }
        }
    }
    
    private func uniqueSortAlphabet(_ arry1: [Profile], _ arry2: [Profile]) -> [Profile]{
        var returnedArray = arry2
        if returnedArray.count > 0{
            arry1.forEach { i in
                if !arry2.contains(i){
                    returnedArray.append(i)
                }
            }
            returnedArray.sort(by: {$0.user_name < $1.user_name})
            return returnedArray
        }else{
            returnedArray = arry1
            returnedArray.sort(by: {$0.user_name < $1.user_name})
            return returnedArray
        }
    }
    
    struct LastDocumentGroup{
        let nameLastDoc: QueryDocumentSnapshot?
        let nameQuery: Query?
        let userLastDoc: QueryDocumentSnapshot?
        let userQuery: Query?
        
        init(nameLastDoc: QueryDocumentSnapshot?, nameQuery: Query?, userLastDoc: QueryDocumentSnapshot?, userQuery: Query?) {
            self.nameLastDoc = nameLastDoc
            self.nameQuery = nameQuery
            self.userLastDoc = userLastDoc
            self.userQuery = userQuery
        }
    }
}
