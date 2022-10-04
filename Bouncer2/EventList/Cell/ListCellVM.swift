//
//  ListCellVM.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/14/22.
//

import Foundation
import CoreLocation

class ListCellVM: ObservableObject{
    
    let event: Event
    @Published var action: ListAction
    @Published var timeSymbolName: TimeSymbol
    
    
    
    func updateActionForLive(){
        let invited = event.invitedIds != nil ? event.invitedIds! : []
        let waitlist = event.waitlistIds != nil ? event.waitlistIds! : []
        switch event.type{
        case .exclusive:
            if invited.contains(where: {$0 == User.shared.id}){
                self.action = .nav
            }else if waitlist.contains(where: {$0 == User.shared.id}){
                self.action = .leaveWaitlist
            }else{
                self.action = .joinWaitlist
            }
        case .open:
            self.action = .nav
        }
    }
    
    func fetchCalendarText() -> String{
        var hour = Calendar.current.component(.hour, from: event.startsAt)
        let minutes = Calendar.current.component(.minute, from: event.startsAt)
        if hour >= 12{
            hour = hour == 12 ? 12 : hour - 12
            print("time: \(hour):\(minutes)p")
            if minutes == 0{
                return "\(hour):\(minutes)0p"
            }else{
                return "\(hour):\(minutes)p"
            }
            
        }else{
            hour = hour == 0 ? 12 : hour
            print("time: \(hour):\(minutes)a")
            if minutes == 0{
                return "\(hour):\(minutes)0a"
            }else{
                return "\(hour):\(minutes)a"
            }
        }
    }
    
    func fetchTimeText() -> String{
        let startDate = event.startsAt
        let endDate = event.endsAt
        guard startDate.timeIntervalSinceNow < 0 else {
            timeSymbolName = .calendar
            return self.fetchCalendarText()
        }
        
        timeSymbolName = .clock
        let timeRemaining = endDate.timeIntervalSinceNow
        if timeRemaining >= 3600{
            let hoursRemaining = Float((timeRemaining / 3600)).rounded(.down)
            return "\(Int(hoursRemaining))h"
        }else{
            let minutesRemaining = Float((timeRemaining/60)).rounded(.down)
            return "\(Int(minutesRemaining))m"
        }
    }
    
    func perform(){
        switch action{
        case .joinWaitlist:
            Task{
                do{
                    action = .leaveWaitlist
                    try await EventManager.shared.addTo(collection: .waitlist, with: event.id!)
                }catch{
                    action = .joinWaitlist
                }
            }
        case .leaveWaitlist:
            Task{
                do{
                    action = .joinWaitlist
                    try await EventManager.shared.remove(from: .waitlist, for: event.id!)
                }catch{
                    action = .leaveWaitlist
                }
            }
        case .RSVP:
            Task{
                do{
                    action = .unRSVP
                    try await EventManager.shared.addTo(collection: .rsvp, with: event.id!)
                }catch{
                    action = .RSVP
                }
            }
        case .unRSVP:
            Task{
                do{
                    action = .RSVP
                    try await EventManager.shared.remove(from: .rsvp, for: event.id!)
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
    
    
    
    required init(event: Event){
        
        self.event = event
        let invited = event.invitedIds != nil ? event.invitedIds! : []
        let rsvps = event.rsvpIds != nil ? event.rsvpIds! : []
        let waitlist = event.waitlistIds != nil ? event.waitlistIds! : []
        
        if event.startsAt.timeIntervalSinceNow > 0 {
            self.timeSymbolName = .calendar
        }else{
            self.timeSymbolName = .clock
        }
        
        guard event.endsAt > .now  else { //&& event.hostId != User.shared.id
            self.action = .unavailable
            return
        }
       
        if event.startsAt < .now{  //Live
            switch event.type{
                
            case .exclusive:
                if invited.contains(where: {$0 == User.shared.id}){
                    self.action = .nav
                }else if waitlist.contains(where: {$0 == User.shared.id}){
                    self.action = .leaveWaitlist
                }else{
                    self.action = .joinWaitlist
                }
            case .open:
                self.action = .nav
            }
        }else{ //Upcoming
            switch event.type{
                
            case .exclusive:
                if invited.contains(where: {$0 == User.shared.id}){
                    self.action = .invited
                }else if waitlist.contains(where: {$0 == User.shared.id}){
                    self.action = .leaveWaitlist
                }else{
                    self.action = .joinWaitlist
                }
            case .open:
                if rsvps.contains(where: {$0 == User.shared.id}){
                    self.action = .unRSVP
                }else{
                    self.action = .RSVP
                }
            }
        }
    }
    
    func removeFromInvited(){
        let eventID = event.id!
        Task{
            if (event.invitedIds?.contains(User.shared.id!) ?? false){
                try await EventManager.shared.remove(from: .invited, for: eventID)
            }else if (event.rsvpIds?.contains(User.shared.id!) ?? false) && event.startsAt < .now{
                try await EventManager.shared.remove(from: .rsvp, for: eventID)
            }
        }
    }
    
    enum TimeSymbol: String{
        case calendar = "calendar.badge.clock"
        case clock = "clock.fill"
    }
}
enum ListAction{
    case joinWaitlist
    case leaveWaitlist
    case RSVP
    case unRSVP
    case nav
    case invited //clock.badge.checkmark.fill
    case unavailable
}
