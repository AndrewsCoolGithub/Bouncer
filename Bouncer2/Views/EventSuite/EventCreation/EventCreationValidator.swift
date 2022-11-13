//
//  EventCreationValidator.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/25/22.
//

import Foundation
import CoreLocation

class EventCreationValidator{
    
    //static let eventDraft: EventDraft = EventCreationVC.shared.eventDraft
    
    static let allProperties: [EventCreateVCTypes] = [.eventTitle, .eventDescription, .eventLocation, .eventSchedule, .eventType]
    
    static var firstMissingProp: EventCreateVCTypes {
        return allProperties.first(where: {!checkProp($0)}) ?? .eventOverview
    }
    
    static func checkProp(_ vcType: EventCreateVCTypes) -> Bool{
        switch vcType {
        case .eventTitle:
            if let eventTitle = EventCreationVC.shared.viewModel.eventTitle, eventTitle.isValid(3){
                return true
            }else{
                return false
            }
        case .eventDescription:
            if let descrip = EventCreationVC.shared.viewModel.descrip, descrip.isValid(10) {
                return true
            }else{
                return false
            }
        case .eventLocation:
            guard let eventlocation = EventCreationVC.shared.viewModel.location else { return false }
//            guard EventManager.shared.events.filter({CLLocation(latitude: $0.location.latitude, longitude: $0.location.longitude).distance(from: CLLocation(latitude: eventlocation.latitude, longitude: eventlocation.longitude)) < 100}).count == 0 else {
//
//                if EventCreationVC.Static.isDisposed == false{
//                    EventCreationVC.shared.showMessage(withTitle: "Oops", message: "There is already an event in this area.")
//                }
//                return false
//            }
            
            let coordinate₀ = CLLocation(latitude: eventlocation.latitude, longitude: eventlocation.longitude)
            let coordinate₁ = CLLocation(latitude: User.shared.locationInfo.latitude, longitude: User.shared.locationInfo.longitude)
            let distanceInMeters = coordinate₀.distance(from: coordinate₁)
            //Ensure location is w/in 1000 mi
            if distanceInMeters <= 1609344{
                return true
            }else{
                return false
            }
            
        case .eventSchedule:
            guard let duration = EventCreationVC.shared.viewModel.duration, let startDate = EventCreationVC.shared.viewModel.startDate else {
                return false
            }
            
            let endDate = startDate.addingTimeInterval(duration)
            if EventCreationVC.shared.viewModel.oldEvent == nil{
                let bool = endDate > startDate && startDate > .now ? true : false
                return bool
            }else{
                let bool = endDate > startDate && endDate > .now ? true : false
                return bool
            }
           
            
        case .eventType:
            let bool = EventCreationVC.shared.viewModel.eventType != nil ? true : false
            return bool
        case .eventOverview:
             return false
        }
    }
}
