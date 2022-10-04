//
//  EventSuiteViewModel.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/16/22.
//

import Foundation
import CoreLocation

class EventSuiteCellViewModel: Hashable{
    static func == (lhs: EventSuiteCellViewModel, rhs: EventSuiteCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let dataType: EventSuiteDataType
    
    var id: String? {
        switch self.dataType{
        case .draft(event: let data):
            return data.id
        case .event(event: let data):
            return data.id
        }
    }
    
    func delete(){
        switch dataType {
        case .draft(let event):
            do{
                let result = try DraftManager.shared.removeEventDraft(id: event.id)
                if result{print("Successfully deleted draft")}
            }catch{
                print("Error deleting draft: \(error.localizedDescription)")
            }
        case .event(let event):
            print("Not a draft: \(event)")
        }
    }
    
    
//    
//    var imageURL: URL? {
//        switch self.dataType{
//        case .draft(data: let data):
//            return data.imageURL
//        case .event(data: let data):
//            return URL(string: data.imageURL)
//        }
//    }
//    var title: String? {
//        switch self.dataType{
//        case .draft(data: let data):
//            return data.id
//        case .event(data: let data):
//            return data.id
//        }
//    }
//    var description: String? {
//        switch self.dataType{
//        case .draft(data: let data):
//            return data.id
//        case .event(data: let data):
//            return data.id
//        }
//    }
//    var location: CLLocationCoordinate2D? {
//        switch self.dataType{
//        case .draft(data: let data):
//            guard let location = data.location else{ return nil }
//            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
//        case .event(data: let data):
//            return CLLocationCoordinate2D(latitude: data.location.latitude, longitude: data.location.longitude)
//        }
//    }
//    var startsAt: Date? {
//        switch self.dataType{
//        case .draft(data: let data):
//            return data.startsAt
//        case .event(data: let data):
//            return data.startsAt
//        }
//    }
//    var endsAt: Date? {
//        switch self.dataType{
//        case .draft(data: let data):
//            return data.endsAt
//        case .event(data: let data):
//            return data.endsAt
//        }
//    }
//    var type: EventType? {
//        switch self.dataType{
//        case .draft(data: let data):
//            return data.type
//        case .event(data: let data):
//            return data.type
//        }
//    }
//    var colors: [ColorModel]? {
//        switch self.dataType{
//        case .draft(data: let data):
//            return data.colors
//        case .event(data: let data):
//            return data.colors
//        }
//    }
    
    init(event: Event? = nil, draft: EventDraft? = nil){
        if let event = event {
            self.dataType = .event(event: event)
        }else{
            self.dataType = .draft(event: draft!)
        }
    }
}
enum EventSuiteDataType{
    case draft(event: EventDraft)
    case event(event: Event)
}

protocol EventSuiteData{}
extension Event: EventSuiteData{}
extension EventDraft: EventSuiteData{}


