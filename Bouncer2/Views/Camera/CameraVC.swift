//
//  CameraVC.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/26/22.
//

import Foundation
import AVFoundation
import YPImagePicker
import UIKit
import Photos
import UIImageColors
class CameraVC: UIViewController, UINavigationControllerDelegate {
    
    // Capture Session
    var session: AVCaptureSession?
    
    // Photo Output
    let output = AVCapturePhotoOutput()
    
    // Video Preview
    let previewLayer: AVCaptureVideoPreviewLayer = {
        let previewLayer = AVCaptureVideoPreviewLayer()
        previewLayer.videoGravity = .resizeAspectFill
        return previewLayer
    }()
    
    //Camera Position
    var position: AVCaptureDevice.Position! = .back
    
    
    
    // Shutter Button
    private let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: .makeWidth(90), height: .makeWidth(90)))
        button.layer.cornerRadius = .makeWidth(39)
        button.layer.borderWidth = .makeWidth(7)
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    //Switch Position Button
    private let switchButton: CameraOptionButton = {
        let button = CameraOptionButton(frame: CGRect(x: 0, y: 0, width: .makeWidth(29), height: .makeHeight(35)))
        button.tintColor = .white
        button.setImage(UIImage(named: "CameraSwitch"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let flashButton: CameraOptionButton = {
        let button = CameraOptionButton(frame: CGRect(x: 0, y: 0, width: .makeWidth(29), height: .makeHeight(35)))
        button.tintColor = .white
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(35), weight: UIImage.SymbolWeight.light)
        button.setImage(UIImage(systemName: "bolt.slash.fill", withConfiguration: config), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let buttonCanvas: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: .makeWidth(55), height: .makeHeight(130)))
        view.backgroundColor = .init(red: 215/255, green: 215/255, blue: 215/255, alpha: 1)
        view.layer.compositingFilter = "multiplyBlendMode"
        view.layer.cornerRadius = .makeWidth(22.5)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let cameraRollButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: .makeWidth(60), height: .makeHeight(50)))
        button.tintColor = .white
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(32))
        button.setImage(UIImage(systemName: "photo.on.rectangle.angled", withConfiguration: config), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let cancelButton: UIButton = {
        let xButton = UIButton(frame: CGRect(x: .makeWidth(15), y: .makeWidth(35), width: .makeWidth(36), height: .makeWidth(36)))
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(32))
        xButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        xButton.imageView?.contentMode = .center
        xButton.tintColor = .white
        return xButton
    }()
    
    fileprivate let continueButton: UIButton = {
        let button = UIButton(frame: .layoutRect(width: 90, height: 50, padding: Padding(anchor: .bottom, .right, padding: .makeHeight(20), .makeWidth(15))), cornerRadius: .makeHeight(13.5), colors: UIImageColors.clear, lineWidth: 1, direction: .horizontal)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = .poppinsMedium(size: .makeHeight(20))
        button.layer.applySketchShadow(color: .black.withAlphaComponent(0.3), alpha: 1, x: 0, y: 3, blur: 6, spread: 4, withRounding: .makeHeight(13.5))
        button.backgroundColor = .greyColor()
        return button
    }()
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    
    fileprivate let discardButton: UIButton = {
        let button = UIButton(frame: CGRect(x: .makeWidth(15), y: .makeWidth(35), width: .makeWidth(36), height: .makeWidth(36)))
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(32))
        button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        button.imageView?.contentMode = .center
        button.tintColor = .white
        return button
    }()
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let session = session {
            DispatchQueue.global().async {
                session.startRunning()
            }
        }
    }
    var gestures = Set<UIGestureRecognizer>()
    weak var currentVC: CurrentVC?
    init(currentVC: CurrentVC? = nil){
        super.init(nibName: nil, bundle: nil)
        self.setUpCamera()
        self.currentVC = currentVC
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        view.addSubview(buttonCanvas)
        view.addSubview(switchButton)
        view.addSubview(flashButton)
        view.addSubview(cameraRollButton)
        view.addSubview(cancelButton)
        

       
        switchButton.addTarget(self, action: #selector(switchCameraTapped), for: .touchUpInside)
        switchButton.addTarget(self, action: #selector(animateCameraOpt(sender:)), for: .touchUpInside)
        
        cameraRollButton.addTarget(self, action: #selector(openCameraRoll), for: .touchUpInside)
        flashButton.addTarget(self, action: #selector(animateCameraOpt(sender:)), for: .touchUpInside)
        shutterButton.addTarget(self, action: #selector(didTakePhoto), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        addGestures()
        
    }
    
    func addGestures(){
        //Pinch
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(didZoom(gesture:)))
        self.view.addGestureRecognizer(pinch)
       
        
        // Single Tap
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(didTapScreen(gesture:)))
        singleTap.delegate = self
        singleTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTap)
       

        // Double Tap
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(switchCameraTapped))
       
        doubleTap.delegate = self
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)

        singleTap.require(toFail: doubleTap)
        singleTap.delaysTouchesBegan = true
        doubleTap.delaysTouchesBegan = true
        
        gestures.update(with: pinch)
        gestures.update(with: singleTap)
        gestures.update(with: doubleTap)
    }
    
    func removeGestures(){
        gestures.forEach({view.removeGestureRecognizer($0)})
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("DID LAYOUT")
        previewLayer.frame = view.bounds
        shutterButton.center = CGPoint(x: view.frame.width/2, y: view.frame.height - .makeWidth(85))

        switchButton.center = CGPoint(x: view.frame.width * 0.9,
                                      y: (view.frame.height - view.safeAreaLayoutGuide.layoutFrame.height) / 2  + .makeHeight(56))
        
        buttonCanvas.center = CGPoint(x: view.frame.width * 0.9,
                                      y: (view.frame.height - view.safeAreaLayoutGuide.layoutFrame.height) / 2 + .makeHeight(86))

        flashButton.center = CGPoint(x: view.frame.width * 0.9 + 1,
                                     y: (view.frame.height - view.safeAreaLayoutGuide.layoutFrame.height) / 2  + .makeHeight(116))
        
        cameraRollButton.center = CGPoint(x: .makeWidth(90), y: view.frame.height - .makeWidth(85))
        
    }
    
    private func checkCameraPermissions () {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
        // Request
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard granted else {return}
            DispatchQueue.main.async{
                self?.setUpCamera()
            }
        }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }
    
    private func setUpCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                
                let input = try AVCaptureDeviceInput (device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                
                previewLayer.session = session
                DispatchQueue.global().async {
                    session.startRunning()
                }
               
                self.session = session
            }catch{
                print(error)
            }
        }
    }
    
   
   // var isChanging: Bool = false
    @objc func switchCameraTapped(sender: Any?) {
        if (sender as? UITapGestureRecognizer != nil) {
            UIView.transition(with: self.switchButton as UIView, duration: 0.45, options: .transitionFlipFromRight, animations: {
                self.switchButton.setImage(UIImage(named: "CameraSwitch"), for: .normal)
            })
        }
        
        guard let currentCameraInput: AVCaptureInput = session?.inputs.first else {return}
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
            session?.addInput(newVideoInput)
        }
        
        session?.commitConfiguration()
    }
    
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: position)
        return discoverySession.devices.first
    }
    
    @objc private func didTakePhoto(sender: UIButton) {
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
    
    @objc private func didTapScreen(gesture: UITapGestureRecognizer){
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
        guard let device = (session?.inputs.first as? AVCaptureDeviceInput)?.device,
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
   
    
    @objc private func didZoom(gesture: UIPinchGestureRecognizer){
        guard let device = (session?.inputs.first as? AVCaptureDeviceInput)?.device else { return }
        
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
    
    
    @objc private func toggleFlash(sender: UIButton){
        //TODO: Flash on shutter tap
        
    }
    
    
    var flashIsActive: Bool = false
    @objc private func animateCameraOpt(sender: UIButton){
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
    
    
    @objc func openCameraRoll(){
      let picker = UIImagePickerController()
        present(picker, animated: true)
        picker.delegate = self
        
       
    }
    
   
    @objc func cancel(){
        navigationController?.popViewController(animated: true)
        DispatchQueue.global().async {
            self.session?.stopRunning()
            
            DispatchQueue.global().async {
                self.session?.startRunning()
            }
        }
    }
    
   
    
    fileprivate func didGetPhoto(_ image: UIImage) {
        self.imageView.image = image
        image.getColors(quality: .high, { [weak self] colors in
            EventCreationVC.colors = colors
            self?.continueButton.gradientColors = colors
        })
        UIView.transition(with: view, duration: 0.1, options: .transitionCrossDissolve) { [self]  in
            view.insertSubview(imageView, aboveSubview: cancelButton)
            view.addSubview(continueButton)
            view.addSubview(discardButton)
        }
        
        
        discardButton.addTarget(self, action: #selector(discardImage), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(trigger), for: .touchUpInside)
    }
    
    @objc func discardImage(){
        shutterButton.isEnabled = true
        self.imageView.removeFromSuperview()
        self.discardButton.removeFromSuperview()
        self.continueButton.removeFromSuperview()
        addGestures()
    }
    
    @objc func trigger(){
        session?.stopRunning()
        guard let image = imageView.image else {return}
        self.openEventCreation(image)
    }
    
    func openEventCreation(_ image: UIImage){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.discardImage()
        }
        
        let currentVC: CurrentVC = currentVC != nil ? currentVC! :
        CurrentVC(type: .eventTitle, controller: EventTitleSelect(), previous: nil)
        
        let colors: UIImageColors = EventCreationVC.colors != nil ? EventCreationVC.colors! : UIImageColors(background: .white, primary: .white, secondary: .white, detail: .white)
        
        EventCreationVC.setup(currentVC, image: image, colors: colors)
       
        if !(navigationController?.topViewController is EventCreationVC){
            addGestures()
            
            guard let eventCreationVC = navigationController?.viewControllers.first(where: {$0 is EventCreationVC}) else {
                navigationController?.pushViewController(EventCreationVC.shared, animated: true)
                return
            }
            
           navigationController?.popToViewController(eventCreationVC, animated: true)
        }
        
    }
}

extension CameraVC: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            picker.dismiss(animated: true)
            session?.stopRunning()
            removeGestures()
            didGetPhoto(image)
        }
    }
}
                    
extension CameraVC: AVCapturePhotoCaptureDelegate{
    
   
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let cgImage = photo.cgImageRepresentation() else {return}
        guard let data = photo.fileDataRepresentation() else {return}
        
        let image: UIImage = self.position == .front ? UIImage(cgImage: cgImage, scale: 1, orientation: .leftMirrored) : UIImage(data: data)!
        removeGestures()
        //session?.stopRunning()
        
        didGetPhoto(image)
       
        
        
        //openEventCreation(image)
    }
}

extension CameraVC: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIControl {
            // we touched a button, slider, or other UIControl
            return false // ignore the touch
        }
        return true // handle the touch
    }
}

class CameraOptionButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            return bounds.insetBy(dx: -10, dy: -10).contains(point)
    }
}
