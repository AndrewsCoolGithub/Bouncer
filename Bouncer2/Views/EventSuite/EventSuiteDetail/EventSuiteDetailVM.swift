//
//  EventSuiteDetailVM.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/11/22.
//

import Combine
import Foundation
import UIKit

final class EventSuiteDetailVM: ObservableObject{
    
    
    var cancellable = Set<AnyCancellable>()
    var event: Event!
    
    var detailType: DetailType
    init(_ event: Event){
        self.event = event
        
//        guard event.startsAt > .now else {detailType = .live; return}
        switch event.type{
        case .exclusive:
            detailType = .exclusive
        case .open:
            detailType = .open
        }
        
        
        self.fetchSuggestedUsers()
        self.listenForProspectUpdates(event.id!)
    }
    
    deinit{
        FirestoreSubscription.cancel(id: event.id!)
        event = nil
        cancellable.forEach({$0.cancel()})
    }
    
    @Published var suggested: [Profile]?
    @Published var prospects = [Profile]()
    var prospectDictionary = Set<String>()
    
    //TODO: Clean this up
    var prospectIds = [String]() {
        didSet{
            
            if prospectIds.isEmpty{
                prospects = []
                return
            }
            
            for id in prospectIds{
                if !prospectDictionary.contains(id){
                    prospectDictionary.update(with: id)
                    Task{
                        let profile = try await USERS_COLLECTION.document(id).getDocument(as: Profile.self)
                        
                        prospects.append(profile)
                        
                    }
                }
            }
        }
    }
    
    func fetchSuggestedUsers(){
        Task{
            suggested = await User.shared.following.getUsers()
        }
        self.suggested?.sort(by: {$0.isConnection == true && $1.isConnection == false})
    }
    
    func listenForProspectUpdates(_ id: String){
        FirestoreSubscription.subscribe(id: id, collection: .Events) .compactMap(FirestoreDecoder.decode(Event.self))
            .receive(on: DispatchQueue.main)
            .compactMap({$0.prospectIds})
            .assign(to: \.prospectIds, on: self)
            .store(in: &cancellable)
       
    }
    
    
    func ttlLabelText() -> String?{
        if event.startsAt > .now {
            return event.startsAt.timeIntervalSince(.now).countDownWithUnits
        }else if event.endsAt > .now{
            return event.endsAt.timeIntervalSince(.now).countDownWithUnits
        }else{
            return nil
        }
       
    }
    
    enum DetailType {
        case open
        case exclusive
        case live
    }
    
    public enum OpenSection: Int {
        case RSVPs
        case Pending
        case Suggested
    }
    
    public enum ExclusiveSection: Int {
        case Requested
        case Invited
        case Suggested
    }
    
    public enum LiveSection: Int {
        case Guests
        case Invited
    }
    
    
    
}
