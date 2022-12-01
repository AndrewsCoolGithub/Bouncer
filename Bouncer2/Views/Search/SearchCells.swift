//
//  SearchCell.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 8/1/22.
//

import Foundation
import UIKit

class ProfileSearchCell: UICollectionViewCell{
    
    var components = SearchCellViews()
    
    static let id = "profile-search-cell"
    
    //var delegate: FollowingCache!
    
    func setupCell(with profile: Profile, followCache: FollowedByCache? = nil){
        contentView.backgroundColor = .greyColor()
        setupImage(profile)
        setupLabels(profile, followCache)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        components.profileImage.removeFromSuperview()
//        components.usernameLabel.removeFromSuperview()
//        components.nameLabel.removeFromSuperview()
//        components.detailLabel.removeFromSuperview()
    }
    
    fileprivate func setupImage(_ profile: Profile) {
        
        
        contentView.addSubview(components.profileImage)
//        imageView.centerY(inView: contentView, leftAnchor: contentView.leftAnchor, paddingLeft: .makeWidth(15))
        components.profileImage.layer.addSublayer(components.skeletonGradient)
        components.profileImage.sd_setImage(with: URL(string: profile.image_url)) { [weak self] i, e, c, u in
            self?.components.skeletonGradient.removeFromSuperlayer()
        }
    }
    
    fileprivate func setupLabels(_ profile: Profile, _ followingCache: FollowedByCache?) {
        let userNameLabel = components.usernameLabel
        userNameLabel.text = profile.user_name.lowercased()
        let displayNameLabel = components.nameLabel
        displayNameLabel.text = profile.display_name.capitalized
        
        if let followingCache = followingCache{
            restoreLabelFromCache(followingCache)
        }else{
            getLabelDetails(profile)
        }
    }
    
    fileprivate func restoreLabelFromCache(_ followingCache: ProfileSearchCell.FollowedByCache) {
        contentView.addSubview(components.usernameLabel)
        contentView.addSubview(components.nameLabel)
        contentView.addSubview(components.detailLabel)
        
        components.usernameLabel.anchor(top: components.profileImage.topAnchor, left: components.profileImage.rightAnchor, paddingTop: .makeWidth(7), paddingLeft: .makeWidth(15))
        components.nameLabel.anchor(top: components.usernameLabel.bottomAnchor, left: components.usernameLabel.leftAnchor)
        components.detailLabel.anchor(top: components.nameLabel.bottomAnchor, left: components.nameLabel.leftAnchor)
        
        if followingCache.plusCount > 0{
            components.detailLabel.text = "Followed by \(followingCache.userName.lowercased()) + \(followingCache.plusCount) more"
        }else{
            components.detailLabel.text = "Followed by \(followingCache.userName.lowercased())"
        }
    }
    
    fileprivate func getLabelDetails(_ profile: Profile) {
        let detailResults = getDetail(profile)
        switch detailResults.option{
        case .following:
            components.detailLabel.text = "Following"
        case .followedBy:
            if let userID = detailResults.userID{
                getUserName(for: userID) { [weak self] userName in
                    if detailResults.moreCount! > 0{
                        self?.components.detailLabel.text = "Followed by \(userName.lowercased()) + \(detailResults.moreCount!) more"
                    }else{
                        self?.components.detailLabel.text = "Followed by \(userName.lowercased())"
                    }
                }
            }
        case .none:
            components.detailLabel.text = ""
        case .contact:
            components.detailLabel.text = "From Contacts"
        }
        
        if detailResults.option == .none{
            contentView.addSubview(components.usernameLabel)
            contentView.addSubview(components.nameLabel)
            components.usernameLabel.anchor(top: components.profileImage.topAnchor, left: components.profileImage.rightAnchor, paddingTop: .makeWidth(16.5), paddingLeft: .makeWidth(15))
            components.nameLabel.anchor(top: components.usernameLabel.bottomAnchor, left: components.usernameLabel.leftAnchor)
        }else{
            contentView.addSubview(components.usernameLabel)
            contentView.addSubview(components.nameLabel)
            contentView.addSubview(components.detailLabel)
            components.usernameLabel.anchor(top: components.profileImage.topAnchor, left: components.profileImage.rightAnchor, paddingTop: .makeWidth(7), paddingLeft: .makeWidth(15))
            components.nameLabel.anchor(top: components.usernameLabel.bottomAnchor, left: components.usernameLabel.leftAnchor)
            components.detailLabel.anchor(top: components.nameLabel.bottomAnchor, left: components.nameLabel.leftAnchor)
        }
    }
    
    fileprivate func getDetail(_ profile: Profile) -> DetailResult{
        let myFollowing = User.shared.following
        let contactNumbers = ContactsManager.instance.contacts.map({$0.number})
        let peopleWhoFollow = profile.followers?.filter({myFollowing.contains($0)})
        if myFollowing.contains(profile.id!){
            //Following
            return DetailResult(option: .following)
        }else if contactNumbers.contains(profile.number ?? ""){
            return DetailResult(option: .contact)
        }else if let peopleWhoFollow = peopleWhoFollow, peopleWhoFollow.count > 0 {
            //Follwed by user + Int
            let first = peopleWhoFollow[0]
            return DetailResult(option: .followedBy, moreCount: peopleWhoFollow.count - 1, userID: first)
        }else{
            //None
            return DetailResult(option: .none)
        }
    }
    
    fileprivate func getUserName(for id: String, completion: @escaping(String) -> Void){
        USERS_COLLECTION.document(id).getDocument { snap, e in
            guard let snap = snap, snap.exists else{ return completion("") }
            do{
                let userData = try snap.data(as: Profile.self)
                return completion(userData.user_name)
            }catch{
                return completion("")
            }
        }
    }
    
   fileprivate struct DetailResult{
        let option: DetailResultOption
        let moreCount: Int?
        let userID: String?
        
        init(option: DetailResultOption, moreCount: Int? = nil, userID: String? = nil) {
            self.option = option
            self.moreCount = moreCount
            self.userID = userID
        }
        enum DetailResultOption{
            case following
            case followedBy
            case contact
            case none
        }
    }
    
    struct FollowedByCache: Hashable{
        let userName: String
        let profileId: String
        let plusCount: Int
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(profileId)
        }
        
        init(userName: String, profileId: String, plusCount: Int) {
            self.userName = userName
            self.profileId = profileId
            self.plusCount = plusCount
        }
    }
}

