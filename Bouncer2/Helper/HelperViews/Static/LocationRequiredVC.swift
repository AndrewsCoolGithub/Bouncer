//
//  LocationRequiredVC.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/8/22.
//

import Foundation
import Mapbox
import UIKit

class LocationRequiredVC: UIViewController{
    
    private let mapView: MGLMapView = {
        let mapview = MGLMapView()
        mapview.automaticallyAdjustsContentInset = true
        mapview.attributionButton.isHidden = true
        mapview.logoView.isHidden = true
        mapview.styleURL = URL(string: "mapbox://styles/andrewkestler/ckvq4wiy91g9l14n1qc6qezxr")
        mapview.showsUserLocation = false
        mapview.isUserInteractionEnabled = false
        mapview.setCenter(CLLocationCoordinate2D(latitude: 33.5779, longitude: -101.8552), animated: false)
       
        return mapview
    }()
    
    private let header: UILabel = {
        let header = UILabel()
        header.text = "For Bouncer to work, change your"
        header.font = .poppinsMedium(size: 20)
        header.textColor = .white
        return header
    }()
    
    private let header2: UILabel = {
        let header = UILabel()
        header.text = "location settings"
        header.font = .poppinsMedium(size: 20)
        header.textColor = .white
        return header
    }()
    
    let image1 = UIImageView(image: UIImage(named: "LocationWarning1"))
    let image2 = UIImageView(image: UIImage(named: "LocationWarning2"))
    
    
    private let step1: UILabel = {
        let header = UILabel()
        header.text = "Tap the button at the bottom of this screen to open the Settings"
        header.font = .poppinsMedium(size: 14)
        header.setWidth(.makeWidth(340))
        header.numberOfLines = 2
        header.lineBreakMode = .byWordWrapping
        header.textColor = .white
        return header
    }()
    
    private let step2a: UILabel = {
        let header = UILabel()
        header.text = "Once in the Settings, tap on \"Location\""
        header.font = .poppinsMedium(size: 14)
        header.textColor = .white
        return header
    }()
    
    private let step2b: UILabel = {
        let header = UILabel()
        header.text = "And select \"Always\""
        header.font = .poppinsMedium(size: 14)
        header.textColor = .white
        return header
    }()
    
    private let step3: UILabel = {
        let header = UILabel()
        header.text = "Once you've done that, re-open Bouncer!"
        header.font = .poppinsMedium(size: 14)
        header.textColor = .white
        return header
    }()
    
    func createNumberView(_ number: Int) -> UIView{
        let view = UIView()
        view.backgroundColor = .blueMinty()
        view.setDimensions(height: .makeWidth(25), width: .makeWidth(25))
        view.layer.cornerRadius = .makeWidth(25) * 0.5
        let label = UILabel()
        label.text = "\(number)"
        label.font = .poppinsMedium(size: .makeWidth(16.5))
        label.textColor = .nearlyBlack()
        view.addSubview(label)
        label.center(inView: view)
        
        return view
    }
    
    private let bounceButton: UIButton = {
        let button = UIButton()
        button.setTitle("OPEN SETTINGS", for: .normal)
        button.titleLabel?.font = .poppinsMedium(size: .makeWidth(15))
        button.frame = CGRect(x: .makeWidth(414) + 200, y: .makeHeight(800), width: .makeWidth(140), height: .makeHeight(60))
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .blueMinty()
        button.layer.cornerRadius = .makeHeight(60) * 0.4
        button.alpha = 0
        
        return button
    }()
    
   
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.3, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 5, options: .allowUserInteraction, animations: {
            self.bounceButton.frame = CGRect(x: .makeWidth(137), y: .makeHeight(800), width: .makeWidth(140), height: .makeHeight(60))
            self.bounceButton.alpha = 0.8
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.frame = self.view.bounds
        
        view.backgroundColor = .greyColor()
        
        view.addSubview(header)
        header.anchor(left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: .makeWidth(10))
        header.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: .makeHeight(20))
        
        view.addSubview(header2)
        header2.anchor(left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: .makeWidth(10))
        header2.anchor(top: header.bottomAnchor, paddingTop: .makeHeight(10))
        
        view.addSubview(step1)
        step1.anchor(left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: .makeWidth(55))
        step1.anchor(top: header2.bottomAnchor, paddingTop: .makeHeight(40))
        
        let num1 = createNumberView(1)
        view.addSubview(num1)
        num1.anchor(left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: .makeWidth(10))
        num1.anchor(top: step1.topAnchor, paddingTop: -.makeHeight(0))
        
        view.addSubview(step2a)
        step2a.anchor(left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: .makeWidth(55))
        step2a.anchor(top: step1.bottomAnchor, paddingTop: .makeHeight(40))
        
        let num2 = createNumberView(2)
        view.addSubview(num2)
        num2.anchor(left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: .makeWidth(10))
        num2.centerYright(inView: step2a, rightAnchor: nil)
        
        view.addSubview(image1)
        image1.setDimensions(height: .makeHeight(46), width: .makeWidth(340))
        image1.anchor(left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: .makeWidth(55))
        image1.anchor(top: step2a.bottomAnchor, paddingTop: .makeHeight(15))
        
        view.addSubview(step2b)
        step2b.anchor(left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: .makeWidth(55))
        step2b.anchor(top: image1.bottomAnchor, paddingTop: .makeHeight(15))
        
        view.addSubview(image2)
        image2.setDimensions(height: .makeHeight(225), width: .makeWidth(340))
        image2.anchor(left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: .makeWidth(55))
        image2.anchor(top: step2b.bottomAnchor, paddingTop: .makeHeight(15))
        
        view.addSubview(step3)
        step3.anchor(left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: .makeWidth(55))
        step3.anchor(top: image2.bottomAnchor, paddingTop: .makeHeight(40))
        
        let num3 = createNumberView(3)
        view.addSubview(num3)
        num3.anchor(left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: .makeWidth(10))
        num3.centerYright(inView: step3, rightAnchor: nil)
        
        view.addSubview(bounceButton)
        view.bringSubviewToFront(bounceButton)
        bounceButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        bounceButton.addTarget(self, action: #selector(bounceAnimation(sender:)), for: .touchDown)
        bounceButton.addTarget(self, action: #selector(finishBouncerAnimation), for: .touchUpInside)
        bounceButton.addTarget(self, action: #selector(finishBouncerAnimation), for: .touchCancel)
        bounceButton.addTarget(self, action: #selector(finishBouncerAnimation), for: .touchDragExit)
        
        
    }
    
   
    
    @objc func openSettings(){
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {return}
       
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
        }
    }
    
    
    @objc func bounceAnimation(sender: UIButton){
        UIView.animate(withDuration: 0.4,
            animations: {
                self.bounceButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        })
    }
    
    @objc func finishBouncerAnimation(){
        UIView.animate(withDuration: 0.4, animations: {
            self.bounceButton.transform = CGAffineTransform.identity
        })
    }
}
