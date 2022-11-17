//
//  EventSuiteDetailVM.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/11/22.
//

import Combine
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
        self.listenForUpdates(event.id!)
    }
    
    deinit{
        FirestoreSubscription.cancel(id: event.id!)
        event = nil
        cancellable.forEach({$0.cancel()})
    }
    
    @Published var suggested = [Profile]()
    @Published var prospects = [Profile]()
    @Published var invited = [Profile]()
    @Published var guest = [Profile]()
    @Published var data = [EventSuiteDetail.Section: (profiles: [Profile], isHidden: Bool)]()
    
    
    fileprivate var _compareP = [String]()
    fileprivate var prospectIds = [String]() { didSet {
        if _compareP == prospectIds {return}
        _compareP = prospectIds
        Task{await getUsers(true)}
    }}
    
    fileprivate var _compareI = [String]()
    fileprivate var invitedIds = [String]() { didSet {
        if _compareI == invitedIds{return}
        _compareI = invitedIds
        Task{await getUsers(false)}
    }}
    
    
    fileprivate func fetchSuggestedUsers(){
        Task{
            suggested = await User.shared.following.getUsers()
            suggested.sort(by: {$0.isConnection == true && $1.isConnection == false})
            let isHidden = data[EventSuiteDetail.Section.three]!.isHidden
            data[EventSuiteDetail.Section.three] = (suggested, isHidden)
        }
    }
    
    fileprivate func listenForUpdates(_ id: String){
        FirestoreSubscription.subscribe(id: id, collection: .Events) .compactMap(FirestoreDecoder.decode(Event.self))
            .receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] event in
            self?.prospectIds = event.prospectIds?.filter({!(event.invitedIds ?? []).contains($0)}) ?? []
            self?.invitedIds = event.invitedIds ?? []
            self?.detailType = event.type == .open ? .open : .exclusive
        }).store(in: &cancellable)
    }
    
    
    fileprivate func getUsers(_ isProspects: Bool) async {
        
        if isProspects{
            let isHidden = data[EventSuiteDetail.Section.one]!.isHidden
            if prospectIds.isEmpty{ data[EventSuiteDetail.Section.one] = ([], isHidden); return}
            var profiles = [Profile]()
            for id in prospectIds{
                if let profile = try? await USERS_COLLECTION.document(id).getDocument(as: Profile.self){
                    profiles.append(profile)
                }
            }
            data[EventSuiteDetail.Section.one] = (profiles, isHidden)
        }else{
            let isHidden = data[EventSuiteDetail.Section.two]!.isHidden
            if invitedIds.isEmpty{ data[EventSuiteDetail.Section.two] = ([], isHidden); return}
            var profiles = [Profile]()
            for id in invitedIds{
                if let profile = try? await USERS_COLLECTION.document(id).getDocument(as: Profile.self){
                    profiles.append(profile)
                }
            }
            data[EventSuiteDetail.Section.two] = (profiles, isHidden)
        }
    }
    
    public func ttlLabelText() -> String?{
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
        case Requests
        case Invited
        case Suggested
        
        public init?(_ section: EventSuiteDetail.Section) {
            switch section {
            case .one:
                self = .Requests
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
