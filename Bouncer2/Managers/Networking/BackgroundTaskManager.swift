//
//  BackgroundTaskManager.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/17/22.
//

import FirebaseFirestoreSwift
import CoreLocation
import FirebaseFunctions
import Firebase

final class BackgroundLocationManager{
    
    static let shared = BackgroundLocationManager()
    
    func callBackground<Request: Encodable, Response: Decodable>
    (_ name: BackgroundTaskCallable, request: Request, responseType: Response.Type) async throws -> Response{
       try await Functions.functions().httpsCallable(name.rawValue,
                                                     requestAs: Request.self,
                                                     responseAs: responseType).callAsFunction(request)
            
        
    }
    
    func getCloseEvents(_ location: CLLocation) async throws -> [Event]{
        let geoHash = try Geohash.encode(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let geohashs = try Geohash.neighbors(of: geoHash, includingCenter: true)
        
        let docs = try await EVENTS_COLLECTION.whereField(EventFields.geoHash, in: geohashs).getDocuments().documents
        var closeEvents = docs.compactMap { doc -> Event? in
            guard let event = try? doc.data(as: Event.self) else {return nil}
            guard event.getLocation().distance(from: location) <= 50000 else {return nil}
            return event
        }
        closeEvents.sort(by: {$0.getLocation().distance(from: location) > $1.getLocation().distance(from: location)})
        return closeEvents.suffix(15)
    }
    
//    func getEventsForRegionMonitoring(_ currentLocation: CLLocation) async throws -> [Event]{
//        EVENTS_COLLECTION.where
//        
//        var eventsWithin30mi = events.filter({$0.type == .open && $0.startsAt < .now && $0.endsAt > .now && $0.getLocation().distance(from: currentLocation) < 50000})
//        eventsWithin30mi.sort(by: {$0.getLocation().distance(from: currentLocation) > $1.getLocation().distance(from: currentLocation)})
//        return events.suffix(15)
//    }

    
}

struct GeoData: Codable{
    let latitude: CGFloat
    let longitude: CGFloat
    let geohashs: [String]
    
    init(latitude: CGFloat, longitude: CGFloat, geohashs: [String]) {
        self.latitude = latitude
        self.longitude = longitude
        self.geohashs = geohashs
    }
}

enum BackgroundTaskCallable: String{
    case getEventsForRegionMonitoring
}
