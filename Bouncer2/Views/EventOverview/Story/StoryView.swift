//
//  StoryView.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/26/22.
//

import AVFoundation
import UIKit
import NVActivityIndicatorView

class StoryView: UIViewController, SkeletonLoadable {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var story: Story!
    var event: Event!
    var seen: Bool!
    var pauseGesture: UILongPressGestureRecognizer!
    init(story: Story, event: Event?){
        super.init(nibName: nil, bundle: nil)
        self.view.isUserInteractionEnabled = false
        self.view.frame = CGRect(x: 0, y: 0, width: .makeWidth(414), height: .makeHeight(896))
        self.story = story
        self.event = event
        view.addSubview(imageView)
        imageView.backgroundColor = .greyColor()
        switch story.type{
        case .image:
            view.addSubview(indicator)
            indicator.startAnimating()
            imageView.sd_setImage(with: URL(string: story.url)) { [weak self] i, e, c, u in
                self?.indicator.stopAnimating()
                self?.indicator.removeFromSuperview()
            }
        case .video:
            view.addSubview(indicator)
            indicator.startAnimating()
            downloadVideo(story.url) { [weak self]  in
                DispatchQueue.main.async {
                    self?.indicator.stopAnimating()
                    self?.indicator.removeFromSuperview()
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self?.player?.currentItem, queue: .main) { [weak self] _ in
                        self?.player?.seek(to: CMTime.zero)
                        self?.player?.play()
                    }
                }
            }
        }
        
        setupProfileData(story, event: event)
    }
    
    @objc func deleteStory(){
        guard let uid = User.shared.id, let storyId = story.id else {return}
        guard story.userId == uid || story.hostId == uid else {return}
        StoryManager.shared.delete(storyId)
    }
    
    private func downloadVideo(_ url: String, _ completion: @escaping() -> Void){
        downloadVideoFromUrl { isDone in
            if isDone{
                return completion()
            }
        }
    }
    
    var loaderDelegate: VideoLoaderDelegate!
    private func downloadVideoFromUrl(completion: @escaping (_ isDone: Bool) -> Void) {
        loaderDelegate = VideoLoaderDelegate(withURL: URL(string: self.story.url)!)
        loaderDelegate.id = self.story.id
        if let loaderDelegate = self.loaderDelegate, let assetUrl = loaderDelegate.streamingAssetURL {
            let videoAsset = AVURLAsset(url: assetUrl)
            videoAsset.resourceLoader.setDelegate(loaderDelegate, queue: DispatchQueue.global())
            loaderDelegate.completion = { localFileURL in
                if let localFileURL = localFileURL {
                    self.setupPlayer(localFileURL)
                } else {
                    print("Failed to download video file")
                }
                completion(true)
            }
            let playerItem = AVPlayerItem(asset: videoAsset)
            // This AVPlayer object is to tirgger AVAssetResourceLoaderDelegate. We are not using this player object anywhere else
            let player = AVPlayer(playerItem: playerItem)
            player.isMuted = true
        } else {
            completion(true)
        }
    }
    
    func setupPlayer(_ url: URL){
       player = AVPlayer(url: url)
       playerLayer = AVPlayerLayer(player: player)
       playerLayer.frame = self.imageView.bounds
       imageView.layer.addSublayer(self.playerLayer)
    }
    
    public func pause(_ state: UILongPressGestureRecognizer.State){
        if state == .began || state == .changed {
            if !viewIsFaded{
                fadeOut()
                player?.pause()
            }
        }else{
            if viewIsFaded{ fadeIn() }
            player?.play()
            return
        }
    }
    
    var viewIsFaded: Bool = false
    public func fadeIn(){
        self.viewIsFaded = false
        UIView.transition(with: self.view, duration: 0.35, options: [.transitionCrossDissolve, .curveEaseIn, .allowUserInteraction]) {
            self.userProfileImage.alpha = 1
            self.nameLabel.alpha = 1
            self.subLabel.alpha = 1
            self.ellipsis.alpha = 1
        }
    }
    
    public func fadeOut(){
        self.viewIsFaded = true
        UIView.transition(with: self.view, duration: 0.35, options: [.transitionCrossDissolve, .curveEaseOut, .allowUserInteraction]) {
            self.userProfileImage.alpha = 0
            self.nameLabel.alpha = 0
            self.subLabel.alpha = 0
            self.ellipsis.alpha = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let id = User.shared.id else {return}
        if !story.storyViews.contains(where: {$0.uid == id}) && seen == false{
            story.logView()
            seen = true
        }
        
        player?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.player?.seek(to: CMTime.zero)
        self.player?.pause()
    }
    
    fileprivate func setupProfileData(_ story: Story, event: Event?) {
        view.addSubview(userProfileImage)
        userProfileImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: .wProportioned(10))
        userProfileImage.anchor(left: view.leftAnchor, paddingLeft: .makeWidth(10))
        profileSkeletonGradient.frame = CGRect(x: 0, y: 0, width: .makeWidth(70), height: .makeWidth(70))
    
        view.addSubview(nameLabel)
        nameLabel.anchor(top: userProfileImage.topAnchor, paddingTop: .wProportioned(10))
        nameLabel.anchor(left: userProfileImage.rightAnchor, paddingLeft: .makeWidth(15))
        
        view.addSubview(subLabel)
        subLabel.anchor(bottom: userProfileImage.bottomAnchor, paddingBottom: .wProportioned(10))
        subLabel.anchor(left: userProfileImage.rightAnchor, paddingLeft: .makeWidth(15))
        
        
        
        
        Task{
            guard let user = await story.userId.getUser() else {return}
            userProfileImage.layer.addSublayer(profileSkeletonGradient)
            userProfileImage.sd_setImage(with: URL(string: user.image_url)) { [weak self] i, e, c, u in
                self?.profileSkeletonGradient.removeFromSuperlayer()
            }
            
            if let event = event {
                nameLabel.text = event.title
                subLabel.text = "\(story.date.timeIntervalSinceNow.timeInSmallUnits) ago by \(user.display_name.capitalized)"
            }else{
                nameLabel.text = user.display_name
                subLabel.text = "\(story.date.timeIntervalSinceNow.timeInSmallUnits) ago"
            }
        }
    
    }
    
    var player: AVPlayer?
    private var playerLayer: AVPlayerLayer!
    var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: .makeWidth(414), height: .makeHeight(896)))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let indicator: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: .layoutRect(width: 414, height: 896, rectCenter: .center), type: .ballPulseSync, color: .white, padding: 150)
        view.backgroundColor = .black.withAlphaComponent(0.2)
        return view
    }()
    
     let userProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.setDimensions(height: .makeWidth(70), width: .makeWidth(70))
        imageView.layer.cornerRadius = .makeWidth(35)
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var profileSkeletonGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        let animation = makeAnimationGroup()
        animation.beginTime = 0.0
        gradient.add(animation, forKey: "backgroundColor")
      
        return gradient
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.setWidth(.makeWidth(210))
        label.font = .poppinsMedium(size: .makeWidth(17))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.setWidth(.makeWidth(270))
        label.font = .poppinsMedium(size: .makeWidth(14))
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.minimumScaleFactor = 0.75
        return label
    }()
    
    private let ellipsis: UIButton = {
        let ellipsis = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: .wProportioned(35))
        let image = UIImage(systemName: "ellipsis", withConfiguration: config)
        ellipsis.setImage(image, for: .normal)
        ellipsis.tintColor = .white
        return ellipsis
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
