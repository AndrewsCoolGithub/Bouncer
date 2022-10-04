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
        let imageView = components.profileImage
        setupImage(imageView, profile)
        setupLabels(profile, imageView, followCache)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        components.profileImage.removeFromSuperview()
        components.usernameLabel.removeFromSuperview()
        components.nameLabel.removeFromSuperview()
        components.detailLabel.removeFromSuperview()
    }
    
    fileprivate func setupImage(_ imageView: UIImageView, _ profile: Profile) {
        let skeleton = components.skeletonGradient
        skeleton.frame = CGRect(origin: imageView.frame.origin, size: CGSize(width: .makeWidth(75), height: .makeWidth(75)))
        contentView.addSubview(imageView)
        imageView.centerY(inView: contentView, leftAnchor: contentView.leftAnchor, paddingLeft: .makeWidth(15))
        imageView.layer.addSublayer(skeleton)
        imageView.sd_setImage(with: URL(string: profile.image_url)) { i, e, c, u in
            skeleton.removeFromSuperlayer()
        }
    }
    
    fileprivate func setupLabels(_ profile: Profile, _ imageView: UIImageView, _ followingCache: FollowedByCache?) {
        let userNameLabel = components.usernameLabel
        userNameLabel.text = profile.user_name.lowercased()
        let displayNameLabel = components.nameLabel
        displayNameLabel.text = profile.display_name.capitalized
        let detailLabel = components.detailLabel
        if let followingCache = followingCache{
            restoreLabelFromCache(userNameLabel, displayNameLabel, detailLabel, imageView, followingCache)
        }else{
            getLabelDetails(profile, detailLabel, userNameLabel, displayNameLabel, imageView)
        }
    }
    
    fileprivate func restoreLabelFromCache(_ userNameLabel: UILabel, _ displayNameLabel: UILabel, _ detailLabel: UILabel, _ imageView: UIImageView, _ followingCache: ProfileSearchCell.FollowedByCache) {
        contentView.addSubview(userNameLabel)
        contentView.addSubview(displayNameLabel)
        contentView.addSubview(detailLabel)
        
        userNameLabel.anchor(top: imageView.topAnchor, left: imageView.rightAnchor, paddingTop: .makeWidth(7), paddingLeft: .makeWidth(15))
        displayNameLabel.anchor(top: userNameLabel.bottomAnchor, left: userNameLabel.leftAnchor)
        detailLabel.anchor(top: displayNameLabel.bottomAnchor, left: displayNameLabel.leftAnchor)
        
        if followingCache.plusCount > 0{
            detailLabel.text = "Followed by \(followingCache.userName.lowercased()) + \(followingCache.plusCount) more"
        }else{
            detailLabel.text = "Followed by \(followingCache.userName.lowercased())"
        }
    }
    
    fileprivate func getLabelDetails(_ profile: Profile, _ detailLabel: UILabel, _ userNameLabel: UILabel, _ displayNameLabel: UILabel, _ imageView: UIImageView) {
        let detailResults = getDetail(profile)
        switch detailResults.option{
        case .following:
            detailLabel.text = "Following"
        case .followedBy:
            if let userID = detailResults.userID{
                getUserName(for: userID) { userName in
                    if detailResults.moreCount! > 0{
                        detailLabel.text = "Followed by \(userName.lowercased()) + \(detailResults.moreCount!) more"
                    }else{
                        detailLabel.text = "Followed by \(userName.lowercased())"
                    }
                }
            }
        case .none:
            detailLabel.text = ""
        case .contact:
            detailLabel.text = "From Contacts"
        }
        
        if detailResults.option == .none{
            contentView.addSubview(userNameLabel)
            contentView.addSubview(displayNameLabel)
            userNameLabel.anchor(top: imageView.topAnchor, left: imageView.rightAnchor, paddingTop: .makeWidth(16.5), paddingLeft: .makeWidth(15))
            displayNameLabel.anchor(top: userNameLabel.bottomAnchor, left: userNameLabel.leftAnchor)
        }else{
            contentView.addSubview(userNameLabel)
            contentView.addSubview(displayNameLabel)
            contentView.addSubview(detailLabel)
            userNameLabel.anchor(top: imageView.topAnchor, left: imageView.rightAnchor, paddingTop: .makeWidth(7), paddingLeft: .makeWidth(15))
            displayNameLabel.anchor(top: userNameLabel.bottomAnchor, left: userNameLabel.leftAnchor)
            detailLabel.anchor(top: displayNameLabel.bottomAnchor, left: displayNameLabel.leftAnchor)
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

