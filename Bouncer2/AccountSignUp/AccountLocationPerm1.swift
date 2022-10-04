//
//  AccountLocationPerm1.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/7/22.
//

import UIKit
import Mapbox
import Combine

class AccountLocationPerm1: UIViewController{
    
    fileprivate let mapView: MGLMapView = {
        let mapView = MGLMapView()
        mapView.allowsRotating = false
        mapView.styleURL = URL(string: "mapbox://styles/andrewkestler/cl2pe4hr3007v14nx8l3tmyuh")
        mapView.logoView.isHidden = true
        mapView.attributionButton.isHidden = true
        
        return mapView
    }()
    
    fileprivate let settingsLabel: UILabel = {
        let label = UILabel()
        label.text = "To continue you will have to allow in Settings."
        label.font = .poppinsMedium(size: .makeWidth(14))
        label.textAlignment = .center
        label.setDimensions(height: .makeHeight(40), width: .makeWidth(400))
        return label
    }()
    
    fileprivate lazy var pastelButton: PastelButton = {
        let pastelButton = PastelButton(frame: .layoutRect(width: 170, height: 60, rectCenter: .centerX, padding: Padding(anchor: .top, padding: .makeHeight(680)), keepAspect: true), cornerRadius: .makeWidth(170) * 27/170, upperView: self.view, selector: #selector(askLocationPermission1))
        pastelButton.setTitle("Ask Permission", for: .normal)
        pastelButton.titleLabel?.font = .poppinsMedium(size: .makeWidth(18))
        pastelButton.background.backgroundColor = .greyColor()
        return pastelButton
    }()
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Adventure awaits, where are you?"
        label.font = .poppinsMedium(size: .makeWidth(25))
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.setWidth(.makeWidth(325))
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        return label
    }()
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pastelButton.pastelView.startAnimation()
//        pastelIcon.pastel.startAnimation()
    }
    
    @Published var authStatus: CLAuthorizationStatus = AccountInfo.locationStatus
    var cancellable = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        mapView.frame = view.frame
        view.addSubview(mapView)
        
        view.addSubview(pastelButton)
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: .makeHeight(70))
      
        
        $authStatus.sink { [weak self] status in
           
            switch status {
            case .notDetermined:
                return
            case .authorizedAlways:
                self?.nextController()
                self?.revertFromSettings()
            case .authorizedWhenInUse:
                self?.updateForAlwaysAuth()
                self?.revertFromSettings()
            default:
                self?.changeButtonToSettings()
            }
        }.store(in: &cancellable)
        
    }
    var didTrigger: Bool = false
    let locationManager = CLLocationManager()
    @objc func askLocationPermission1(){
        if didTrigger{
            if locationManager.authorizationStatus == .authorizedWhenInUse{
                locationManager.requestAlwaysAuthorization()
            }
        }else{
            if locationManager.authorizationStatus == .notDetermined{
                locationManager.requestWhenInUseAuthorization()
            }else if locationManager.authorizationStatus == .authorizedWhenInUse{
                locationManager.requestAlwaysAuthorization()
            }
            
            didTrigger = true
        }
    }
    
    func updateForAlwaysAuth(){
        mapView.showsUserLocation = true
        if let location = locationManager.location{
            let camera = MGLMapCamera(lookingAtCenter: location.coordinate, altitude: location.altitude, pitch: 69, heading: 0)
            mapView.setCamera(camera, animated: true)
        }
        UIView.transition(with: titleLabel, duration: 0.7, options: .transitionCrossDissolve) {
            self.titleLabel.text = "Now tap for always permission."
            self.pastelButton.background.alpha = 0.35
        }
    }
    
    
    
    func changeButtonToSettings(){
        DispatchQueue.main.async {
            self.view.addSubview(self.settingsLabel)
            self.settingsLabel.centerX(inView: self.view, topAnchor: self.view.topAnchor, paddingTop: .makeHeight(800))
            self.pastelButton.setTitle("Open Settings", for: .normal)
            self.pastelButton.background.removeGestureRecognizer(self.pastelButton.background.gestureRecognizers![0])
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openSettings))
            self.pastelButton.background.addGestureRecognizer(tapGesture)
        }
    }
    
    func revertFromSettings(){
        pastelButton.setTitle("Ask Permission", for: .normal)
        self.pastelButton.background.removeGestureRecognizer(self.pastelButton.background.gestureRecognizers![0])
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.askLocationPermission1))
        self.pastelButton.background.addGestureRecognizer(tapGesture)
    }
    
    func nextController(){
        
        if AccountInfo.contactsStatus == .authorized{
            let controller = AccountContacts()
            navigationController?.pushViewController(controller, animated: true)
        }else{
            let controller = AccountContactPerm()
            navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    @objc func openSettings(){
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {return}
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
        }
    }
    
    @objc func willEnterForeground(){
        pastelButton.pastelView.startAnimation()
//        pastelIcon.pastel.startAnimation()
    }
    
    
}
extension AccountLocationPerm1: MGLMapViewDelegate{
    
}


extension AccountLocationPerm1: CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authStatus = manager.authorizationStatus
        
//        switch manager.authorizationStatus{
//
//        case .notDetermined:
//            if didTrigger{
//                manager.requestWhenInUseAuthorization()
//            }
//        case .denied:
//            changeButtonToSettings()
//        case .authorizedWhenInUse:
//            updateForAlwaysAuth()
//        default:
//            print("AUTH STATUS: \(manager.authorizationStatus)")
//        }
    }
}
