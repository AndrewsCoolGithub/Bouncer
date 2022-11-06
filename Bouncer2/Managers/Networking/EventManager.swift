//
//  EventManager.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/23/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseAuth
import Firebase
import Combine

let EVENTS_COLLECTION = Firestore.firestore().collection("Events")
final class EventManager: ObservableObject{
    
    static let shared = EventManager()
    private var listener: ListenerRegistration?
    private var changesListener: ListenerRegistration?
    
    @Published var events = [Event]()
    @Published var modified = [Event]()
    @Published var upcoming = [Event]()
    @Published var previouslyHosted = [Event]() {
        didSet{
            print("SO IT HAPPENS THAT I GOT EM")
        }
    }
    
    public func stopListeningForEvents() {
        if listener != nil {
          listener?.remove()
          listener = nil
        }
    }
    
    private init(){
        self.listenForEvents()
        self.listenForChanges()
        self.fetchEventHistory()
        self.fetchUpcoming()
    }
    
    //MARK: - Create
    
    /** Creates a NEW document in the Event's collection w/ 'Event' model as the input*/
    func create(_ event: Event, image: UIImage?) async throws -> String{
        do{
            let eventRef = EVENTS_COLLECTION.document()
            if let image = image{
                let url = try await MediaManager.uploadImage(image, path: Storage.storage().reference().child("Event").child(eventRef.documentID))
                try eventRef.setData(from: Event(imageURL: url, title: event.title, description: event.description, location: event.location, locationName: event.locationName, startsAt: event.startsAt, endsAt: event.endsAt, type: event.type, colors: event.colors, hostId: event.hostId))
            }else{
                try eventRef.setData(from: event)
            }
           
            return eventRef.documentID
        }catch{
            throw error
        }
    }
    
    //MARK: - Read
    
    /** Fetch Event w/ given identifier*/
    func getEvent(with id: String) async throws -> Event{
        do{
            let doc = try await EVENTS_COLLECTION.document(id).getDocument()
            let event = try doc.data(as: Event.self)
            return event
        }catch{
            throw error
        }
    }
   
    
    /** Listens for Updates on ALL Event Documents*/
    func listenForEvents(){
        if listener == nil {
            listener = EVENTS_COLLECTION.addSnapshotListener({ [weak self] (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else { return }
                self?.events = documents.compactMap({ doc in
                    let result = Result { try doc.data(as: Event.self) }
                    switch result {
                    case .success(let event):
                        guard event.endsAt > .now else {return nil}
                        return event
                    case .failure(let error):
                        print("Event could not be initliazed from the document w/ identifier: \(doc.documentID)... Error: \(error.localizedDescription)")
                        return nil
                    }
                })
            })
        }
    }
    
    //Recgonizes updates as well as new pieces 
    func listenForChanges(){
        
        if changesListener == nil {
            changesListener = EVENTS_COLLECTION.addSnapshotListener({ [weak self] (querySnapshot, error) in
                
                guard let documents = querySnapshot?.documentChanges.filter({$0.type == .modified}).compactMap({$0.document}) else { return }
                self?.modified = documents.compactMap({ doc in
                    let result = Result { try doc.data(as: Event.self) }
                    switch result {
                    case .success(let event):
                        guard event.endsAt > .now else {return nil}
                        return event
                    case .failure(let error):
                        print("Event could not be initliazed from the document w/ identifier: \(doc.documentID)... Error: \(error.localizedDescription)")
                        return nil
                    }
                })
            })
        }
    }
    
    /** Find events previously hosted */
    private func fetchEventHistory()  {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        EVENTS_COLLECTION.whereField(EventFields.hostId, isEqualTo: uid).whereField(EventFields.endsAt, isLessThanOrEqualTo: Date.now).getDocuments { docs, e in
            if let e = e{
                print("‼️ Unable to load event history: \(e.localizedDescription)")
                return
            }
            
            self.previouslyHosted = docs?.documents.compactMap({ doc -> Event? in
                return try? doc.data(as: Event.self)
            }).sorted(by: {$0.endsAt > $1.endsAt}) ?? []
        }
    }
    
    /** Find events visible and upcoming hosted by current User */
    private func fetchUpcoming(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        EVENTS_COLLECTION.whereField(EventFields.hostId, isEqualTo: uid).whereField(EventFields.startsAt, isGreaterThan: Date.now).addSnapshotListener { docs, e in
            if let e = e{
                print("‼️ Unable to load upcoming events: \(e.localizedDescription)")
                return
            }
            
            self.upcoming = docs?.documents.compactMap({ doc -> Event? in
                return try? doc.data(as: Event.self)
            }).sorted(by: {$0.startsAt < $1.startsAt}) ?? []
        }
    }
    
   
    //MARK: - Update
    
    /** Add to Event Collection (rsvp, waitlist, invited, guest)*/
    func addTo(collection: EventCollections, with eventID: String) async throws{
        try await EVENTS_COLLECTION.document(eventID).updateData([collection.rawValue: FieldValue.arrayUnion([User.shared.id!])])
    }
    
    /** Modify Event Data, replaces given field with new data */
    func replace(_ field: EventModification, with data: Any) async throws{
        try await EVENTS_COLLECTION.document("my eventID").updateData([field.rawValue: data])
    }
    
    //MARK: - Delete
    
    /** Remove from Event Collection (rsvp, waitlist, invited, guest) */
    func remove(from collection: EventCollections, for eventID: String) async throws{
        try await EVENTS_COLLECTION.document(eventID).updateData([collection.rawValue: FieldValue.arrayRemove([User.shared.id!])])
    }
}

enum EventCollections: String{
    case prospects = "prospectIds"
    case invited = "invitedIds"
    case guest = "guestIds"
}

enum EventModification: String{
    case imageURL = "imageURL"
    case title = "title"
    case description = "description"
    case location = "location"
    case startsAt = "startsAt"
    case endsAt = "endsAt"
    case type = "type"
}
