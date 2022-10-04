//
//  AccountInfo.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/17/22.
//

import Foundation
import Firebase
import FirebaseAuth
import Photos
import Contacts
import Combine

final class AccountInfo{

    
    
    static var cancellable = Set<AnyCancellable>()
    
    static var phoneNumber: String? {
        return Auth.auth().currentUser?.phoneNumber
    }
    
    static var accountNotificationID = Notification.Name("accountDataUpdated")
    static var accountData: AccountData? {
        didSet{
            
            guard accountData != nil else {return}
            
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as! UIWindowScene
            let window = windowScene.windows.first!
            let navigationController = window.rootViewController as? UINavigationController
            let topController = navigationController?.topViewController
            guard let missingData = AccountInfo.checkForMissingData() else {
                if locationStatus != .notDetermined {
                    if contactsStatus == .authorized{
                        if !(topController is AccountContacts){
                            navigationController?.pushViewController(AccountContacts(), animated: true)
                        }
                    }else{
                        if !(topController is AccountContactPerm){
                            navigationController?.pushViewController(AccountContactPerm(), animated: true)
                        }
                    }
                }else{
                    if !(topController is AccountLocationPerm1){
                        navigationController?.pushViewController(AccountLocationPerm1(), animated: true)
                    }
                }
               
                AccountInfo.stopListeningForUpdates()
                return
            }
            
            
            switch missingData{
            case .firstName:
                if !(topController is AccountFirstName){
                    navigationController?.pushViewController(AccountFirstName(), animated: true)
                }
               
            case .userName:
                if !(topController is AccountUserName){
                    navigationController?.pushViewController(AccountUserName(), animated: true)
                }
               
            case .photo:
                if AccountInfo.cameraRollStatus == .authorized || AccountInfo.cameraRollStatus == .limited{
                    if !(topController is AccountPicture){
                        navigationController?.pushViewController(AccountPicture(), animated: true)
                    }
                }else{
                    if !(topController is AccountCameraPerm){
                        navigationController?.pushViewController(AccountCameraPerm(), animated: true)
                    }
                }
            }
        }
    }
    
    static var uid: String? {
        return Auth.auth().currentUser?.uid
    }
    
    static var userName: String? {
        UserDefaults.standard.string(forKey: DefaultsKeys.userName)
    }
    
    static var displayName: String? {
        UserDefaults.standard.string(forKey: DefaultsKeys.displayName)
    }
    
    static var cameraRollStatus: PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
    
    static var contactsStatus: CNAuthorizationStatus {
        return CNContactStore.authorizationStatus(for: .contacts)
    }
    
    static var locationStatus: CLAuthorizationStatus {
        return CLLocationManager().authorizationStatus
    }
    
    static var contacts: [Contact]? {
        if contactsStatus == .authorized{
            return ContactsManager.instance.contacts
        }else{
            return nil
        }
    }
    
    static func process(input: Any?, _ networkType: AccountNetworking) async throws{
        switch networkType{
            
        case .sendNumber:
            try await AuthManager.shared.startVerification(number: "+1" + String((input as! String).filter { !" \n\t\r".contains($0) }))
        case .signIn:
            try await AuthManager.shared.signIn(code: input as! String)
            self.listenForUserUpdates(uid: uid!)
        case .uploadPicture:
            try await AuthManager.shared.uploadProfilePicture(input as! UIImage)
        case .notifyContacts:
            print("❎TODO: SEND Notifications to friends")
        case .uploadFirstName:
            try await AuthManager.shared.uploadUserData(input as! String, field: .name)
            try await AuthManager.shared.uploadCoords(GeoPoint(latitude: 30.601389, longitude: -96.314445)) ///THIS IS TEMPORARY, fulfills mandotary requirement for User Profile
        case .uploadUsername:
            try await AuthManager.shared.userNameExists(input as! String)
            try await AuthManager.shared.uploadUserData(input as! String, field: .username)
        }
    }
    
    
    static func storeValue(_ value: Any?, _ key: String){
        UserDefaults.standard.setValue(value, forKeyPath: key)
    }
    
    
    static func listenForUserUpdates(uid: String) {
        FirestoreSubscription.subscribe(id: uid, collection: .Users, fromServer: true).sink { doc in
            guard let rawData = doc.data() else {return}
            self.accountData = AccountData(id: doc.documentID, number: rawData[ProfileFields.number.rawValue] as! String?, user_name: rawData[ProfileFields.username.rawValue] as! String?, display_name: rawData[ProfileFields.name.rawValue] as! String?, image_url: rawData[ProfileFields.imageURL.rawValue] as! String?)
        }.store(in: &cancellable)
    }
    
    static func stopListeningForUpdates(){
//        let uid = Auth.auth().currentUser!.uid
//        FirestoreSubscription.cancel(id: uid)
    }
    
    static func checkForMissingData() -> MissingAccountData? {
        guard let accountData = accountData else { fatalError("Account data was nil") }
        if accountData.display_name == nil{
            return .firstName
        }else if accountData.user_name == nil{
            return .userName
        }else if accountData.image_url == nil{
            return .photo
        }else{
            return .none
        }
    }
    
    
    enum AccountNetworking{
        case sendNumber
        case signIn
        case uploadPicture
        case uploadFirstName
        case uploadUsername
        case notifyContacts
    }
}
enum MissingAccountData{
    case firstName
    case userName
    case photo
}
