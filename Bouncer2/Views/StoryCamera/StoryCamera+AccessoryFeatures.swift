//
//  StoryCamera+AccessoryFeatures.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/16/22.
//

import UIKit
import AVFoundation

extension StoryCameraVC{
    @objc func switchCameraTapped(sender: Any?) {
        if (sender as? UITapGestureRecognizer != nil) {
            UIView.transition(with: self.switchButton as UIView, duration: 0.45, options: .transitionFlipFromRight, animations: {
                self.switchButton.setImage(UIImage(named: "CameraSwitch"), for: .normal)
            })
        }
        
        guard let currentCameraInput: AVCaptureInput = self.currentCameraInput else {return}
        //Indicate that some changes will be made to the session
        session?.beginConfiguration()
        session?.removeInput(currentCameraInput)
        

        //Get new input
        var newCamera: AVCaptureDevice! = nil
        if let input = currentCameraInput as? AVCaptureDeviceInput {
            if (input.device.position == .back) {
                newCamera = cameraWithPosition(position: .front)
                self.position = .front
            } else {
                newCamera = cameraWithPosition(position: .back)
                self.position = .back
            }
        }

        var newVideoInput: AVCaptureDeviceInput!
        do{
            newVideoInput = try? AVCaptureDeviceInput(device: newCamera)
            self.currentCameraInput = newVideoInput
            session?.addInput(newVideoInput)
        }
        
        session?.commitConfiguration()
        adjustVideoMirror()
    }
    
    
    
    
    
    @objc func didTapScreen(gesture: UITapGestureRecognizer){
        let location = gesture.location(in: view)

        
        let rippleLayer = RippleLayer()
        rippleLayer.rippleRadius = .makeWidth(55)
        rippleLayer.rippleColor = UIColor.white
        rippleLayer.repeatCount = 1
        rippleLayer.borderWidth = 8
        rippleLayer.position = location
        rippleLayer.setupRippleEffect()
       

        self.view.layer.addSublayer(rippleLayer)
        rippleLayer.startAnimation()
        
        let captureDeviceLocation = previewLayer.captureDevicePointConverted(fromLayerPoint: location)
        self.focus(at: captureDeviceLocation)
        
    }
    
    func focus(at point: CGPoint) {
        guard let device = (currentCameraInput as? AVCaptureDeviceInput)?.device,
        device.isFocusPointOfInterestSupported,
        device.isExposurePointOfInterestSupported else {return}

        do {
            try device.lockForConfiguration()
            device.focusPointOfInterest = point
            device.exposurePointOfInterest = point
            device.focusMode = .continuousAutoFocus
            device.exposureMode = .continuousAutoExposure
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
   
    @objc func didZoom(gesture: UIPinchGestureRecognizer){
        guard let device = (currentCameraInput as? AVCaptureDeviceInput)?.device else { return }
        
        let zoom = device.videoZoomFactor * gesture.scale
        gesture.scale = 1
        
        do{
            try device.lockForConfiguration()
            defer { device.unlockForConfiguration() }
            
            if zoom >= device.minAvailableVideoZoomFactor && zoom <= device.maxAvailableVideoZoomFactor {
                device.videoZoomFactor = zoom * 1
            }else{
                print("Unable to set videoZoom: (max \(device.activeFormat.videoMaxZoomFactor), asked \(zoom)")
            }
        }catch{
            print("Unable to set videoZoom: \(error.localizedDescription)")
        }
    }
    
   
    @objc func animateCameraOpt(sender: UIButton){
        switch sender == self.flashButton{
        case true:
            
            guard (flashIsActive) else {
                
                UIView.transition(with: sender as UIView, duration: 0.45, options: .transitionFlipFromRight, animations: {
                    let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(35), weight: UIImage.SymbolWeight.light)
                    sender.setImage(UIImage(systemName: "bolt.fill", withConfiguration: config), for: .normal)})
                
                self.flashIsActive = true
                return
            }
            
           
            UIView.transition(with: sender as UIView, duration: 0.45, options: .transitionFlipFromRight, animations: {
                let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(35), weight: UIImage.SymbolWeight.light)
                sender.setImage(UIImage(systemName: "bolt.slash.fill", withConfiguration: config), for: .normal)})
            
            self.flashIsActive = false
            
        case false:
            
            UIView.transition(with: sender as UIView, duration: 0.45, options: .transitionFlipFromRight, animations: {
                self.switchButton.setImage(UIImage(named: "CameraSwitch"), for: .normal)
            })
        }
    }
}
