//
//  ProximityManager.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 10/22/23.
//

import Foundation
import CoreLocation
import Combine

class ProximityManager{
    
    static let shared = ProximityManager()
    
    private var cancellable = Set<AnyCancellable>()
    private var events: [Event] = []
    
    private init(){
        EventManager.shared.$events.sink { [weak self] events in
            guard events.count > 0 else {return}
            self?.events = events
        }.store(in: &cancellable)
    }
    
    
    
    func checkEventProximities(_ location: CLLocation) {
        let closeEvents = self.events.filter({$0.getLocation().distance(from: location) < 200})
        
    }
}
