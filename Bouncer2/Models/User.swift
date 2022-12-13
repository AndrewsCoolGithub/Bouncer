//
//  UserLocationInfo.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/13/22.
//

import Foundation
import FirebaseAuth
import UIImageColors
import Combine

final class User: ObservableObject{
    
    static let shared = User()
    
    var profile: Profile {
        get{
            return Profile(id: id!, image_url: imageURL!, display_name: displayName!, user_name: userName!, latitude: latitude!, longitude: longitude!, timeJoined: timeJoined, backdrop_url: backdropImageURL, bio: bio, followers: followers, following: following, blocked: blocked, blockedBy: blockedBy, colors: colors, number: number, email: email, emojis: emojis, recentEmojis: recentEmojis)
        }
    }
    
    private init(){
        
    }
    let randInt = Int.random(in: 0...10)
    static var cancellable: AnyCancellable!
    static func setup(){
        guard let id = Auth.auth().currentUser?.uid else {return}
        shared.id = id
        cancellable = FirestoreSubscription.subscribe(id: id, collection: .Users).sink { doc in
            do{
                
                let profile = try doc.data(as: Profile.self)
                shared.userName = profile.user_name
                shared.imageURL = profile.image_url
                shared.bio = profile.bio
                shared.backdropImageURL = profile.backdrop_url ?? User.defaultbackdrop(int: shared.randInt)
                shared.displayName = profile.display_name
                shared.latitude = profile.latitude
                shared.longitude = profile.longitude
                shared.colors = profile.colors ?? User.defaultColors.colorModel
                shared.blocked = profile.blocked ?? []
                shared.blockedBy = profile.blockedBy ?? []
                shared.following = profile.following ?? []
                shared.followers = profile.followers ?? []
                shared.emojis = profile.emojis ?? defaultEmojis
                shared.recentEmojis = profile.recentEmojis
                shared.number = profile.number ?? ""
                shared.email = profile.email ?? ""
                shared.timeJoined = profile.timeJoined ?? .now
            }catch{
                print("Error fetching user data, yikes 😡: \(error.localizedDescription)")
            }
        }
    }
    
    @Published var id: String! = Auth.auth().currentUser?.uid
    @Published var userName: String?
    @Published var imageURL: String?
    @Published var bio: String?
    @Published var backdropImageURL: String?
    @Published var displayName: String?
    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var blocked = [String]()
    @Published var blockedBy = [String]()
    @Published var following = [String]()
    @Published var followers = [String]()
    @Published var emojis: [Emoji]!
    @Published var recentEmojis: [Emoji]?
    @Published var number: String!
    @Published var email: String!
    @Published var timeJoined: Date! = .now
        
    @Published var locationInfo: LocationInformation!
    
    @Published var colors: [ColorModel]! = User.defaultColors.colorModel
    
    static let defaultColors = UIImageColors(background: .white, primary: UIColor(red: 50/255, green: 197/255, blue: 1, alpha: 1), secondary: UIColor(red: 182/255, green: 32/255, blue: 224/255, alpha: 1), detail: UIColor(red: 247/255, green: 181/255, blue: 0, alpha: 1))
    
    static let defaultEmojis = [Emoji(name: "Smiling Face with Sunglasses", emote: "😎"), Emoji(name: "Blue Heart", emote: "💙"), Emoji(name: "Face with Symbols on Mouth", emote: "🤬"), Emoji(name: "Thumbs Up", emote: "👍"), Emoji(name: "Saluting Face", emote: "🫡"), Emoji(name: "Face with Tears of Joy", emote: "😂")]
    
    static func defaultbackdrop(int: Int) -> String{
        switch int{
        case 1:
            return "https://firebasestorage.googleapis.com/v0/b/bouncer-f8461.appspot.com/o/DefaultBackdrops%2FBackdropDefault1.png?alt=media&token=8795e7df-abcb-4850-8e64-0581bc5c6992"
        case 2:
            return "https://firebasestorage.googleapis.com/v0/b/bouncer-f8461.appspot.com/o/DefaultBackdrops%2FBackdropDefault2.png?alt=media&token=96df23e0-ffdb-4f2f-8b02-12450e3dffc3"
        case 3:
            return "https://firebasestorage.googleapis.com/v0/b/bouncer-f8461.appspot.com/o/DefaultBackdrops%2FBackdropDefault3.png?alt=media&token=b5adeb2b-9944-4ec0-9a16-50c952e8006a"
        case 4:
            return "https://firebasestorage.googleapis.com/v0/b/bouncer-f8461.appspot.com/o/DefaultBackdrops%2FBackdropDefault4.png?alt=media&token=7a94ed0a-7709-4739-a084-8369199cff92"
        case 5:
            return "https://firebasestorage.googleapis.com/v0/b/bouncer-f8461.appspot.com/o/DefaultBackdrops%2FBackdropDefault5.png?alt=media&token=1d8ef9a5-4cb9-4097-bbb1-53f7d5f1de64"
        case 6:
            return "https://firebasestorage.googleapis.com/v0/b/bouncer-f8461.appspot.com/o/DefaultBackdrops%2FBackdropDefault6.png?alt=media&token=06555de7-e691-4575-9905-0ed09c128c0a"
        case 7:
            return "https://firebasestorage.googleapis.com/v0/b/bouncer-f8461.appspot.com/o/DefaultBackdrops%2FBackdropDefault7.png?alt=media&token=340839ce-132a-43fd-bb4b-006363ee2e4a"
        case 8:
            return "https://firebasestorage.googleapis.com/v0/b/bouncer-f8461.appspot.com/o/DefaultBackdrops%2FBackdropDefault8.png?alt=media&token=f7b15dcc-f5ff-44db-aede-9f6fa5eb592c"
        case 9:
            return "https://firebasestorage.googleapis.com/v0/b/bouncer-f8461.appspot.com/o/DefaultBackdrops%2FBackdropDefault9.png?alt=media&token=06f33ee3-ed4b-4cb2-b340-b70f951fad2e"
        default:
            return "https://firebasestorage.googleapis.com/v0/b/bouncer-f8461.appspot.com/o/DefaultBackdrops%2FBackdropDefault10.png?alt=media&token=b0ac890a-0314-4ea8-b31f-c5c681129459"
        }
    }
}

