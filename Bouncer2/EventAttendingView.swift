//
//  EventAttendingView.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 10/26/23.
//

import Foundation
import UIKit

class EventAttendingView: UIView, SkeletonLoadable {
    
    lazy var eventSkeletonGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        let animation = makeAnimationGroup()
        animation.beginTime = 0.0
        gradient.add(animation, forKey: "backgroundColor")
        gradient.frame = eventImageView.bounds
        return gradient
    }()
    
    let eventImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(height: .makeWidth(45), width: .makeWidth(45))
        iv.layer.cornerRadius = .makeWidth(22.5)
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let eventTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(15))
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.setWidth(.makeWidth(100))
        return label
    }()
    
    let viewMoreLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsRegular(size: .makeWidth(10))
        label.textColor = .lightGreyText()
        label.text = "view more"
        return label
    }()
    
    var event: Event
    
    
    
    var gesture = UITapGestureRecognizer()
    
    let viewModel: EventOverviewViewModel
    let storyModel: EventOverviewStoryModel
    
    init(_ event: Event){
        self.event = event
        viewModel = EventOverviewViewModel(event: event)
        storyModel = EventOverviewStoryModel(event: event)
        super.init(frame: .zero)
        setupView()
        gesture.addTarget(self, action: #selector(showOverview))
        self.addGestureRecognizer(gesture)
    }
    
    @objc func showOverview(_ sender: UIView){
        let overview = EventOverview()
        overview.viewModel = viewModel
        overview.storyModel = storyModel
        overview.headerView = EventOverviewHeader(viewModel: viewModel, storyModel: storyModel)
        overview.contentView = EventOverviewContent(viewModel: viewModel)
        
        (self.next?.next as? UIViewController)?.navigationController?.pushViewController(overview, animated: true)
    }
    
    func setupView(){
        layer.cornerRadius = .makeWidth(27.5)
        backgroundColor = .nearlyBlack().withAlphaComponent(0.2)
        addSubview(eventImageView)
        eventImageView.centerY(inView: self, leftAnchor: self.leftAnchor, paddingLeft: .makeWidth(5))
        
        addSubview(eventTitleLabel)
        eventTitleLabel.centerY(inView: self, leftAnchor: eventImageView.rightAnchor, paddingLeft: .makeWidth(10))
        eventTitleLabel.text = event.title
        
        
        let gradient = eventSkeletonGradient
        eventImageView.layer.addSublayer(gradient)
        guard let url = URL(string: event.imageURL) else {return}
        eventImageView.sd_setImage(with: url) { i, e, c, u in
            gradient.removeFromSuperlayer()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
