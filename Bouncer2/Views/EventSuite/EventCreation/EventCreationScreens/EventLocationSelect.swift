//
//  EventLocationSelect.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/30/22.
//

import Foundation
import UIKit
import Mapbox
import FirebaseFirestore
import CoreLocation

class EventLocationSelect: UIViewController{
    
    let mapView = MGLMapView()
    
    private let addressTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: .makeWidth(414 - 343)/2, y: .makeHeight(50), width: .makeWidth(343), height: .makeHeight(50)), cornerRadius: .makeHeight(15), colors: EventCreationVC.colors, lineWidth: 1, direction: .horizontal)
        
        textField.backgroundColor = .greyColor()
        textField.layer.applySketchShadow(color: .black.withAlphaComponent(0.3), alpha: 1, x: 0, y: 9, blur: 9, spread: 6, withRounding: .makeHeight(15))
        textField.tintColor = EventCreationVC.colors.detail
        
        let leftIcon = UIImageView(image: UIImage(named: "Annotation"))
        leftIcon.aspectSetDimensions(height: 30, width: 45)
        leftIcon.contentMode = .scaleAspectFit
        textField.leftViewMode = .always
        textField.leftView = leftIcon
        textField.attributedPlaceholder = NSAttributedString(string: "Enter an address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.nearlyWhite(), NSAttributedString.Key.font: UIFont.poppinsMedium(size: .makeHeight(18))])
        textField.font = .poppinsMedium(size: .makeHeight(17))
        return textField
    }()
    
    private let helperLabel: UILabel = {
        let label = UILabel()
        label.textColor = .nearlyWhite()
        label.font = .poppinsRegular(size: .makeWidth(16))
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addressTextField.gradientColors = EventCreationVC.shared.viewModel.colors
        addressTextField.tintColor = EventCreationVC.shared.viewModel.colors?.detail
        
        if let annotation = self.mapView.annotations?.first(where: {$0 is EventPointAnnot}){
            mapView.removeAnnotation(annotation)
            mapView.addAnnotation(annotation)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "mapbox://styles/andrewkestler/cl2pe4hr3007v14nx8l3tmyuh")
        mapView.frame = view.bounds
        mapView.styleURL = url
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = false
       
        view.addSubview(addressTextField)
        addressTextField.delegate = self
        
        view.addSubview(helperLabel)
        helperLabel.centerX(inView: addressTextField, topAnchor: addressTextField.bottomAnchor, paddingTop: .makeHeight(15))
        helperLabel.text = nil
       
        EventCreationVC.shared.navigator.deactivateButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dragState(sender:)), name: Notification.Name("dragAnnot"), object: EventAnnotationView.self)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: Notification.Name("dragAnnot"), object: EventAnnotationView.self)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        guard let location: CLLocationCoordinate2D = EventCreationVC.shared.viewModel.location != nil ? EventCreationVC.shared.viewModel.location : User.shared.locationInfo.coordinates else {return}
        
        
        if let annotations = self.mapView.annotations {
            self.mapView.removeAnnotations(annotations)
        }
        
        mapView.setCenter(location, zoomLevel: 15, animated: true)
        mapView.addAnnotation(EventPointAnnot(coordinates: location))
        UIView.transition(with: self.helperLabel, duration: 2.5, options: .transitionCrossDissolve){
            self.helperLabel.text = "Hold to adjust marker"
        }
        EventCreationVC.shared.viewModel.location = location
       
        
        if EventCreationValidator.checkProp(.eventLocation){
            EventCreationVC.shared.navigator.activateButton()
        }else{
            EventCreationVC.shared.navigator.deactivateButton()
        }
    }
    
    @objc func dragState(sender: Notification){
        if let state = sender.userInfo?["isDragging"] as? Bool{
            switch state{
            case true:
                self.addressTextField.resignFirstResponder()
                UIView.transition(with: self.helperLabel, duration: 1.5, options: .transitionCrossDissolve){ [weak self] in
                    self?.helperLabel.text = nil
                }
            case false:
                UIView.transition(with: self.helperLabel, duration: 1.5, options: .transitionCrossDissolve){ [weak self] in
                    self?.helperLabel.text = "Hold to adjust marker"
                    guard let annotation = self?.mapView.annotations?.first else {
                        return
                    }
                    EventCreationVC.shared.viewModel.location = annotation.coordinate
                    if EventCreationValidator.checkProp(.eventLocation){
                        EventCreationVC.shared.navigator.activateButton()
                    }else{
                        EventCreationVC.shared.navigator.deactivateButton()
                    }
                }
            }
        }
    }
    
   
    
    func getAddress(_ address: String){
        let geocoder = CLGeocoder()
    
        geocoder.geocodeAddressString(address) { [weak self] places, e in
            
            if let placemark = places?.first, let coordinate = placemark.location?.coordinate, e == nil{
                if let annotations = self?.mapView.annotations {
                    self?.mapView.removeAnnotations(annotations)
                }
               
                self?.mapView.addAnnotation(EventPointAnnot(coordinates: coordinate))
                self?.mapView.setCenter(coordinate, zoomLevel: 15, animated: true)
                UIView.transition(with: self?.helperLabel ?? UIView(), duration: 2.5, options: .transitionCrossDissolve){
                    self?.helperLabel.text = "Hold to adjust marker"
                }
                
                EventCreationVC.shared.viewModel.location = coordinate
                if EventCreationValidator.checkProp(.eventLocation){
                    EventCreationVC.shared.navigator.activateButton()
                }else{
                    EventCreationVC.shared.navigator.deactivateButton()
                }
            }
        }
    }
}

extension EventLocationSelect: MGLMapViewDelegate{
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard annotation is MGLPointAnnotation else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "events-location")
        if annotationView == nil {
            annotationView = EventAnnotationView(image: EventCreationVC.initImage, annotation: annotation as? EventPointAnnot, reuseIdentifier: "lol")
        }
        return annotationView
    }
}

extension EventLocationSelect: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        
        let charCount = (textField.text?.count ?? 0) + (string.count - range.length)
        if charCount >= 5{
            self.getAddress(textField.text! + string)
        }
        
        return true
    }
}

