//
//  FirestoreCollectionEnum.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/3/22.
//

import Foundation
import Firebase
//let USERS_COLLECTION = Firestore.firestore().collection("Users")
//let EVENTS_COLLECTION = Firestore.firestore().collection("Events")

enum FirestoreCollections: String{
    case Events = "Events"
    case Guests = "Guests"
    case Users = "Users"
    case Messages = "Messages"
    case Chats = "Chats"
    case Stories = "Stories"
}


