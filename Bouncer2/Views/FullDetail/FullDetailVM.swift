//
//  FullDetailVM.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/3/22.
//

import Foundation
import Combine
import CoreLocation

class FullDetailVM: ObservableObject{
    
    var cancellable = Set<AnyCancellable>()
    
    
    //Why is event optional
    @Published var event: Event? {
        didSet{
            imageURL = event?.imageURL
            eventTitle = event?.title
            description = event?.description
            locationName = event?.locationName
            type = event?.type
            colors = event?.colors
            location = CLLocationCoordinate2D(latitude: event!.location.latitude, longitude: event!.location.longitude)
            startDate = event?.startsAt
            endDate = event?.endsAt
            determineAction(event)
            if let rsvpIds = event?.rsvpIds{
                Task{
                   try await grabUserInfo(rsvpIds)
                }
            }
        }
    }
    
    @Published var imageURL: String?
    @Published var eventTitle: String?
    @Published var description: String?
    @Published var locationName: String?
    @Published var type: EventType?
    @Published var colors: [ColorModel]?
    @Published var location: CLLocationCoordinate2D?
    @Published var action: ListAction!
    @Published var buttonCount: String!
    @Published var rsvps: [Profile] = []
    @Published var startDate: Date? {
        didSet{
            guard let startDate = startDate, let event = event, startDate > .now else {
                timerCancellable?.cancel()
                self.endDate = endDate
                return
            }
            
            ///Upcoming
            
            if let timerCancellable = timerCancellable{
                timerCancellable.cancel()
            }
        
            timerCancellable = Timer.publish(every: startDate.timeIntervalSince(.now), on: .main, in: .default).autoconnect().sink { [weak self] _  in
                self?.determineAction(event)
                self?.endDate = self?.endDate
            }
        }
    }
    var timerCancellable: AnyCancellable? = nil
    @Published var endDate: Date?
    
    var id: String!
    init(id: String, event: Event? = nil){
        self.id = id
        if let event = event{
            if id != event.id{
                fatalError("Event object id doesn't match!")
            }
            self.event = event
          
        }
        
        FirestoreSubscription.subscribe(id: id, collection: .Events) .compactMap(FirestoreDecoder.decode(Event.self))
            .receive(on: DispatchQueue.main)
            .map({$0})
            .assign(to: \.event, on: self)
            .store(in: &cancellable)
    }
    
    func grabUserInfo(_ rsvpIds: [String]) async throws{
        if let profiles = try? await ProfileManager.shared.fetchProfiles(rsvpIds){
            rsvps = profiles
        }
    }
    
    func determineAction(_ event: Event?){
        guard let event = event else {return}
        let invited = event.invitedIds != nil ? event.invitedIds! : []
        let rsvps = event.rsvpIds != nil ? event.rsvpIds! : []
        let waitlist = event.waitlistIds != nil ? event.waitlistIds! : []
        
        guard event.endsAt > .now else{
            self.action = .unavailable
            self.buttonCount = "Ended"
            return
        }
        
        guard event.hostId != User.shared.id else {
            self.action = .unavailable
            self.buttonCount = "Edit Event"
            return
        }
        
        if event.startsAt < .now{  //Live
            switch event.type{
                
            case .exclusive:
                if invited.contains(where: {$0 == User.shared.id}){
                    self.action = .nav
                    self.buttonCount = "Directions"
                }else if waitlist.contains(where: {$0 == User.shared.id}){
                    self.action = .leaveWaitlist
                    self.buttonCount = "Leave Waitlist"
                }else{
                    self.action = .joinWaitlist
                    self.buttonCount = "Join Waitlist"
                }
            case .open:
                self.action = .nav
                self.buttonCount = "Directions"
            }
        }else{ //Upcoming
            switch event.type{
                
            case .exclusive:
                if invited.contains(where: {$0 == User.shared.id}){
                    self.action = .invited
                    self.buttonCount = "\(invited.count) Invited"
                }else if waitlist.contains(where: {$0 == User.shared.id}){
                    self.action = .leaveWaitlist
                    self.buttonCount = "\(waitlist.count) Waiting"
                }else{
                    self.action = .joinWaitlist
                    self.buttonCount = "\(waitlist.count) Waiting"
                }
            case .open:
                if rsvps.contains(where: {$0 == User.shared.id}){
                    self.action = .unRSVP
                    self.buttonCount = "\(rsvps.count) Going"
                }else{
                    self.action = .RSVP
                    self.buttonCount = "\(rsvps.count) Going"
                }
            }
        }
    }
    
    //Button Actions
    func perform(){
        guard let currentAction = action, let eventID = event?.id else {fatalError("actionValue was nil, either time issue or bad logic")}
        switch currentAction{
        case .joinWaitlist:
            Task{
                do{
                    action = .leaveWaitlist
                    try await EventManager.shared.addTo(collection: .waitlist, with: eventID)
                }catch{
                    action = .joinWaitlist
                }
            }
        case .leaveWaitlist:
            Task{
                do{
                    action = .joinWaitlist
                    try await EventManager.shared.remove(from: .waitlist, for: eventID)
                }catch{
                    action = .leaveWaitlist
                }
            }
        case .RSVP:
            Task{
                do{
                    action = .unRSVP
                    try await EventManager.shared.addTo(collection: .rsvp, with: eventID)
                }catch{
                    action = .RSVP
                }
            }
        case .unRSVP:
            Task{
                do{
                    action = .RSVP
                    try await EventManager.shared.remove(from: .rsvp, for: eventID)
                }catch{
                    action = .unRSVP
                }
            }
        case .nav:
            return
        case .invited:
            return
        case .unavailable:
            return
        }
    }
}
