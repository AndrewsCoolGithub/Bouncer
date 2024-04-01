//
//  MapViewModel.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/20/22.
//

import Foundation
import Firebase
import Combine
import CoreLocation
final class MapViewModel: ObservableObject{
    
    var delegate: Navigatable?
    var cancellable = Set<AnyCancellable>()
    @Published var publicEvents: [Event]?
    @Published var navigateTo: Event?
    @Published var centerOnEvent: Event?
    
    init(){
        fetchEvents()
    }
    
    func fetchEvents() {
        EventManager.shared.$events.sink { [weak self] events in
            guard events.count > 0 else {return}
            self?.publicEvents = self?.makeRoute(events)
        }.store(in: &cancellable)
    }
    
    func makeRoute(_ events: [Event]) -> [Event]{
        var events = events
        
        var result = [Event]()
        
        let start = events.removeLast()
        var startLocation = CLLocation(latitude: start.location.latitude, longitude: start.location.longitude)
        result.append(start)
        for _ in 0...events.count {
            guard let event = getShortestDistance(for: startLocation, events) else {
                return result
            }
            result.append(event)
            events.removeAll(where: {$0 == event})
            startLocation = CLLocation(latitude: event.location.latitude, longitude: event.location.longitude)
        }
       
        return result
    }
    
    func getShortestDistance(for location: CLLocation, _ events: [Event]) -> Event?{
        return events.map{
            EventDistance(event: $0,
                          distance: location.distance(from: CLLocation(latitude: $0.location.latitude,
                                                                       longitude: $0.location.longitude)))
        }
        .sorted(by: {$0.distance < $1.distance}).first?.event
            
    }
    
    struct EventDistance{
        let event: Event
        let distance: Double
        
        init(event: Event, distance: Double) {
            self.event = event
            self.distance = distance
        }
    }
}
