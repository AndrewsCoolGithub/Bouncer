//
//  LocationManager.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/12/22.
//

import Foundation
import CoreLocation
import UIKit
class Location: NSObject, CLLocationManagerDelegate {
    static let shared = Location()
    
    let locationManager : CLLocationManager
    
    var userLocation: CLLocation? {
        self.locationManager.location
    }
    
    
    
    var locationInfoCallBack: ((_ info: LocationInformation) -> ())!
       
    override private init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        super.init()
        locationManager.delegate = self
    }
    
    func start(completion: @escaping(_ info: LocationInformation) -> Void) {
        self.locationInfoCallBack = completion
        locationManager.requestAlwaysAuthorization()
        
    }

    func stop() {
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last, mostRecentLocation.horizontalAccuracy < 500 else {
            return
        }
       
        let info = LocationInformation()
        info.latitude = mostRecentLocation.coordinate.latitude
        info.longitude = mostRecentLocation.coordinate.longitude

        checkForUpdate(mostRecentLocation)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(mostRecentLocation) { (placemarks, error) in
            guard let placemarks = placemarks, let placemark = placemarks.first else { return }
            if let city = placemark.locality,
                let state = placemark.administrativeArea,
                let zip = placemark.postalCode,
                let locationName = placemark.name,
                let thoroughfare = placemark.thoroughfare,
                let country = placemark.country {
                info.city = city
                info.state = state
                info.zip = zip
                info.address = locationName + ", " + (thoroughfare as String)
                info.country = country
            }
            self.locationInfoCallBack(info)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }
    let noAlwaysVC = LocationRequiredVC()
   
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways{
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as! UIWindowScene
            let window = windowScene.windows.first!
            if window.rootViewController is LocationRequiredVC {
                let navCont = UINavigationController(rootViewController: TabBarController())
                navCont.navigationBar.isHidden = true
                window.rootViewController = navCont
            }
            manager.startUpdatingLocation()
        }else{
            //Set window for allows location requirement
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as! UIWindowScene
            let window = windowScene.windows.first!
            window.rootViewController = noAlwaysVC
            
        }
    }
    
    /* 1m/s = 2.236 mph
        
        */
    
    func checkForUpdate(_ location: CLLocation){
        let events = EventManager.shared.getEventsForRegionMonitoring(location)
        guard !events.isEmpty else {return}
        
        var newRegions = [String : CLCircularRegion]()
        events.forEach { event in
            newRegions[event.id!] = CLCircularRegion(center: event.getLocation().coordinate,
                                                     radius: 100,
                                                     identifier: event.id!)
        }
        
        for region in locationManager.monitoredRegions{
            if newRegions[region.identifier] == nil{
                locationManager.stopMonitoring(for: region)
            }
        }
        
        newRegions.values.forEach { region in
            locationManager.startMonitoring(for: region)
        }
        
        print("Monitering \(locationManager.monitoredRegions.count) regions: \(locationManager.monitoredRegions)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered region with id: \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited region with id: \(region.identifier)")
    }
}

class LocationInformation {
    var city: String
    var address: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var coordinates: CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    var zip: String
    var state: String
    var country: String
    
    init(city: String? = "", address: String? = "", latitude: CLLocationDegrees? = Double(0.0), longitude: CLLocationDegrees? = Double(0.0), zip: String? = "", state: String? = "", country: String? = "") {
        self.city = city!
        self.address = address!
        self.latitude = latitude!
        self.longitude = longitude!
        self.zip = zip!
        self.state = state!
        self.country = country!
    }
}
