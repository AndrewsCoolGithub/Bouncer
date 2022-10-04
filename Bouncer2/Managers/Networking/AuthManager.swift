//
//  AuthManager.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/23/22.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
let USERS_COLLECTION = Firestore.firestore().collection("Users")
final class AuthManager: ObservableObject{
    
    static let shared = AuthManager()
    private init(){}
    
    enum SignInType{
        case number
    }
    
    @Published var errorMessage: String?
    fileprivate var phoneAuthToken: String?

    //MARK: - PHONE VERIFICATION
    
    //1 - Create a token and send user a verfication code
    public func startVerification(number: String) async throws{
        phoneAuthToken = try await PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil)
    }
    
    //2 - Use verification code & token to sign in user
    public func signIn(code: String) async throws{
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.phoneAuthToken!,
                                            verificationCode: code)
        try await Auth.auth().signIn(with: credential)
        guard let number = Auth.auth().currentUser?.phoneNumber else {return}
        try await uploadUserData(number.dropFirst(2), field: ProfileFields.number)
    }
    
    public func accountExists(_ uid: String) async throws -> Bool{
        let document = try await USERS_COLLECTION.document(uid).getDocument()
        return document.exists
    }
    
    public func userNameExists(_ userName: String) async throws {
        let snapshot = try await USERS_COLLECTION.whereField(ProfileFields.username.rawValue, isEqualTo: userName).getDocuments()
        if snapshot.documents.count > 0{
            throw AuthError.userNameExists
        }
    }
    
    public func uploadProfilePicture(_ image: UIImage) async throws{
        guard let uid = Auth.auth().currentUser?.uid else { throw  AuthError.noUID}
        let path = Storage.storage().reference().child("ProfileImages").child(uid)
        async let url = MediaManager.uploadImage(image, path: path)
        try await USERS_COLLECTION.document(uid).setData([ProfileFields.imageURL.rawValue: url], merge: true)
    }
    
    public func uploadBackdropPicture(_ image: UIImage) async throws{
        guard let uid = Auth.auth().currentUser?.uid else { throw  AuthError.noUID}
        let path = Storage.storage().reference().child("BackdropImages").child(uid)
        async let url = MediaManager.uploadImage(image, path: path)
        try await USERS_COLLECTION.document(uid).setData([ProfileFields.backDropURL.rawValue: url], merge: true)
    }
    
    public func uploadCoords(_ coord: GeoPoint) async throws{
        guard let uid = Auth.auth().currentUser?.uid else { throw AuthError.noUID }
        try await USERS_COLLECTION.document(uid).setData([ProfileFields.latitude.rawValue: coord.latitude, ProfileFields.longitude.rawValue: coord.longitude], merge: true)
    }
    
    public func uploadUserData(_ data: Any?, field: ProfileFields) async throws{
        guard let uid = Auth.auth().currentUser?.uid else { throw AuthError.noUID }
        guard let data = data else { throw AuthError.noData }
        if field == .colors{
            guard let colors = data as? [ColorModel] else {throw AuthError.noData}
            try await uploadColors(colors)
            return
        }
        try await USERS_COLLECTION.document(uid).setData([field.rawValue: data], merge: true)
    }
    
    public func uploadColors(_ colors: [ColorModel]) async throws{
        guard let uid = Auth.auth().currentUser?.uid else { throw AuthError.noUID }
        let userRef = USERS_COLLECTION.document(uid)
        let userData = try await userRef.getDocument().data(as: Profile.self)
        let newData = Profile(image_url: userData.image_url, display_name: userData.display_name, user_name: userData.user_name, latitude: userData.latitude, longitude: userData.longitude, backdrop_url: userData.backdrop_url, bio: userData.bio, followers: userData.followers, following: userData.following, blocked: userData.blocked, blockedBy: userData.blockedBy, colors: colors, number: userData.number, email: userData.email, emojis: userData.emojis, recentEmojis: userData.recentEmojis)
        try userRef.setData(from: newData)
    }
    
    public func updateEmojis(_ emojis: [Emoji]) async throws{
        guard let uid = Auth.auth().currentUser?.uid else {throw AuthError.noUID}
        let userRef = USERS_COLLECTION.document(uid)
        let userData = try await userRef.getDocument().data(as: Profile.self)
        var recentEmojis: [Emoji]? = userData.recentEmojis
        if recentEmojis != nil {
            let indexsToRemove: [Int] = emojis.compactMap { emoji in
                recentEmojis!.firstIndex(of: emoji)
            }
            
            for i in indexsToRemove {
                recentEmojis!.remove(at: i)
            }
        }
        
        let newData = Profile(image_url: userData.image_url, display_name: userData.display_name, user_name: userData.user_name, latitude: userData.latitude, longitude: userData.longitude, backdrop_url: userData.backdrop_url, bio: userData.bio, followers: userData.followers, following: userData.following, blocked: userData.blocked, blockedBy: userData.blockedBy, colors: userData.colors, number: userData.number, email: userData.email, emojis: emojis, recentEmojis: recentEmojis)
        try userRef.setData(from: newData)
    }
    
    public func updateRecents(_ emojis: [Emoji]) async throws{
        guard let uid = Auth.auth().currentUser?.uid else {throw AuthError.noUID}
        let userRef = USERS_COLLECTION.document(uid)
        let userData = try await userRef.getDocument().data(as: Profile.self)
        let newData = Profile(image_url: userData.image_url, display_name: userData.display_name, user_name: userData.user_name, latitude: userData.latitude, longitude: userData.longitude, backdrop_url: userData.backdrop_url, bio: userData.bio, followers: userData.followers, following: userData.following, blocked: userData.blocked, blockedBy: userData.blockedBy, colors: userData.colors, number: userData.number, email: userData.email, emojis: userData.emojis, recentEmojis: emojis)
        try userRef.setData(from: newData)
    }
    
    enum AuthError: Error{
        case noUID
        case noData
        case userNameExists
    }
}
