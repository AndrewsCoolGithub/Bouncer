//
//  CLLocationCoord.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 9/29/22.
//

import CoreLocation

extension CLLocationCoordinate2D{
    
    
    ///Utilizies location manager internally to get distance in miles, if current location is unknown may return nil
    func toDistance() -> String?{
        guard let cl = Location.shared.locationManager.location else {return nil}
        let meters = cl.distance(from: CLLocation(latitude: latitude, longitude: longitude))
        let mi = meters / 1609.34
        
        if mi > 10{
            return "\(Int(mi))"
        }else{
            return "\(mi.rounded(1))"
        }
    }
}


