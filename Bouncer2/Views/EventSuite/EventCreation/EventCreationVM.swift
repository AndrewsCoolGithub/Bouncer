//
//  EventCreateVM.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/7/22.
//

import Foundation
import CoreLocation
import UIImageColors
import UIKit //only for image var
import Firebase

final class EventCreationVM: ObservableObject{
    
    public var oldEvent: Event?
    @Published public var image: UIImage?
    @Published public var eventTitle: String?
    @Published public var descrip: String?
    @Published public var eventType: EventType?
    @Published public var location: CLLocationCoordinate2D?
    @Published public var startDate: Date?
    @Published public var duration: TimeInterval?
    @Published public var colors: UIImageColors!
    @Published public var currentController: CurrentVC?
    public var locationName: String!
    
    var onPreview: Bool = false
    
    var eventDraft: EventDraft{
        let location: GeoPoint? = (location?.latitude == nil && location?.longitude == nil) ? nil : GeoPoint(latitude: location!.latitude, longitude: location!.longitude)
        return EventDraft(title: self.eventTitle, description: self.descrip, location: location, startsAt: self.startDate, duration: self.duration, type: self.eventType, colors: self.colors.colors.map({$0.getColorModel()}))
    }
    
    public func save(){
        do{
            try  DraftManager.shared.saveEventDraft(eventDraft, image: EventCreationVC.initImage!)
        }catch{
            print("Failed to update event draft: \(error)")
        }
    }
    @Published var shouldPresentOverview: Bool?
    @objc func previousController(){
        if let previous = self.currentController?.previous, onPreview == false{
            self.currentController = previous
        }else{
            shouldPresentOverview = true
        }
    }
    
    
    @objc func nextController(){
        if let type = currentController?.type.next(), onPreview == false{
            self.currentController = self.currentVC(type: type)
        }else if currentController?.type.next() == nil{
            Task{
                do{
                    try await postEvent()
                    
                }catch let e{
                    print(e.localizedDescription)
                }
            }
        }else{
            self.currentController = currentVC(type: EventCreationValidator.firstMissingProp)
        }
    }
    
    func postEvent() async throws{
        do {
            guard EventCreationValidator.firstMissingProp == .eventOverview else {throw EventCreationValidator.firstMissingProp}
            let locationName = try await fetchLocationName()
            let id = try await EventManager.shared.create(Event(title: eventTitle!, description: descrip!, location: GeoPoint(latitude: location!.latitude, longitude: location!.longitude), locationName: locationName, startsAt: startDate!, endsAt: startDate!.addingTimeInterval(duration!), type: eventType!, colors: colors!.colors.map({$0.getColorModel()}), hostId: User.shared.id!, hostProfile: User.shared.profile), image: image!)
            print("Successfully created event w/ id: \(id)")
        }
    }
    
    func updateEvent() async throws{
        guard let oldEvent = oldEvent, let id = oldEvent.id else {return}
        guard EventCreationValidator.firstMissingProp == .eventOverview else {throw EventCreationValidator.firstMissingProp}
        let locationName = try await fetchLocationName()
       
        
        let image = self.image
        let initImage = await EventCreationVC.initImage
        
       
        let newEvent = Event(id: id, imageURL: nil, title: eventTitle!, description: descrip!, location: GeoPoint(latitude: location!.latitude, longitude: location!.longitude), locationName: locationName, startsAt: startDate!, endsAt: startDate!.addingTimeInterval(duration!), type: eventType!, colors: colors!.colors.map({$0.getColorModel()}), hostId: User.shared.id!, hostProfile: User.shared.profile)
        try await EventManager.shared.update(newEvent, image: image)
        
        print("Successfully updated event w/ id: \(id)")
    }
    
    fileprivate func fetchLocationName() async throws -> String{
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: location!.latitude, longitude: location!.longitude)
        do{
            let result = try await geoCoder.reverseGeocodeLocation(location)
            let eventLocationPlacemark = result[0]
            let city = eventLocationPlacemark.locality
            let state =  eventLocationPlacemark.administrativeArea
            return "\(city ?? "Unknown"), \(state ?? "USA")".capitalized
        }catch{
           throw error
        }
    }
    
    
    var controllerInMemory = Set<CurrentVC>()
    func currentVC(type: EventCreateVCTypes) -> CurrentVC{
        
        if controllerInMemory.count > 3{
            controllerInMemory.removeAll()
        }
        
        if controllerInMemory.contains(where: {$0.type == type}){
            return controllerInMemory.first(where: {$0.type == type})!
        }else{
            switch type{
            case .eventTitle:
                let title = CurrentVC(type: type, controller: EventTitleSelect(),
                                      previous: nil)
                controllerInMemory.update(with: title)
                return title
            case .eventDescription:
                let previous: CurrentVC? = self.onPreview ? nil : currentVC(type: .eventTitle)
                let description =  CurrentVC(type: type, controller: EventDescriptionSelect(),
                                 previous: previous)
                controllerInMemory.update(with: description)
                return description
            case .eventLocation:
                let previous: CurrentVC? = self.onPreview ? nil : currentVC(type: .eventDescription)
                let location = CurrentVC(type: type, controller: EventLocationSelect(),
                                 previous: previous)
                controllerInMemory.update(with: location)
                return location
            case .eventSchedule:
                let previous: CurrentVC? = self.onPreview ? nil : currentVC(type: .eventLocation)
                let schedule = CurrentVC(type: type, controller: EventScheduleSelect(),
                                 previous: previous)
                controllerInMemory.update(with: schedule)
                return schedule
            case .eventType:
                let previous: CurrentVC? = self.onPreview ? nil : currentVC(type: .eventSchedule)
                let eventType = CurrentVC(type: type, controller: EventTypeSelect(),
                                 previous: previous)
                controllerInMemory.update(with: eventType)
                return eventType
            case .eventOverview:
                let overView = CurrentVC(type: type, controller: EventPreview(event: eventDraft, image: EventCreationVC.initImage!) , previous: nil)
                controllerInMemory.update(with: overView)
                self.onPreview = true
                return overView
            }
        }
    }
}
