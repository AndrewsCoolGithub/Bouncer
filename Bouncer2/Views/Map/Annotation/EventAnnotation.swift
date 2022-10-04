//
//  EventAnnotation.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/3/22.
//

import Foundation
import UIKit
import Mapbox

class EventPointAnnot: MGLPointAnnotation{
    
    
    init(coordinates: CLLocationCoordinate2D) {
        super.init()
        self.coordinate = coordinates
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

