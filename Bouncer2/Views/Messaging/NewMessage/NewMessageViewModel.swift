//
//  NewMessageViewModel.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/25/22.
//

import Combine

final class NewMessageViewModel: ObservableObject{
    
    let suggestUsers: [Profile]
    let existingChats: [MessageDetail]
    @Published var selectedUsers: [ProfileBool]
    @Published var text: String = ""
    
    var cancellable = Set<AnyCancellable>()
    
    init(_ existingChats: [MessageDetail]?, _ suggestedUsers: [Profile]){
        self.existingChats = existingChats ?? []
        self.suggestUsers = suggestedUsers
        self.selectedUsers = []
    }
    
    func searchUsers(_ input: String) async throws -> [Profile]{
        var followingFirst = suggestUsers.filter { data in
            data.user_name.lowercased().starts(with: input.lowercased()) || data.display_name.lowercased().starts(with: input.lowercased())
        }
        
        var set = Set(followingFirst)
        
        let byName = try await USERS_COLLECTION
            .whereField(ProfileFields.name.rawValue, isGreaterThanOrEqualTo: input.capitalized)
            .whereField(ProfileFields.name.rawValue, isLessThanOrEqualTo: input.capitalized + "\u{f8ff}")
            .limit(to: 5)
            .getDocuments()
            .documents
            .data(as: Profile.self)
        
        for i in byName{
            if set.contains(i){
                continue
            }else{
                set.update(with: i)
                followingFirst.append(i)
            }
        }
        
        let byUserName = try await USERS_COLLECTION
            .whereField(ProfileFields.username.rawValue, isGreaterThanOrEqualTo: input.lowercased())
            .whereField(ProfileFields.username.rawValue, isLessThanOrEqualTo: input.lowercased() + "\u{f8ff}")
            .limit(to: 5)
            .getDocuments()
            .documents
            .data(as: Profile.self)
        
        for i in byUserName{
            if set.contains(i){
                continue
            }else{
                set.update(with: i)
                followingFirst.append(i)
            }
        }
        
        return followingFirst
    }
}


struct ProfileBool: Hashable{
    
    let profile: Profile
    var isRed: Bool
    
    init(_ profile: Profile, _ isRed: Bool = false) {
        self.profile = profile
        self.isRed = isRed
    }
}
