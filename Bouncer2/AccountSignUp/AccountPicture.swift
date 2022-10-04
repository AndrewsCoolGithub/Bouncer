//
//  AccountPicture.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/18/22.
//

import Foundation
import Photos
import NVActivityIndicatorView
import UIKit

class AccountPicture: UIViewController, UINavigationControllerDelegate{
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose your profile picture"
        label.font = .poppinsMedium(size: .makeWidth(25))
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.setWidth(.makeWidth(325))
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        return label
    }()
    
    var image: UIImage?
    
    fileprivate lazy var pastelButton: PastelButton = {
        let pastelButton = PastelButton(frame: .layoutRect(width: 170, height: 60, rectCenter: .centerX, padding: Padding(anchor: .top, padding: .makeHeight(680)), keepAspect: true), cornerRadius: .makeWidth(170) * 27/170, upperView: self.view, selector: #selector(nextButtonTapped))
        pastelButton.setTitle("Next", for: .normal)
        pastelButton.titleLabel?.font = .poppinsMedium(size: .makeWidth(18))
        pastelButton.background.backgroundColor = .greyColor()
       
        return pastelButton
    }()
    
    fileprivate let indicator: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: .layoutRect(width: 414, height: 896, rectCenter: .center), type: .ballPulseSync, color: .white, padding: 150)
        view.backgroundColor = .black.withAlphaComponent(0.2)
        return view
    }()
    
    fileprivate lazy var pastelProfileButton: PastelButton = {
        let pastelButton = PastelButton(frame: .layoutRect(width: 190, height: 190, rectCenter: .centerX, padding: Padding(anchor: .top, padding: .makeHeight(170)), keepAspect: true), cornerRadius: .makeWidth(76), upperView: self.view, selector: #selector(selectPhoto))
        pastelButton.background.backgroundColor = .greyColor()
        pastelButton.background.contentMode = .center
        pastelButton.background.tintColor = .white
        pastelButton.setImage(UIImage(systemName: "person.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: .makeWidth(55))), for: .normal)
        
        return pastelButton
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pastelButton.pastelView.startAnimation()
        pastelProfileButton.pastelView.startAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        indicator.stopAnimating()
        indicator.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        view.backgroundColor = .greyColor()
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: .makeHeight(70))
        view.addSubview(pastelProfileButton)
        view.addSubview(pastelButton)
      
    }
    
    @objc func nextButtonTapped(){
        guard let image = image else {
            pastelProfileButton.shake()
            return
        }
        
        Task{
            do{
                indicator.startAnimating()
                view.addSubview(indicator)
                try await AccountInfo.process(input: image, .uploadPicture)
               // nextController()
            }catch{
                print("Error uploading image, \(error.localizedDescription)")
                showMessage(withTitle: "Error", message: "Couldn't upload image at this time")
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
    
    @objc func willEnterForeground(){
        pastelButton.pastelView.startAnimation()
        pastelProfileButton.pastelView.startAnimation()
    }
    
    fileprivate func updateButtonFill(){
        if image != nil{
            UIView.transition(with: pastelButton.background, duration: 0.7, options: .allowUserInteraction) {
                self.pastelButton.background.alpha = 0.35
            }
        }else{
            UIView.transition(with: pastelButton.background, duration: 0.7, options: .allowUserInteraction) {
                self.pastelButton.background.alpha = 1
            }
        }
    }
    
    @objc func selectPhoto(){
        let imagePicker = UIImagePickerController()
        present(imagePicker, animated: true)
        imagePicker.delegate = self
    }
    
}
extension AccountPicture: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            picker.dismiss(animated: true)
            self.image = image
            pastelProfileButton.background.contentMode = .scaleAspectFill
            pastelProfileButton.setTitle(nil, for: .normal)
            pastelProfileButton.setImage(image, for: .normal)
            
        }
        updateButtonFill()
    }
}
