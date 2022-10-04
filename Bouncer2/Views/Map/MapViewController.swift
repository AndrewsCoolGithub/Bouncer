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
    
   // var pageController: MapAnnotationPageController!
    
    let viewModel = MapViewModel()
    var cancellable = Set<AnyCancellable>()
    var initialLocation: AnyCancellable?
    var savedCamera: MGLMapCamera?
    lazy var detail: CollectionViewController = {
        let detail = CollectionViewController(viewModel: self.viewModel)
        return detail
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.frame = view.frame
        
        
        
       
        
        viewModel.delegate = self
        
        viewModel.$publicEvents.sink { [weak self] events in
            guard let events = events else {return}

            let annotations = events.compactMap({self?.createAnnotation(for:$0)})
            self?.mapView.addAnnotations(annotations)
           
        }.store(in: &cancellable)
        
        viewModel.$centerOnEvent.sink { [weak self] event in
            guard let event = event, let coordinate = CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude) else {return}
            self?.mapView.setCenter(coordinate, zoomLevel: 17, animated: true)
        }.store(in: &cancellable)
        
        detail.dismissButton.addTarget(self, action: #selector(returnToLastCamera), for: .touchUpInside)
        
        if let panGeture = mapView.gestureRecognizers?.first(where: {$0 is UIPanGestureRecognizer}) as? UIPanGestureRecognizer{
            panGeture.addTarget(self, action: #selector(didScrollInMap))
        }
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
    
    func createAnnotation(for event: Event) -> MapEventAnnotation{
        return MapEventAnnotation(event: event)
    }
    var count: Int = 0
}
extension MapViewController: MGLMapViewDelegate{
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        var bool: Bool = true
            self.initialLocation =  User.shared.$locationInfo.sink { location in
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

