//
//  ProfileViewModel.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/11/22.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import Combine


class ProfileViewModel: ObservableObject{
    
   
    var cancellable = Set<AnyCancellable>()
    
    @Published var backDropImageURL: String?
    @Published var actualBackDropImage: UIImage? {
        didSet{
            print("Set backdrop image")
        }
    }
    @Published var profileImageURL: String?
    @Published var actualProfileImage: UIImage?
    @Published var colors: [ColorModel]!
    @Published var userName: String?
    @Published var displayName: String?
    @Published var bio: String?
    @Published var following: [String] = []
    @Published var followers: [String] = []
    var id: String?
    
    
   
    init(_ profile: Profile? = nil){
        if let profile = profile{
            self.id = profile.id
            FirestoreSubscription.subscribe(id: profile.id!, collection: .Users).sink { [weak self] doc in
                guard let data = try? doc.data(as: Profile.self) else {return}
                guard let self = self else {return}
                self.backDropImageURL = data.backdrop_url
                self.profileImageURL = data.image_url
                self.userName = data.user_name
                self.displayName = data.display_name
                self.bio = data.bio
                self.following = data.following ?? []
                self.followers = data.followers ?? []
                self.colors = data.colors ?? User.defaultColors.colorModel
//                self.backDropImageURL = data[ProfileFields.backDropURL.rawValue] as? String
//                self.profileImageURL = data[ProfileFields.imageURL.rawValue] as? String
//                self.userName = data[ProfileFields.username.rawValue] as? String
//                self.displayName = data[ProfileFields.name.rawValue] as? String
//                self.bio = data[ProfileFields.bio.rawValue] as? String
//                self.following = data[ProfileFields.following.rawValue] as? [String] ?? []
//                self.followers = data[ProfileFields.followers.rawValue] as? [String] ?? []
//                self.colors = data[ProfileFields.colors.rawValue] as? [ColorModel] ?? User.defaultColors.colorModel
                
            }.store(in: &cancellable)
        }else{
            self.id = User.shared.id!
            User.shared.$backdropImageURL.sink { [weak self] backdrop in
                guard let self = self else {return}
                self.backDropImageURL = backdrop
            }.store(in: &cancellable)
            User.shared.$imageURL.sink { [weak self] imageURL in
                guard let self = self else {return}
                self.profileImageURL = imageURL
            }.store(in: &cancellable)
            User.shared.$userName.sink { [weak self] userName in
                guard let self = self else {return}
                self.userName = userName
            }.store(in: &cancellable)
            User.shared.$displayName.sink { [weak self] displayName in
                guard let self = self else {return}
                self.displayName = displayName
            }.store(in: &cancellable)
            User.shared.$bio.sink { [weak self] bio in
                guard let self = self else {return}
                self.bio = bio
            }.store(in: &cancellable)
            User.shared.$following.sink { [weak self] following in
                guard let self = self else {return}
                self.following = following
            }.store(in: &cancellable)
            User.shared.$followers.sink { [weak self] followers in
                guard let self = self else {return}
                self.followers = followers
            }.store(in: &cancellable)
            User.shared.$colors.sink { [weak self] colors in
                guard let self = self else {return}
                self.colors = colors ?? User.defaultColors.colorModel
            }.store(in: &cancellable)
        }
    }
    
    
    func toggleFollow() {
        guard let uid = User.shared.id, let thisUID = id, uid != thisUID else {return}
        if followers.contains(uid){
            Task{
                do{
                    followers.removeAll(where: {$0 == uid})
                    try await ProfileManager.shared.followOperation(with: thisUID, action: .unfollow)
                }catch{
                    followers.append(uid)
                }
            }
        }else{
            Task{
                do{
                    followers.append(uid)
                    try await ProfileManager.shared.followOperation(with: thisUID, action: .follow)
                }catch{
                    followers.removeAll(where: {$0 == uid})
                }
            }
        }
    }
    
    func signOut() throws{
        try Auth.auth().signOut()
    }
}
