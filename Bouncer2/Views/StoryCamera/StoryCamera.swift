//
//  StoryCamera.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/15/22.
//

import Foundation
import AVFoundation
import YPImagePicker
import UIKit
import Photos
import Combine
import UIImageColors
import FirebaseStorage


class StoryCameraVC: UIViewController, UINavigationControllerDelegate {
   
    // Video Player
    var player: AVPlayer?
    
    // Video Player Layer
    var playerLayer: AVPlayerLayer?
    
    // Capture Session
    var session: AVCaptureSession?
    
    var currentCameraInput: AVCaptureInput!
    
    // Photo Output
    let output = AVCapturePhotoOutput()
    
    // Movie Output
    let movieOutput = AVCaptureMovieFileOutput()
    
    // Video Preview
    let previewLayer: AVCaptureVideoPreviewLayer = {
        let previewLayer = AVCaptureVideoPreviewLayer()
        previewLayer.videoGravity = .resizeAspectFill
        return previewLayer
    }()
    
    //Camera Position
    var position: AVCaptureDevice.Position! = .back
    
    
    
    // Shutter Button
    let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: .makeWidth(90), height: .makeWidth(90)))
        button.layer.cornerRadius = .makeWidth(39)
        button.layer.borderWidth = .makeWidth(7)
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
   
    
    //Switch Position Button
     let switchButton: CameraOptionButton = {
        let button = CameraOptionButton(frame: CGRect(x: 0, y: 0, width: .makeWidth(29), height: .makeHeight(35)))
        button.tintColor = .white
        button.setImage(UIImage(named: "CameraSwitch"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
     let flashButton: CameraOptionButton = {
        let button = CameraOptionButton(frame: CGRect(x: 0, y: 0, width: .makeWidth(29), height: .makeHeight(35)))
        button.tintColor = .white
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(35), weight: UIImage.SymbolWeight.light)
        button.setImage(UIImage(systemName: "bolt.slash.fill", withConfiguration: config), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
     let buttonCanvas: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: .makeWidth(55), height: .makeHeight(130)))
        view.backgroundColor = .init(red: 215/255, green: 215/255, blue: 215/255, alpha: 1)
        view.layer.compositingFilter = "multiplyBlendMode"
        view.layer.cornerRadius = .makeWidth(22.5)
        view.isUserInteractionEnabled = false
        return view
    }()
    
     let cancelButton: UIButton = {
        let xButton = UIButton(frame: CGRect(x: .makeWidth(15), y: .makeWidth(35), width: .makeWidth(36), height: .makeWidth(36)))
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(32))
        xButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        xButton.imageView?.contentMode = .center
        xButton.tintColor = .white
        return xButton
    }()
    
     let continueButton: UIButton = {
        let button = UIButton(frame: .layoutRect(width: 90, height: 50, padding: Padding(anchor: .bottom, .right, padding: .makeHeight(20), .makeWidth(15))), cornerRadius: .makeHeight(13.5), colors: UIImageColors.clear, lineWidth: 1, direction: .horizontal)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = .poppinsMedium(size: .makeHeight(20))
        button.layer.applySketchShadow(color: .black.withAlphaComponent(0.3), alpha: 1, x: 0, y: 3, blur: 6, spread: 4, withRounding: .makeHeight(13.5))
        button.backgroundColor = .greyColor()
        return button
    }()
    
     lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    
     let discardButton: UIButton = {
        let button = UIButton(frame: CGRect(x: .makeWidth(15), y: .makeWidth(35), width: .makeWidth(36), height: .makeWidth(36)))
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(32))
        button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        button.imageView?.contentMode = .center
        button.tintColor = .white
        return button
    }()
    
    let shutterView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: .makeWidth(414), height: .makeHeight(896)))
        view.backgroundColor = .white
        view.alpha = 0.75
        return view
    }()
    
    private let keepRecordingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: .makeWidth(90), height: .makeWidth(90)))
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(15))
        button.setImage(UIImage(systemName: "lock.fill"), for: .normal)
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
    
    var flashIsActive: Bool = false
    var gestures = Set<UIGestureRecognizer>()
    var eventID: String?
    init(eventID: String?){
        super.init(nibName: nil, bundle: nil)
        self.setUpCamera()
        self.eventID = eventID
       
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
        view.addSubview(cancelButton)
        view.addSubview(keepRecordingButton)
       
        switchButton.addTarget(self, action: #selector(switchCameraTapped), for: .touchUpInside)
        switchButton.addTarget(self, action: #selector(animateCameraOpt(sender:)), for: .touchUpInside)
        flashButton.addTarget(self, action: #selector(animateCameraOpt(sender:)), for: .touchUpInside)
        shutterButton.addTarget(self, action: #selector(didTakePhoto), for: .touchUpInside)
        let longPressGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(didTakeVideo(gestureRecognizer:)))
        shutterButton.addGestureRecognizer(longPressGesture)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        discardButton.addTarget(self, action: #selector(discardMedia), for: .touchUpInside)
        addGestures()
        
        continueButton.addTarget(self, action: #selector(post), for: .touchUpInside)
        
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
        previewLayer.frame = view.bounds
        shutterButton.center = CGPoint(x: view.frame.width/2, y: view.frame.height - .makeWidth(85))
        switchButton.center = CGPoint(x: view.frame.width * 0.9,
                                      y: (view.frame.height - view.safeAreaLayoutGuide.layoutFrame.height) / 2  + .makeHeight(56))
        buttonCanvas.center = CGPoint(x: view.frame.width * 0.9,
                                      y: (view.frame.height - view.safeAreaLayoutGuide.layoutFrame.height) / 2 + .makeHeight(86))
        flashButton.center = CGPoint(x: view.frame.width * 0.9 + 1,
                                     y: (view.frame.height - view.safeAreaLayoutGuide.layoutFrame.height) / 2  + .makeHeight(116))
        keepRecordingButton.center = CGPoint(x: view.frame.width/4 + .makeWidth(20), y: view.frame.height - .makeWidth(85))
        
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
        if let device = AVCaptureDevice.default(for: .video), let audioDevice = AVCaptureDevice.default(for: .audio) {
            do {
                
                let input = try AVCaptureDeviceInput(device: device)
                let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice)
                if session.canAddInput(input) {
                    currentCameraInput = input
                    session.addInput(input)
                }
                
                if session.canAddInput(audioDeviceInput){
                    session.addInput(audioDeviceInput)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                if session.canAddOutput(movieOutput){
                    session.addOutput(movieOutput)
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
    
    
    @objc func post(){
        let ref = STORY_REF.document()
        let storageRef = Storage.storage().reference().child("Stories").child(ref.documentID)
        
        Task{
            do{
                let url = try await MediaManager.uploadImage(self.imageView.image, path: storageRef)
                guard let uid = User.shared.id else {return}
                let story = Story(id: ref.documentID, eventId: self.eventID, userId: uid, url: url, type: .image, shouldMirror: false, date: .now, _storyViews: [])
                try StoryManager.shared.postStory(story, ref)
            }catch{
                print(error)
            }
        }
        
        guard let rootVC = navigationController?.viewControllers.first(where: {$0 is EventOverview}) else {return}
        navigationController?.popToViewController(rootVC, animated: true)
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
}
                    
extension StoryCameraVC: AVCapturePhotoCaptureDelegate{
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let cgImage = photo.cgImageRepresentation() else {return}
        guard let data = photo.fileDataRepresentation() else {return}
        
        let image: UIImage = self.position == .front ? UIImage(cgImage: cgImage, scale: 1, orientation: .leftMirrored) : UIImage(data: data)!
        removeGestures()
        didGetPhoto(image)
    }
}

extension StoryCameraVC: AVCaptureFileOutputRecordingDelegate{
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
       
        
        if error == nil {
            didGetVideo(outputFileURL)
        }
        

        return
    }
}

extension StoryCameraVC: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIControl {
            // we touched a button, slider, or other UIControl
            return false // ignore the touch
        }
        return true // handle the touch
    }
}

//class PlayVideoController: UIViewController {
//
//    var url: URL!
//    var player: AVPlayer!
////    var avPlayerLayer: AVPlayerLayer!
//
//    override func viewWillAppear(_ animated: Bool) {
//
//        if url != nil {
//
//
//            player = AVPlayer(url: url)
//            let playerLayer = AVPlayerLayer(player: player)
//            self.view.layer.addSublayer(playerLayer)
//            playerLayer.frame = self.view.frame
//            player.play()
//
//            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { [weak self] _ in
//                self?.player?.seek(to: CMTime.zero)
//                self?.player?.play()
//            }
//        }
//    }
//}
