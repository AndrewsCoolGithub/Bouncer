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
    
    @Published var detailType: DetailType
    init(_ event: Event){
        self.event = event
        
        switch event.type{
        case .exclusive:
            detailType = .exclusive
        case .open:
            detailType = .open
        }
        
        for sec in EventSuiteDetail.Section.allCases{
            data[sec] = ([], false)
        }
        
        
        self.fetchSuggestedUsers()
        self.listenForProspectUpdates(event.id!)
    }
    
    deinit{
        FirestoreSubscription.cancel(id: event.id!)
        event = nil
        cancellable.forEach({$0.cancel()})
    }
    
    @Published var suggested = [Profile]()
    @Published var prospects = [Profile]()
    @Published var guest = [Profile]()
    @Published var data = [EventSuiteDetail.Section: (profiles: [Profile], isHidden: Bool)]()
    
    var prospectDictionary = Set<String>()
    
    fileprivate func getProspectUsers() async {
        if prospectIds.isEmpty{ prospects = []; return}
        var profiles = [Profile]()
        for id in prospectIds{
            if let profile = try? await USERS_COLLECTION.document(id).getDocument(as: Profile.self){
                profiles.append(profile)
            }
        }
        print("profiles check for async: \(profiles)")
        prospects = profiles
        let isHidden = data[EventSuiteDetail.Section.one]!.isHidden
        data[EventSuiteDetail.Section.one] = (prospects, isHidden)
    }
    
    var prospectIds = [String]() {didSet { Task{await getProspectUsers()} }}
    
    func fetchSuggestedUsers(){
        Task{
            suggested = await User.shared.following.getUsers()
            suggested.sort(by: {$0.isConnection == true && $1.isConnection == false})
            let isHidden = data[EventSuiteDetail.Section.three]!.isHidden
            data[EventSuiteDetail.Section.three] = (suggested, isHidden)
        }
    }
    
    func listenForProspectUpdates(_ id: String){
        FirestoreSubscription.subscribe(id: id, collection: .Events) .compactMap(FirestoreDecoder.decode(Event.self))
            .receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] event in
                self?.prospectIds = (event.prospectIds ?? [])
                
                if event.startsAt > .now{
                    self?.detailType = event.type == .open ? .open : .exclusive
                }else if event.startsAt < .now && event.endsAt > .now{
                    self?.detailType = .live
                }else{
                    self?.detailType = .history
                }
            })
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
        case history
    }
    
    public enum OpenSection: String {
        case RSVPs
        case Pending
        case Suggested
        
        public init?(_ section: EventSuiteDetail.Section) {
            switch section {
            case .one:
                self = .RSVPs
            case .two:
                self = .Pending
            case .three:
                self = .Suggested
            }
        }
    }
    
    public enum ExclusiveSection: String {
        case Request
        case Invited
        case Suggested
        
        public init?(_ section: EventSuiteDetail.Section) {
            switch section {
            case .one:
                self = .Request
            case .two:
                self = .Invited
            case .three:
                self = .Suggested
            }
        }
    }
    
    public enum LiveSection: String {
        case Guests
        case Invited
        case Suggested
        
        public init?(_ section: EventSuiteDetail.Section) {
            switch section {
            case .one:
                self = .Guests
            case .two:
                self = .Invited
            case .three:
                self = .Suggested
            }
        }
    }
    
    
    
}
