//
//  MapViewController.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/10/22.
//

import Foundation
import UIKit
import Mapbox
import Combine

class MapViewController: UIViewController{
   
    let mapView: MGLMapView = {
        let mapView = MGLMapView()
        mapView.allowsRotating = false
        mapView.styleURL = URL(string: "mapbox://styles/andrewkestler/cl2pe4hr3007v14nx8l3tmyuh")
        mapView.logoView.isHidden = true
        mapView.isHapticFeedbackEnabled = true
        mapView.showsUserLocation = true
        mapView.attributionButton.isHidden = true
        
        return mapView
    }()
    
    let zoomButton: UIButton = {
        let button = UIButton(frame: .layoutRect(width: 50, height: 50, rectCenter: .centerX, padding: Padding(anchor: .bottom, padding: .makeHeight(120)), keepAspect: true))
        button.layer.applySketchShadow(color: .nearlyBlack().withAlphaComponent(0.3), alpha: 1, x: 0, y: .makeHeight(3), blur: .makeWidth(2), spread: .makeWidth(1.5), withRounding: .makeWidth(25))
        button.backgroundColor = .greyColor()
        button.layer.cornerRadius = .makeWidth(25)
        button.setImage(UIImage(systemName: "location.north.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let viewModel = MapViewModel()
    var cancellable = Set<AnyCancellable>()
    var initialLocation: AnyCancellable?
    var savedCamera: MGLMapCamera?
    lazy var detail: CollectionViewController = {
        let detail = CollectionViewController(viewModel: self.viewModel)
        return detail
    }()

    var annotations = Set<Event>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.frame = view.frame
        
        viewModel.delegate = self
        
        viewModel.$publicEvents.sink { [weak self] events in
            guard let events = events, !events.isEmpty else {return}
            let annots = events.compactMap { event -> MapEventAnnotation? in
                return self?.createAnnotation(for: event)
            }
            guard !annots.isEmpty else {return}
            self?.mapView.addAnnotations(annots)
        }.store(in: &cancellable)
        
        viewModel.$centerOnEvent.sink { [weak self] event in
            guard let event = event else {return}
            let coordinate = CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude)
            self?.mapView.setCenter(coordinate, zoomLevel: 15, animated: true)
        }.store(in: &cancellable)
        
        detail.dismissButton.addTarget(self, action: #selector(returnToLastCamera), for: .touchUpInside)
        
        view.addSubview(zoomButton)
        zoomButton.addTarget(self, action: #selector(zoomPressed), for: .touchUpInside)
        
        
        if let panGeture = mapView.gestureRecognizers?.first(where: {$0 is UIPanGestureRecognizer}) as? UIPanGestureRecognizer{
            panGeture.addTarget(self, action: #selector(didScrollInMap))
        }
    }
    
    @objc func zoomPressed(_ sender: UIButton){
        guard let userLocation = mapView.userLocation?.coordinate else {return}
        mapView.setCenter(userLocation, zoomLevel: 14, animated: true)
    }
    
    @objc func returnToLastCamera(){
        if let savedCamera = self.savedCamera{
            self.mapView.setCamera(savedCamera, animated: true)
            self.savedCamera = nil
        }
        dismissDetail()
    }
    
    
    fileprivate func dismissDetail() {
        UIView.transition(with: detail.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.detail.view.layer.opacity = 0
        })
        self.savedCamera = nil
    }
    
    @objc func didScrollInMap(_ sender: UIPanGestureRecognizer){
        dismissDetail()
    }
    
    func createAnnotation(for event: Event) -> MapEventAnnotation?{
        if annotations.contains(event){
            return nil
        }else{
            annotations.update(with: event)
            return MapEventAnnotation(event: event)
        }
    }
    var count: Int = 0
}

extension MapViewController: MGLMapViewDelegate{
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        
        guard let userLocationCoord = mapView.userLocation?.coordinate else {return}
        let centerCoord = mapView.centerCoordinate
       
        let divisor = pow(10.0, Double(6)) ///Only compare first 6 decimal places
        let centerCordLat = (centerCoord.latitude * divisor).rounded() / divisor
        let centerCordLon = (centerCoord.longitude * divisor).rounded() / divisor
        
        let userCordLat = (userLocationCoord.latitude * divisor).rounded() / divisor
        let userCordLon = (userLocationCoord.longitude * divisor).rounded() / divisor

        
        if (centerCordLat == userCordLat && centerCordLon == userCordLon) && mapView.zoomLevel == 14  {
            if zoomButton.isHidden == false {
                UIView.animate(withDuration: 0.35, animations: {
                    self.zoomButton.alpha = 0
                }) { (finished)  in
                    if finished {
                        self.zoomButton.isHidden = true
                    }
                }
            }
        }else{
            if zoomButton.isHidden == true{
                zoomButton.isHidden = false
                zoomButton.alpha = 0
                UIView.animate(withDuration: 0.5) {
                    self.zoomButton.alpha = 1
                }
            }
        }
    }
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        guard let userLocation = userLocation?.location else {return}
        Location.shared.checkForUpdate(userLocation)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        var bool: Bool = true
        self.initialLocation = User.shared.$locationInfo.sink { location in
            guard let location = location else {return}
            if bool{
                mapView.setCenter(location.coordinates, zoomLevel: 11, animated: true)
                bool = false
            }
        }
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard let eventAnnotation = annotation as? MapEventAnnotation, let id = eventAnnotation.event.id else {return nil}
        guard let view = mapView.dequeueReusableAnnotationView(withIdentifier: id) else {
           return MapEventAnnotView((annotation as? MapEventAnnotation)!, id: id)
        }
        
       return view
    }
    

    func mapView(_ mapView: MGLMapView, didSelect annotationView: MGLAnnotationView) {
        if savedCamera == nil{
            self.savedCamera = mapView.camera
        }
        
        let initial = (annotationView.annotation! as! MapEventAnnotation).event!
        guard let index = viewModel.publicEvents?.firstIndex(of: initial) else {return}
        detail.lastIndex = IndexPath(row: index as Int, section: 0)
        
        addChild(detail)
       
        detail.didMove(toParent: self)
        detail.view.layer.opacity = 1
        view.addSubview(detail.view)
    }
    
    func mapView(_ mapView: MGLMapView, didDeselect annotationView: MGLAnnotationView) {
//        print("DESELECTED")
//        self.savedCamera = mapView.camera
//        //mapView.setCenter(annotationView.annotation!.coordinate, zoomLevel: 15, animated: true)
//
//        let initial = (annotationView.annotation! as! MapEventAnnotation).event!
//        //print(initial.title)
//        guard let index = viewModel.publicEvents?.firstIndex(of: initial) else {return}
//        detail.lastIndex = IndexPath(row: index as Int, section: 0)
//
//        addChild(detail)
//
//        detail.didMove(toParent: self)
//        detail.view.layer.opacity = 1
//        view.addSubview(detail.view)
    }
}

extension MapViewController: Navigatable{
    func navigate(to event: Event) {
        
    }
}

