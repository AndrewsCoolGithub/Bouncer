//
//  StoryVideoRecordingVC.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/19/22.
//

import UIKit
import AVFoundation
import FirebaseStorage
import UIImageColors

class StoryVideoRecordingVC: UIViewController{
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    lazy var foreground: UIView = {
        let view = UIView(frame: view.bounds)
        return view
    }()
    
    let discardButton: UIButton = {
       let button = UIButton()
       let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(32))
       button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
       button.imageView?.contentMode = .center
       button.tintColor = .white
       return button
   }()
    
    let continueButton: UIButton = {
       let button = UIButton(frame: .layoutRect(width: 90, height: 50, padding: Padding(anchor: .bottom, .right, padding: .makeHeight(20), .makeWidth(15))), cornerRadius: .makeHeight(13.5), colors: UIImageColors.clear, lineWidth: 1, direction: .horizontal)
       button.setTitle("Next", for: .normal)
       button.titleLabel?.font = .poppinsMedium(size: .makeHeight(20))
       button.layer.applySketchShadow(color: .black.withAlphaComponent(0.3), alpha: 1, x: 0, y: 3, blur: 6, spread: 4, withRounding: .makeHeight(13.5))
       button.backgroundColor = .greyColor()
       return button
   }()
    
    var url: URL!
    var shouldFlip: Bool!
    var eventId: String?
    var hostId: String?
    
    init(_ url: URL, shouldFlip: Bool, eventId: String?, hostId: String?){
        super.init(nibName: nil, bundle: nil)
        view.addSubview(foreground)
        self.shouldFlip = shouldFlip
        self.eventId = eventId
        self.hostId = hostId
        foreground.center = view.center
        self.url = url
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        foreground.layer.addSublayer(playerLayer)
        playerLayer.frame = foreground.frame
        player.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { [weak self] _ in
            self?.player.seek(to: CMTime.zero)
            self?.player.play()
        }
        
        view.addSubview(discardButton)
        discardButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: .wProportioned(15))
        discardButton.anchor(left: view.leftAnchor, paddingLeft: .makeWidth(15))
        discardButton.addTarget(self, action: #selector(discard), for: .touchUpInside)
        
        view.addSubview(continueButton)
        continueButton.addTarget(self, action: #selector(post), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func post(){
        let ref = STORY_REF.document()
        let storageRef = Storage.storage().reference().child("Stories").child(ref.documentID)
        Task{
            do{
                let url = try await MediaManager.uploadVideo(url, path: storageRef, shouldFlip: shouldFlip)
                guard let uid = User.shared.id else {return}
                let story = Story(id: ref.documentID, eventId: self.eventId, hostId: self.hostId, userId: uid, url: url, type: .video, shouldMirror: shouldFlip, date: .now, _storyViews: [])
                try StoryManager.shared.postStory(story, ref)
            }catch{
                print(error)
            }
        }
        
        guard let rootVC = navigationController?.viewControllers.first(where: {$0 is EventOverview}) else {return}
        player.pause()
        navigationController?.popToViewController(rootVC, animated: true)
    }
    
    @objc func discard(){
        navigationController?.popViewController(animated: true)
    }
}
