//
//  AccountCameraPerm.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/17/22.
//

import Foundation
import Photos
import UIKit

final class AccountCameraPerm: UIViewController{
   
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "It's time for a profile picture, tap to allow camera roll permissions."
        label.font = .poppinsMedium(size: .makeWidth(20))
        label.setWidth(.makeWidth(360))
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        return label
    }()
    
    fileprivate lazy var pastelButton: PastelButton = {
        let pastelButton = PastelButton(frame: .layoutRect(width: 170, height: 60, rectCenter: .centerX, padding: Padding(anchor: .top, padding: .makeHeight(680)), keepAspect: true), cornerRadius: .makeWidth(170) * 27/170, upperView: self.view, selector: #selector(askCameraRollPermission))
        pastelButton.setTitle("Ask Permission", for: .normal)
        pastelButton.titleLabel?.font = .poppinsMedium(size: .makeWidth(18))
        pastelButton.background.backgroundColor = .greyColor()
        return pastelButton
    }()
    
    fileprivate let pastelIcon: PastelIcon = {
        let pastelIcon = PastelIcon(frame: .layoutRect(width: 200, height: 210, rectCenter: .center), colors: User.shared.colors.uiColors(), symbolName: "camera.circle.fill", backgroundColor: .greyColor())
        return pastelIcon
    }()
        
    fileprivate let settingsLabel: UILabel = {
        let label = UILabel()
        label.text = "To continue you will have to allow in Settings."
        label.font = .poppinsMedium(size: .makeWidth(14))
        label.textAlignment = .center
        label.setDimensions(height: .makeHeight(40), width: .makeWidth(400))
        return label
    }()
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pastelButton.pastelView.startAnimation()
        pastelIcon.pastel.startAnimation()
        
        let status = AccountInfo.cameraRollStatus
        if status == .authorized || status == .limited {
            self.nextController()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .greyColor()
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: .makeHeight(70))
        view.addSubview(pastelButton)
        view.addSubview(pastelIcon)
        
        if AccountInfo.cameraRollStatus == .denied {
            self.modifyButton()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func askCameraRollPermission(){
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized || status == .limited{
                DispatchQueue.main.async {
                    self.nextController()
                }
               
            } else {
                DispatchQueue.main.async {
                    self.modifyButton()
                }
            }
        }
    }
        
    func modifyButton(){
        DispatchQueue.main.async {
            self.view.addSubview(self.settingsLabel)
            self.settingsLabel.centerX(inView: self.view, topAnchor: self.view.topAnchor, paddingTop: .makeHeight(800))
            self.pastelButton.setTitle("Open Settings", for: .normal)
            self.pastelButton.background.removeGestureRecognizer(self.pastelButton.background.gestureRecognizers![0])
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openSettings))
            self.pastelButton.background.addGestureRecognizer(tapGesture)
        }
    }
        
    func nextController(){
        let controller = AccountPicture()
        navigationController?.pushViewController(controller, animated: true)
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
        pastelIcon.pastel.startAnimation()
    }
}
