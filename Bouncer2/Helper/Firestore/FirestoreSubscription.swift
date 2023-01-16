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
            refrence = CHAT_COLLECTION.document(id).collection("Messages").order(by: MessageFields.sentDate.rawValue)
        case .Chats:
            refrence = CHAT_COLLECTION.whereField("users", arrayContains: User.shared.id!)
        case .Stories:
            guard let id = id else {fatalError("Stories collection requires an event ID ")}
            refrence = STORY_REF.whereField(StoryFields.eventId.rawValue, isEqualTo: id).order(by: StoryFields.date.rawValue)
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
    
    static func subscribeToCollection(with query: Query, id: String) -> AnyPublisher<QuerySnapshot, Never>{
        let subject = PassthroughSubject<QuerySnapshot, Never>()
        let listener = query.addSnapshotListener { snapshot, _ in
            if let snapshot = snapshot{
                subject.send(snapshot)
            }
        }
        queries[id] = QueryListener(listener: listener, subject: subject)
        return subject.eraseToAnyPublisher()
    }
  
    static func cancel(id: String) {
        if let listener = listeners[id] {
            listener.listener.remove()
            listener.subject.send(completion: .finished)
            listeners[id] = nil
        }else if let listener = queries[id]{
            listener.listener.remove()
            listener.subject.send(completion: .finished)
            queries[id] = nil
        }
       
       
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
private var queries: [String: QueryListener] = [:]

private struct QueryListener {
    let listener: ListenerRegistration
    let subject: PassthroughSubject<QuerySnapshot, Never>
}
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
