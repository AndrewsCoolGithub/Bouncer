//
//  EventMapPreview.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/12/22.
//

import Foundation
import Mapbox
import UIKit

class EventMapPreview: UIViewController{
    
    let mapView = MGLMapView()
    var event: EventDraft!
    init(event: EventDraft, image: UIImage){
        super.init(nibName: nil, bundle: nil)
        self.event = event
        let url = URL(string: "mapbox://styles/andrewkestler/cl2pe4hr3007v14nx8l3tmyuh")
        mapView.frame = view.bounds
        mapView.styleURL = url
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.isRotateEnabled = false
        
    
        mapView.isScrollEnabled = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateAnnotation(){
        if let annots = mapView.annotations{
            mapView.removeAnnotations(annots)
        }
        
        let coords = EventCreationVC.shared.viewModel.location!
        let annotation = EventPointAnnot(coordinates: coords)
        mapView.setCenter(coords, zoomLevel: 16, animated: true)
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let coords = CLLocationCoordinate2D(latitude: event.location!.latitude,
                                            longitude: event.location!.longitude)
            let annotation = EventPointAnnot(coordinates: coords)
            mapView.setCenter(coords, zoomLevel: 16, animated: true)
            mapView.addAnnotation(annotation)
        
    }
}
extension EventMapPreview: MGLMapViewDelegate{
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard annotation is MGLPointAnnotation else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "events-location")
        if annotationView == nil {
            annotationView = EventAnnotationView(image: EventCreationVC.initImage, annotation: annotation as? EventPointAnnot, reuseIdentifier: "lol", isDrag: false)
        }
        return annotationView
    }
}
