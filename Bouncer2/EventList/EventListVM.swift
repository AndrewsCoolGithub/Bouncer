//
//  EventListVM.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/12/22.
//

import Foundation
import Combine

class AllEventListVM: ObservableObject{
    
    @Published var events = [Event]()
    
    @Published var modified: [Event]?
    public var cancellable = Set<AnyCancellable>()
    
    @Published var liveCount: Int = 0
    @Published var todayCount: Int = 0
    @Published var upcomingCount: Int = 0
    
    @Published var invitedCount: Int = 0
    @Published var rsvpCount: Int = 0
    @Published var waitlistCount: Int = 0
    
    @Published var startAnimation: Bool = true
    
   
    
    init(){
        getMostRecentEvents()
        getModified()
    }
    
   fileprivate func getMostRecentEvents(){
        EventManager.shared.$events.sink { subscompletion_never in
            print(subscompletion_never)
        } receiveValue: { [weak self] _events in
            self?.events = _events
            self?.updateCounts(for: _events)
            self?.updateMyCounts(for: _events)
        }.store(in: &cancellable)
    }
    
    @objc func getModified(){
        EventManager.shared.$modified.sink { subscompletion_never in
            print(subscompletion_never)
        } receiveValue: { [weak self] _modified in
            print("Modified")
            self?.modified = _modified
            //self?.updateMyCounts(for: _modified)
        }.store(in: &cancellable)
    }
    
    
    fileprivate func updateCounts(for events: [Event]?){
        guard let events = events else {return}
        
        let liveEvents = events.filter({$0.startsAt < .now})
        self.liveCount = liveEvents.count //Events currently live
        
        let todayEvents = events.filter({Calendar.current.isDateInToday($0.startsAt) && !liveEvents.contains($0)})
        self.todayCount = todayEvents.count //Events happening within current date
        
        let upcomingEvents = events.filter({$0.startsAt > .now && !todayEvents.contains($0)})
        self.upcomingCount = upcomingEvents.count //Events coming up > today
    }
    
    fileprivate func updateMyCounts(for events: [Event]?){
        guard let events = events else {return}
        
        var invitedCount: Int = 0
        invitedCount += events.filter({$0.invitedIds?.contains(User.shared.id!) ?? false}).count
        invitedCount += events.filter({($0.rsvpIds?.contains(User.shared.id!) ?? false) && $0.startsAt < .now}).count
        self.invitedCount = invitedCount
        
        var rsvpCount: Int = 0
        rsvpCount += events.filter({($0.rsvpIds?.contains(User.shared.id!) ?? false) && $0.startsAt > .now && !($0.invitedIds?.contains(User.shared.id!) ?? false)}).count
        self.rsvpCount = rsvpCount
        
        var waitlistCount: Int = 0
        waitlistCount += events.filter({($0.waitlistIds?.contains(User.shared.id!) ?? false) && !($0.invitedIds?.contains(User.shared.id!) ?? false)}).count
        self.waitlistCount = waitlistCount
    }
}


