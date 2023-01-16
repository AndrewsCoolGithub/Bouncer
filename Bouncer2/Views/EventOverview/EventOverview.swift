//
//  EventOverview.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/11/22.
//

import UIKit

enum AnimationState{
    case end
    case reverse
}

class EventOverview: UIViewController{
    
    var viewModel: EventOverviewViewModel!
    var storyModel: EventOverviewStoryModel!
    var headerView: EventOverviewHeader!
    var contentView: EventOverviewContent!
    var animator: UIViewPropertyAnimator?
    var panGesture: UIPanGestureRecognizer!
    var storyVC: StoryViewController!
    var state: AnimationState = .end
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
   
    
    var hideStatusBar: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    override var prefersStatusBarHidden: Bool {
           return hideStatusBar
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        let openStoryGesture = UITapGestureRecognizer(target: self, action: #selector(openStory))
        headerView.components.storyView.addGestureRecognizer(openStoryGesture)
        headerView.components.backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        headerView.components.shareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
        headerView.components.cameraButton.addTarget(self, action: #selector(addStory), for: .touchUpInside)
        headerView.isUserInteractionEnabled = true
        
        let eventImageView = headerView.components.eventImageView
        view.insertSubview(contentView, belowSubview: headerView)
        contentView.backgroundColor = .cyan
        contentView.centerX(inView: view, topAnchor: eventImageView.bottomAnchor)
        let eventImageViewHeight = eventImageView.frame.height
        let screenHeight = UIScreen.main.bounds.height
        print(screenHeight)
        print(screenHeight - eventImageViewHeight)
        contentView.setDimensions(height: screenHeight - eventImageViewHeight,
                                  width: .makeWidth(414))
        contentView.components.guestsCV.setDimensions(height: screenHeight - eventImageViewHeight,
                                                      width: .makeWidth(414))
        contentView.components.guestsCV.delegate = self
        contentView.setupView()
        darkView = UIView()
        darkView.frame = view.bounds
       
    }
    
   
    @objc func openStory(_ sender: UITapGestureRecognizer){
        guard !storyModel.stories.isEmpty else {return}
        storyVC = StoryViewController(storyModel.views, startIndex: storyModel.currentIndex, event: viewModel.event)
        view.addSubview(darkView)
       
        darkView.backgroundColor = .black
        
        storyVC.view.layer.cornerRadius = 0
        storyVC.view.layer.masksToBounds = true
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))

        let pagingPan = storyVC.pageVC.gestureRecognizers
            pagingPan.forEach({ panGesture.require(toFail: $0)})
       //////////
        storyVC.view.addGestureRecognizer(panGesture)
        storyVC.modalPresentationStyle = .overFullScreen
        navigationController?.present(storyVC, animated: true)
        
        UIView.animate(withDuration: 0.3){ [unowned self] in
            hideStatusBar = true
            headerView.components.backButton.frame.origin.y -= 20
            headerView.components.eventTitle.frame.origin.y -= 20
            headerView.components.shareButton.frame.origin.y -= 20
        }
    }
    
    @objc func openStoryAnimation(_ sender: UILongPressGestureRecognizer){
        guard let imageView = sender.view else {return}
        let cameraButton = headerView.components.cameraButton
        
        if sender.state == .began{
            UIView.animate(withDuration: 0.3) {
                cameraButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                imageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
        }
        
        if sender.state == .cancelled || sender.state == .failed || sender.state == .ended {
            UIView.animate(withDuration: 0.15) {
                cameraButton.transform = CGAffineTransform.identity
                imageView.transform = CGAffineTransform.identity
            }
        }
    }
    
    @objc func addStory(){
        let storyCameraVC = StoryCameraVC(eventID: viewModel.event.id)
        navigationController?.pushViewController(storyCameraVC, animated: true)
    }
    
    @objc func share(){
        print("Share event")
    }
    
    @objc func dismissView(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func pan(_ sender: UIPanGestureRecognizer){

        let state = sender.state
        let translation = sender.translation(in: view.superview)
        switch state{
        case .began:
            startPanning()
        case .changed:
            
            scrub(translation: translation)
        case .ended:
            let velocity = sender.velocity(in: self.view.superview)
            endAnimation(translation: translation, velocity: velocity)

        default:
            print("Something went wrong")
        }
    }
    
    var darkView: UIView!
    var animator2: UIViewPropertyAnimator?
    func startPanning() {
       
        darkView.alpha = 1
        self.storyVC.view.frame.size = CGSize(width: .makeWidth(414), height: .makeHeight(896))
        self.storyVC.view.layer.cornerRadius = 0
        animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.8, animations: {
            self.darkView.alpha = 0.8
            self.storyVC.view.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.width)
            self.storyVC.view.center = self.view.center
            self.storyVC.view.layer.cornerRadius = self.view.frame.width/2
        })
        animator2 = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.8, animations: {
            self.storyVC.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.darkView.alpha = 0.1
        })
    }
    
    func scrub(translation: CGPoint) {
        if let animator = self.animator {
            let yTranslation = self.view.center.y + translation.y

            var progress: CGFloat = 0
            progress = (yTranslation / self.view.center.y) - 1
            
            if let animate2 = self.animator2, progress >= 0.1{
                animate2.fractionComplete = max(0.0001, min(0.9999, progress * 2))
            }
            
            progress = max(0.0001, min(0.9999, progress * 10))
            
           

            animator.fractionComplete = progress
        }
    }
    
    func endAnimation(translation: CGPoint, velocity: CGPoint) {
       
        if velocity.y >= 135 {
            state = .end
        }else{
            state = .reverse
        }
        
        switch state {
        case .end:
           
            darkView.removeFromSuperview()
            panGesture.isEnabled = false
            
            
           
            storyVC.dismiss(animated: false) { [weak self] in //Story
               
                self?.panGesture.isEnabled = true
                self?.storyVC.view.frame.size = CGSize(width: .makeWidth(414), height: .makeHeight(896))
                self?.storyVC.view.layer.cornerRadius = 0
                self?.animator?.fractionComplete = 0.0
                self?.animator2?.fractionComplete = 0.0
                
                self?.hideStatusBar = false
                
                UIView.animate(withDuration: 0.125, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2) {
                    self?.headerView.components.backButton.frame.origin.y += 20
                    self?.headerView.components.eventTitle.frame.origin.y += 20
                    self?.headerView.components.shareButton.frame.origin.y += 20
                }
            }
        case .reverse:
            
            let vector = CGVector(dx: velocity.x / 100, dy: velocity.y / 100)
            let springParams = UISpringTimingParameters(dampingRatio: 1, initialVelocity: vector)
            animator?.isReversed = true
            animator2?.isReversed = true
            panGesture.isEnabled = false
            animator?.continueAnimation(withTimingParameters: springParams, durationFactor: 1)
            animator2?.continueAnimation(withTimingParameters: springParams, durationFactor: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.99) { [unowned self]  in
                self.panGesture.isEnabled = true
            }
        }
    }
}

