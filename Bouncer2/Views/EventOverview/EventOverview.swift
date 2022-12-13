//
//  EventOverview.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/11/22.
//

import UIKit

class EventOverview: UIViewController{
    
    var viewModel: EventOverviewViewModel!
    var headerView: EventOverviewHeader!
    var contentView: EventOverviewContent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        let openStoryGesture = UILongPressGestureRecognizer(target: self, action: #selector(openStory))
            openStoryGesture.minimumPressDuration = 0
           
        headerView.components.storyView.addGestureRecognizer(openStoryGesture)
        headerView.components.backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        headerView.components.shareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
        headerView.components.cameraButton.addTarget(self, action: #selector(addStory), for: .touchUpInside)
        headerView.clipsToBounds = false
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
    }
    
    @objc func openStory(_ sender: UILongPressGestureRecognizer){
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
        print("Add story")
    }
    
    @objc func share(){
        print("Share event")
    }
    
    @objc func dismissView(){
        navigationController?.popViewController(animated: true)
    }
}

