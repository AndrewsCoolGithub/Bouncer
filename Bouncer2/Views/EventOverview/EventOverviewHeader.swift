//
//  EventOverviewHeader.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/12/22.
//

import UIKit

class EventOverviewHeader: UIView{
    
    var viewModel: EventOverviewViewModel!
    var components = EventOverviewHeaderComponents()
    
    init(viewModel: EventOverviewViewModel) {
        let height = components.eventImageView.frame.height + .wProportioned(52.5)
        let frame = CGRect(origin: .zero, size: CGSize(width: .makeWidth(414), height: height))
        super.init(frame: frame)
        self.viewModel = viewModel
        setupViews()
        setupListeners()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        let view = self
        let eventImageView = components.eventImageView
        view.addSubview(eventImageView)
        
        let backButton = components.backButton
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: .wProportioned(15), paddingLeft: .makeWidth(20))

        let shareButton = components.shareButton
        view.addSubview(shareButton)
        shareButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: .wProportioned(15), paddingRight: .makeWidth(20))
        
        let eventTitle = components.eventTitle
        view.addSubview(eventTitle)
        eventTitle.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: .wProportioned(17.5))
        
        let storyView = components.storyView
        view.addSubview(storyView)
        storyView.centerX(inView: view, topAnchor: eventImageView.bottomAnchor, paddingTop: -.wProportioned(52.5))
        
        let border = components.border
        storyView.layer.addSublayer(border)
        
        let cameraButton = components.cameraButton
        view.addSubview(cameraButton)

        cameraButton.anchor(bottom: storyView.bottomAnchor, paddingBottom: .wProportioned(7.5))
        cameraButton.anchor(right: storyView.rightAnchor, paddingRight: -.wProportioned(7.5))
    }
    
    fileprivate func setupListeners(){
        let eventImageView = components.eventImageView
        let skeletonGradient = components.skeletonGradient
        viewModel.$imageURL.sink { imageURL in
            eventImageView.layer.addSublayer(skeletonGradient)
            eventImageView.sd_setImage(with: URL(string: imageURL)){ i, e, c, u in
               skeletonGradient.removeFromSuperlayer()
            }
        }.store(in: &viewModel.cancellable)

        let eventTitle = components.eventTitle
        viewModel.$title.sink { title in
            eventTitle.text = title
        }.store(in: &viewModel.cancellable)
        
        let border = components.border
        viewModel.$colors.sink { colors in
            border.colors = colors.cgColors()
        }.store(in: &viewModel.cancellable)
    }
}

struct EventOverviewHeaderComponents: SkeletonLoadable{
    
    let backButton: UIButton = {
        let backButton = UIButton(frame: .zero)
        let config = UIImage.SymbolConfiguration(pointSize: .wProportioned(30), weight: .semibold)
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        backButton.tintColor = .white
        backButton.backgroundColor = .nearlyBlack().withAlphaComponent(0.2)
        backButton.setDimensions(height: .wProportioned(40), width: .wProportioned(40))
        backButton.layer.cornerRadius = .wProportioned(20)
        backButton.layer.masksToBounds = true
        return backButton
    }()
    
    let shareButton: UIButton = {
        let button = UIButton(frame: .zero)
        let config = UIImage.SymbolConfiguration(pointSize: .wProportioned(25))
        button.setImage(UIImage(systemName: "square.and.arrow.up.fill", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .nearlyBlack().withAlphaComponent(0.2)
        button.setDimensions(height: .wProportioned(40), width: .wProportioned(40))
        button.layer.cornerRadius = .wProportioned(20)
        button.layer.masksToBounds = true
        return button
    }()
    
    let eventImageView: UIImageView = {
        let bannerImageView = UIImageView(frame: CGRect(origin: .zero, size: .aspectGetSize(height: 184, width: 414)))
        bannerImageView.layer.masksToBounds = true
        bannerImageView.clipsToBounds = true
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.backgroundColor = .systemPink
        return bannerImageView
    }()
    
    let eventTitle: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(26))
        label.textColor = .white
        return label
    }()
    
    lazy var skeletonGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        let animation = makeAnimationGroup()
        animation.beginTime = 0.0
        gradient.add(animation, forKey: "backgroundColor")
        gradient.frame = eventImageView.bounds
        return gradient
    }()
    
    let storyView: UIImageView = {
        let imageView = UIImageView()
        imageView.setDimensions(height: .wProportioned(105), width: .wProportioned(105))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = .wProportioned(52.5)
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .systemPink
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let cameraButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: .wProportioned(42))
        button.setImage(UIImage(systemName: "camera.circle.fill", withConfiguration: config), for: .normal)
        button.layer.cornerRadius = button.intrinsicContentSize.height/2
        button.layer.masksToBounds = true
        button.imageView?.contentMode = .center
        button.tintColor = .white
        button.backgroundColor = .greyColor()
        return button
    }()
    
    let border: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: .wProportioned(105), height: .wProportioned(105)))
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.path = UIBezierPath(roundedRect: CGRect(origin:CGPoint(x: 0, y: 0), size: CGSize(width: .wProportioned(105), height: .wProportioned(105))).insetBy(dx: 0.45, dy: 0.45),
                                  cornerRadius: .wProportioned(52.5)).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        return gradient
    }()
}
