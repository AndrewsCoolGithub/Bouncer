//
//  FirestoreSubscription.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/3/22.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreSubscription {
    static func subscribe(id: String, collection: FirestoreCollections, fromServer: Bool = false) -> AnyPublisher<DocumentSnapshot, Never> {
        let subject = PassthroughSubject<DocumentSnapshot, Never>()
        let docRef = Firestore.firestore().collection(collection.rawValue).document(id)
        let listener = docRef.addSnapshotListener(includeMetadataChanges: true) { snapshot, _ in
            
            if let snapshot = snapshot {
                if snapshot.metadata.isFromCache && fromServer == true{
                    return
                }
                subject.send(snapshot)
            }
        }
        listeners[id] = Listener(listener: listener, subject: subject)
        return subject.eraseToAnyPublisher()
    }
    
    static func subscribeToCollection(id: String? = nil, collection: FirestoreCollections, fromServer: Bool = false) -> AnyPublisher<QuerySnapshot, Never> {
        let subject = PassthroughSubject<QuerySnapshot, Never>()
        var refrence: Query!
        switch collection {
        case .Messages:
            guard let id = id else {fatalError("Messages collection requires a Chat ID (Message Detail)")}
            refrence = Firestore.firestore().collection("Users").document(User.shared.id!).collection("Chats").document(id).collection("Messages").order(by: MessageFields.sentDate.rawValue)
           
        case .Chats:
            refrence = Firestore.firestore().collection("Users").document(User.shared.id!).collection("Chats")
        default:
            break
        }
      
        let listener = refrence.addSnapshotListener(includeMetadataChanges: true) { snapshot, _ in
            if let snapshot = snapshot{
                if snapshot.metadata.isFromCache && fromServer == true{
                    return
                }else{
                    subject.send(snapshot)
                }
            }
        }
        collectionListeners[collection.rawValue] = CollectionListener(listener: listener, subject: subject)
        return subject.eraseToAnyPublisher()
    }
  
    static func cancel(id: String) {
        let listener = listeners[id]
        listener?.listener.remove()
        listener?.subject.send(completion: .finished)
        listeners[id] = nil
        print("Removed document listener w/ path: \(id)")
    }
    
    static func cancelCollection(_ type: FirestoreCollections){
        let listener = collectionListeners[type.rawValue]
        listener?.listener.remove()
        listener?.subject.send(completion: .finished)
        collectionListeners[type.rawValue] = nil
        print("Removed collection listener for \(type.rawValue)")
    }
}

private var listeners: [String: Listener] = [:]
private struct Listener {
    let listener: ListenerRegistration
    let subject: PassthroughSubject<DocumentSnapshot, Never>
}
private var collectionListeners: [String: CollectionListener] = [:]
private struct CollectionListener {
    let listener: ListenerRegistration
    let subject: PassthroughSubject<QuerySnapshot, Never>
}

struct FirestoreDecoder {
    static func decode<T>(_ type: T.Type) -> (DocumentSnapshot) -> T? where T: Decodable {{ snapshot in
            try? snapshot.data(as: type)
        }
    }
}
