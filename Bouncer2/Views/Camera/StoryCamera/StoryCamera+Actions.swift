//
//  StoryCamera+Actions.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/16/22.
//

import UIKit
import AVFoundation

import Combine

extension StoryCameraVC{
    
    @objc func didTakePhoto(sender: UIButton) {
        
        self.shutterButton.isEnabled = false
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.fromValue = .makeWidth(7) as CGFloat
        animation.toValue = .makeWidth(25) as CGFloat
        animation.duration = 0.3
        animation.autoreverses = true
        animation.repeatCount = 0
        sender.layer.add(animation, forKey: "shutterAnimation")
        
        
        let animationOpacity = CABasicAnimation(keyPath: "opacity")
        animationOpacity.toValue = 0.35
        animationOpacity.duration = 0.325
        sender.layer.add(animationOpacity, forKey: "shutterAnimationOpacity")
    
        let settings = AVCapturePhotoSettings()
        let flashMode: AVFoundation.AVCaptureDevice.FlashMode = self.flashIsActive ? .on : .off
        settings.flashMode = flashMode
        self.output.capturePhoto(with: settings, delegate: self)
        
        
        removeGestures()
    }
    
    func didGetPhoto(_ image: UIImage) {
        self.imageView.image = image
        image.getColors(quality: .high, { [weak self] colors in
            self?.continueButton.gradientColors = (colors, false)
        })
        
        UIView.transition(with: view, duration: 0.1, options: .transitionCrossDissolve) { [self]  in
            view.insertSubview(imageView, aboveSubview: cancelButton)
            view.addSubview(discardButton)
            view.addSubview(continueButton)
        }
    }
    
    
    @objc func didTakeVideo(gestureRecognizer: UILongPressGestureRecognizer) {

        var brightness: CGFloat?
        if gestureRecognizer.state == .began {
            removeGestures()
            buttonCanvas.isHidden = true
            flashButton.isHidden = true
            switchButton.isHidden = true
            cancelButton.isHidden = true
            debugPrint("long press started")
            //TODO: Unique URL is required
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
            let filePath = documentsURL.appendingPathComponent("tempMovie").appendingPathExtension("mov")
            
//            if FileManager.default.fileExists(atPath: filePath.absoluteString) {
                
                do {
                    try FileManager.default.removeItem(at: filePath)
                }
                catch {
                    print("StoryCameraVC 76 - Error: \(error)")
                }
//            }
            
            
            if self.flashIsActive == true && self.position == .front {
                view.addSubview(shutterView)
                brightness = UIScreen.main.brightness
                UIScreen.main.brightness = CGFloat(1.0)
            }else if self.flashIsActive == true{
                StoryCameraVC.setTorchMode(AVCaptureDevice.TorchMode.on, for: (currentCameraInput as! AVCaptureDeviceInput).device)
            }else{
                StoryCameraVC.setTorchMode(AVCaptureDevice.TorchMode.off, for: (currentCameraInput as! AVCaptureDeviceInput).device)
            }
            
            movieOutput.startRecording(to: filePath, recordingDelegate: self)
        }else if gestureRecognizer.state == .ended {
            debugPrint("longpress ended")
            movieOutput.stopRecording()
            buttonCanvas.isHidden = false
            flashButton.isHidden = false
            switchButton.isHidden = false
            cancelButton.isHidden = false
            StoryCameraVC.setTorchMode(AVCaptureDevice.TorchMode.off, for: (currentCameraInput as! AVCaptureDeviceInput).device)
            UIView.animate(withDuration: 0.3, animations: {
                self.shutterView.alpha = 0
            }, completion: { (_) in
                self.shutterView.removeFromSuperview()
                self.shutterView.alpha = 0.75
                UIScreen.main.brightness = brightness ?? 0.5
            })
        }
    }
    
    func didGetVideo(_ url: URL) {
        let videoVC = StoryVideoRecordingVC(url, shouldFlip: position == .front, eventId: eventID, hostId: hostID, messageDetail, type: type)
        navigationController?.pushViewController(videoVC, animated: false)
    }
    
    @objc func discardMedia(){
        shutterButton.isEnabled = true
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        imageView.image = nil
        self.imageView.removeFromSuperview()
        imageView.transform = CGAffineTransform.identity
        self.discardButton.removeFromSuperview()
        self.continueButton.removeFromSuperview()
        

        addGestures()
    }
}

