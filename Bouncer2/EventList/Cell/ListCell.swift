//
//  ListCell.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/12/22.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import UIImageColors
import Combine

extension ListCell: SkeletonLoadable{}

final class ListCell: UICollectionViewCell{
    
    static let id = "event-list-cell"
    
    var lastCount: Int!
    var initAction: ListAction!
    
    private var cancellable = Set<AnyCancellable>()
    
     let eventImageView: UIImageView = { // 160 x 375
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: .makeWidth(265), height: .makeWidth(375) * 160/375))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    fileprivate lazy var typeIcon: UIView = {
        let backGroundView = UIView(frame: CGRect(x: .makeWidth(10), y: .makeWidth(10), width: .makeWidth(40), height: .makeWidth(40)), cornerRadius: .makeWidth(20), uiColors: viewModel.event.colors.map({$0.uiColor()}), lineWidth: 1, direction: .horizontal)
        backGroundView.backgroundColor = .black.withAlphaComponent(0.45)
        let imageView = UIImageView(frame: CGRect(x: .makeWidth(10), y: .makeWidth(10), width: .makeWidth(40), height: .makeWidth(40)))
        imageView.contentMode = .center
        imageView.layer.cornerRadius = .makeWidth(20)
        imageView.layer.masksToBounds = true
        imageView.tintColor = .white
        backGroundView.addSubview(imageView)
        imageView.frame = backGroundView.bounds
        switch viewModel.event.type{
        case .exclusive:
            let image = UIImage(named: "Group 5")
            
            imageView.image = image?.resizeImage(targetSize: CGSize(width: .makeWidth(23), height: .makeWidth(19)))
          
        case .open:
            imageView.image = UIImage(systemName: "mappin.and.ellipse")
        }
        return backGroundView
    }()
    
    fileprivate let profileImageView: UIImageView = { // 61 x 61
        let imageView = UIImageView(frame: CGRect(x: .makeWidth(25.75), y: .makeHeight(10) + .makeWidth(2), width: .makeWidth(61), height: .makeWidth(61)))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = .makeWidth(20)
        return imageView
    }()
    
    fileprivate let profileBackgroundGradient: UIView = { // 65 x 65
        let gradientView = UIView(frame: CGRect(x: .makeWidth(23.75), y: .makeHeight(10), width: .makeWidth(65), height: .makeWidth(65)))
        gradientView.layer.masksToBounds = true
        gradientView.layer.cornerRadius = .makeWidth(22)
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: gradientView.frame.size)
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        gradientView.layer.addSublayer(gradient)
        return gradientView
    }()
    
    
    fileprivate let sideView: UIView = { // 160 x 112.5
        let sideView = UIView(frame: CGRect(x: .makeWidth(262.5), y: 0, width: .makeWidth(112.5), height: .makeWidth(375) * 160/375))
        sideView.backgroundColor = .greyColor()
        return sideView
    }()
    
    fileprivate let overlay: UIView = { // 50 x 375
        let overlay = UIView(frame: CGRect(x: 0, y: (.makeWidth(375) * 110/375), width: .makeWidth(375), height: (.makeWidth(375) * 50/375)))
        overlay.layer.compositingFilter = "multiplyBlendMode"
        
        let gradientOverlay = CAGradientLayer()
        gradientOverlay.frame = overlay.bounds
        gradientOverlay.colors = [UIColor.white.cgColor, UIColor.greyColor().cgColor]
        gradientOverlay.startPoint = CGPoint(x: 0.5, y: 0)
        gradientOverlay.endPoint = CGPoint(x: 0.5, y: 1)
        overlay.layer.insertSublayer(gradientOverlay, at: 1)
        return overlay
    }()
    
    fileprivate let eventTitleLabel: UILabel = { // ? x 220
        let label = UILabel()
        label.textColor = .white
        label.font = .poppinsMedium(size: .makeWidth(14))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.65
       
        label.setWidth(.makeWidth(220))
        return label
    }()
    
    fileprivate let cityLabel: UILabel = { // ? x 220
        let label = UILabel()
        label.textColor = .nearlyWhite()
        label.font = .poppinsMedium(size: .makeWidth(11))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.65
       
        label.setWidth(.makeWidth(180))
        return label
    }()
    
    fileprivate let actionButton: UIButton = { // 37.5 x 75
        let button = UIButton(frame: CGRect(x: .makeWidth(18.5), y: (.makeWidth(375) * 115/375), width: .makeWidth(75), height: (.makeWidth(375) * 37.5/375)))
        button.backgroundColor = .buttonFill()
        button.layer.cornerRadius = (.makeWidth(375) * 12/375)
        button.layer.applySketchShadow(alpha: 0.5, y: (.makeWidth(375) * 6/375), blur: .makeWidth(9), spread: .makeWidth(-4), withRounding: (.makeWidth(375) * 12/375))
        button.tintColor = .white
        return button
    }()
    
    fileprivate let statsView: UIView = {
        let statsView = UIView(frame: CGRect(x: .makeWidth(5), y: (.makeWidth(375) * 75/375), width: .makeWidth(102.5), height: (.makeWidth(375) * 37.5/375)))
    
        return statsView
    }()
    
    fileprivate let statIcon1: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.setDimensions(height: .makeWidth(375) * 15/375, width:  .makeWidth(15))
        imageView.tintColor = .nearlyWhite()
        return imageView
    }()
    
    fileprivate let statLabel1: UILabel = {
        let label = UILabel()
        label.setWidth(.makeWidth(25))
        label.font = .poppinsRegular(size: .makeWidth(12.5))
        label.textAlignment = .left
        label.textColor = .nearlyWhite()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    fileprivate let statIcon2: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.setDimensions(height: .makeWidth(375) * 15/375, width:  .makeWidth(15))
        imageView.tintColor = .nearlyWhite()
        return imageView
    }()
    
    fileprivate let statLabel2: UILabel = {
        let label = UILabel()
        label.setWidth(.makeWidth(25))
        label.font = .poppinsRegular(size: .makeWidth(12.5))
        label.textColor = .nearlyWhite()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    
    
    lazy var skeletonGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        let animation = makeAnimationGroup()
        animation.beginTime = 0.0
        gradient.add(animation, forKey: "backgroundColor")
        gradient.frame = contentView.bounds
        return gradient
    }()
    
    lazy var skeletonGradientForImage: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        let animation = makeAnimationGroup()
        animation.beginTime = 0.0
        gradient.add(animation, forKey: "backgroundColor")
        gradient.frame = contentView.bounds
        return gradient
    }()
    
    var shouldAnimateButton: Bool = false
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        viewModel = nil
        lastCount = nil
        lastTimeText = nil
        initAction = nil
        timerCancellable?.cancel()
        cancellable.forEach({$0.cancel()})
       
    }
    var timerCancellable: Cancellable?
    
   
    var viewModel: ListCellVM!
    
    enum VcType{
        case All
        case My
    }
    
    public func setupCell(viewModel: ListCellVM, from vcType: VcType){
        cancellable.forEach({$0.cancel()})
        timerCancellable?.cancel()
        self.viewModel = viewModel
        
        contentView.layer.addSublayer(skeletonGradient)
        contentView.layer.cornerRadius = .makeHeight(25)
        contentView.layer.masksToBounds = true
        layer.applySketchShadow(alpha: 0.3, y: .makeHeight(9), blur: .makeWidth(9), spread: .makeWidth(7), withRounding: .makeHeight(25))
        contentView.backgroundColor = .greyColor()
        
        //Event Image
        contentView.addSubview(eventImageView)
        eventImageView.sd_setImage(with: URL(string: viewModel.event.imageURL)) { [weak self] i, e, c, u in
            self?.skeletonGradient.removeFromSuperlayer()
        }
        
        //EventTypeIcon
        contentView.addSubview(typeIcon)
        
        // Overlay & Event Title
        eventTitleLabel.text = viewModel.event.title
        cityLabel.text = viewModel.event.locationName.uppercased()
           
        contentView.addSubview(overlay)
        contentView.addSubview(eventTitleLabel)
        eventTitleLabel.anchor(bottom: overlay.bottomAnchor, paddingBottom: .makeHeight(20))
        eventTitleLabel.anchor(left: overlay.leftAnchor, paddingLeft: .makeWidth(10))
        contentView.addSubview(cityLabel)
        cityLabel.anchor(bottom: overlay.bottomAnchor, paddingBottom: .makeWidth(2.5))
        cityLabel.anchor(left: overlay.leftAnchor, paddingLeft: .makeWidth(10))
        contentView.addSubview(sideView)
        
        
        //SideView
         //- profileImage
        if let gradientLayer = profileBackgroundGradient.layer.sublayers?.first(where: {$0 is CAGradientLayer}) as? CAGradientLayer{
            gradientLayer.colors = viewModel.event.colors.map({$0.uiColor()}).map({$0.cgColor})
        }
        sideView.addSubview(profileBackgroundGradient)
        sideView.addSubview(profileImageView)
        profileImageView.layer.addSublayer(skeletonGradientForImage)
        loadImage()
        
         // - actionButton
        sideView.addSubview(actionButton)
        
        actionButton.addTarget(self, action: #selector(triggerAction(sender:)), for: .touchUpInside)
        
         // - statsView
        sideView.addSubview(statsView)
        statsView.addSubview(statIcon1)
        statsView.addSubview(statLabel1)
        statIcon1.centerY(inView: statsView, leftAnchor: statsView.leftAnchor, paddingLeft: .makeWidth(5))
        statLabel1.centerY(inView: statsView, leftAnchor: statIcon1.rightAnchor, paddingLeft: .makeWidth(5))
        statsView.addSubview(statLabel2)
        statsView.addSubview(statIcon2)
    
        statLabel2.centerYright(inView: statsView, rightAnchor: statsView.rightAnchor, paddingRight: .makeWidth(2.5))
        statIcon2.centerYright(inView: statsView, rightAnchor: statLabel2.leftAnchor, paddingRight: .makeWidth(5))
        
        // - Remove Button for invited
        let isInvited = (viewModel.event.invitedIds?.contains(User.shared.id!) ?? false)
        let rsvpInvited = (viewModel.event.prospectIds?.contains(User.shared.id!) ?? false) && viewModel.event.startsAt < .now && viewModel.event.type == .open
        if vcType == .My && (isInvited || rsvpInvited){
            let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(22))
            let deleteDraftButton = UIButton(frame: CGRect(x: contentView.frame.maxX - .makeWidth(45), y: .makeWidth(-10), width: .makeWidth(45), height: .makeWidth(45)), cornerRadius: .makeWidth(22.5), colors: viewModel.event.colors.uiImageColors(), lineWidth: 1.5, direction: .horizontal)
            deleteDraftButton.backgroundColor = .nearlyBlack()
            deleteDraftButton.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
            deleteDraftButton.tintColor = .white
            deleteDraftButton.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
            addSubview(deleteDraftButton)
        }
        
        setupButton(viewModel)
        configureTime(viewModel)
        configureCount(viewModel)
    }
    
    @objc func deletePressed(){
        viewModel.removeFromInvited()
    }
   
    private func configureCount(_ viewModel: ListCellVM){
        
        let guests = viewModel.event.guestIds
        let prospects = viewModel.event.prospectIds
        let eventType = viewModel.event.type
        let startDate = viewModel.event.startsAt
        
       
        if let guests = guests{
            statIcon1.image = UIImage(systemName: "person.fill")
            updateLabelCount(guests.count)
        }else if eventType == .open{
            if startDate < .now{
                statIcon1.image = UIImage(systemName: "person.fill")
                updateLabelCount(guests?.count ?? 0)
            }else{
                statIcon1.image = UIImage(systemName: "bell.fill")
                updateLabelCount(prospects?.count ?? 0)
            }
        }else if eventType == .exclusive{
            if startDate < .now{
                statIcon1.image = UIImage(systemName: "person.fill")
                updateLabelCount(guests?.count ?? 0)
            }else{
                statIcon1.image = UIImage(systemName: "list.bullet.rectangle.portrait.fill")
                updateLabelCount(prospects?.count ?? 0)
            }
        }
    }
    
    private func animate(newImage: UIImage) {
        
        if self.shouldAnimateButton == true{
            self.shouldAnimateButton = false
                // Step 1
                UIView.animate(withDuration: 0.1, animations: {
                    self.actionButton.transform = self.actionButton.transform.scaledBy(x: 0.8, y: 0.8)
                    self.actionButton.setImage(newImage, for: .normal)
                }, completion: { _ in
                  // Step 2
                  UIView.animate(withDuration: 0.1, animations: {
                      self.actionButton.transform = CGAffineTransform.identity
                })
            })
        }else{
            self.actionButton.setImage(newImage, for: .normal)
        }
    }
    
    func updateLabelCount(_ count: Int){
        guard lastCount != nil else {
            statLabel1.text = "\(count)"
            lastCount = count
            return
        }
               
        //Increase
        if lastCount < count {
            UIView.transition(with: statLabel1, duration: 0.8, options: [.transitionFlipFromTop,     .curveEaseInOut] ) { [weak self] in
                self?.statLabel1.text = "\(count)"
                self?.lastCount = count
            }
        //Decrease
        }else if lastCount > count{
            UIView.transition(with: statLabel1, duration: 0.8, options: [.transitionFlipFromBottom, .curveEaseInOut ] ) { [weak self] in
                    self?.statLabel1.text = "\(count)"
                    self?.lastCount = count
            }
        }
    }
    
  
    var lastTimeText: String!

    
    func setupButton(_ viewModel: ListCellVM){
        viewModel.$action.sink { sub_complete_never in
            print(sub_complete_never)
        } receiveValue: { [weak self] value in
           
            let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(20))
            switch value{
                
            case .joinWaitlist:
                DispatchQueue.main.async {
                    self?.animate(newImage: UIImage(systemName: "scroll", withConfiguration: config)!)
                }
                
            case .leaveWaitlist:
                DispatchQueue.main.async {
                    self?.animate(newImage: UIImage(systemName: "scroll.fill", withConfiguration: config)!)
                }
            case .RSVP:
                DispatchQueue.main.async {
                    self?.animate(newImage: UIImage(systemName: "bell.and.waveform", withConfiguration: config)!)
                }
            case .unRSVP:
                DispatchQueue.main.async {
                    self?.animate(newImage: UIImage(systemName: "bell.and.waveform.fill", withConfiguration: config)!)
                }
            case .nav:
                self?.actionButton.setImage(UIImage(systemName: "location.fill", withConfiguration: config), for: .normal)
            case .invited:
                self?.actionButton.setImage(UIImage(systemName: "clock.badge.checkmark.fill", withConfiguration: config), for: .normal)
                
            case .unavailable:
                self?.actionButton.setImage(nil, for: .normal)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                if self?.initAction == nil{
                    self?.initAction = value
                    
                }
            }
           
        }.store(in: &cancellable)
    }
    
    @objc func triggerAction(sender: UIButton){
        self.shouldAnimateButton = true
        self.viewModel.perform()
    }
    
    private func loadImage(){
        let randInt: Int = Int.random(in: 300...1920)
        let randInt2: Int = Int.random(in: 300...1920)
        profileImageView.sd_setImage(with: URL(string: "https://source.unsplash.com/random/?person/\(randInt)x\(randInt2)")) { i, e, c, u in
            self.skeletonGradientForImage.removeFromSuperlayer()
        }
    }
    
    fileprivate func configureTime(_ viewModel: ListCellVM) {
        statLabel2.text = viewModel.fetchTimeText()
        lastTimeText = statLabel2.text
        viewModel.$timeSymbolName.sink { [unowned self] timeSymbol in
            statIcon2.image = UIImage(systemName: timeSymbol.rawValue)
            switch timeSymbol{
            case .clock:
                self.timerCancellable?.cancel()
                timerCancellable = Timer.publish(every: 5, on: .main, in: .default).autoconnect().sink {  _  in
                    let timeText = viewModel.fetchTimeText()
                    if timeText != self.lastTimeText{
                        UIView.transition(with: self.statLabel2, duration: 0.69, options: .transitionCurlUp) {
                            self.statLabel2.text = timeText
                            self.lastTimeText = timeText
                        }
                    }
                }
            case .calendar:
                self.statLabel2.text = viewModel.fetchCalendarText()
                self.timerCancellable?.cancel()
                timerCancellable = Timer.publish(every: viewModel.event.startsAt.timeIntervalSince(.now), on: .main, in: .default).autoconnect().sink {  _  in
                    UIView.transition(with: self.statLabel2, duration: 0.69, options: .transitionCurlUp) {
                        self.statLabel2.text = viewModel.fetchTimeText()
                        self.lastTimeText = self.statLabel2.text
                    }
                    self.configureCount(viewModel)
                    viewModel.updateActionForLive()
                    viewModel.timeSymbolName = .clock
                    print("Still running")
                }
            }
        }.store(in: &self.cancellable)
    }
}
