//
//  MapEventAnnotation.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/20/22.
//

import Foundation
import Mapbox

class MapEventAnnotation: MGLPointAnnotation{
    
    var event: Event!
    
    
    init(event: Event) {
        super.init()
        self.title = event.id
        self.event = event
        
        self.coordinate = CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
