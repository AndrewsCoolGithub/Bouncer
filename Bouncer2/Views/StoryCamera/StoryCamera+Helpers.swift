//
//  StoryCamera+Helpers.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/16/22.
//

import AVFoundation

extension StoryCameraVC{
    
    class func setTorchMode(_ torchMode: AVCaptureDevice.TorchMode, for device: AVCaptureDevice) {
        if device.isTorchModeSupported(torchMode) && device.torchMode != torchMode {
            do
            {
                try device.lockForConfiguration()
                    device.torchMode = torchMode
                    device.unlockForConfiguration()
            }
            catch {
                print("Error:-\(error)")
            }
        }
    }
    
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: position)
        return discoverySession.devices.first
    }
    
    func adjustVideoMirror(){

       guard let currentCameraInput: AVCaptureDeviceInput = currentCameraInput as? AVCaptureDeviceInput else {return}

          if let conn = movieOutput.connection(with: .video){
              conn.isVideoMirrored = currentCameraInput.device.position == .front
          }
      }
}
