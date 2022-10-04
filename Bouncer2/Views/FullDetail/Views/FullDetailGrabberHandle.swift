//
//  FullDetailGrabberHandle.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/30/22.
//

import Foundation
import UIImageColors
import UIKit
import CoreLocation

class FullDetailGrabberHandle: UIView {
    //MARK: Grabber Handle Components
    //1.
    let typeIcon: UIView = {
        let backgroundView = UIView(frame: CGRect(x: .makeWidth(20), y: .makeWidth(20), width: .makeWidth(45), height: .makeWidth(45)), cornerRadius: .makeWidth(22.5), uiColors: [UIColor.white, UIColor.white, UIColor.white], lineWidth: 1, direction: .horizontal)
        backgroundView.backgroundColor = .black.withAlphaComponent(0.45)
        
        let imageView = UIImageView(frame: CGRect(x: .makeWidth(20), y: .makeWidth(20), width: .makeWidth(45), height: .makeWidth(45)))
        imageView.contentMode = .center
        imageView.layer.cornerRadius = .makeWidth(22.5)
        imageView.layer.masksToBounds = true
        imageView.tintColor = .white
        backgroundView.addSubview(imageView)
        imageView.frame = backgroundView.bounds.insetBy(dx: 1, dy: 1)
        
        return backgroundView
    }()
    
    //2.
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(20))
        label.setWidth(.makeWidth(250))
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    //3a
    let cityLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(14.5))
        label.textColor = .nearlyWhite()
        label.numberOfLines = 1
        return label
    }()
    
    //3b
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .nearlyBlack()
        label.font = .poppinsMedium(size: .makeWidth(14.5))
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    //4.
    let bottomSeperator: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: .makeWidth(414) * 83/414, width: .makeWidth(414), height: .makeHeight(2)))
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: view.frame.size)
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(gradient)
        return view
    }()
    
    init(event: Event, vm: FullDetailVM){
        super.init(frame: CGRect(x: 0, y: 0, width: .makeWidth(414), height: .makeWidth(414) * 85/414))
        backgroundColor = .greyColor()
        clipsToBounds = true
        layer.cornerRadius = .makeWidth(22.5)
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.applySketchShadow(color: .black.withAlphaComponent(0.3), alpha: 1, x: 0, y: .makeHeight(6), blur: .makeWidth(3), spread: .makeWidth(5), withRounding: 0)
        setupIcon(type: event.type, vm: vm)
        setupTitle(with: event.title, vm: vm)
        setupCityLabel(with: event.locationName, vm: vm)
        setupDistanceLabel(with: CLLocationCoordinate2D(latitude: event.location.latitude,
                                                        longitude: event.location.longitude), vm: vm)
        setupColors(colors: event.colors, vm: vm)
        
    }
    
    
    
    fileprivate func setupTitle(with title: String, vm: FullDetailVM){
        addSubview(titleLabel)
        titleLabel.centerX(inView: self, topAnchor: topAnchor, paddingTop: .makeWidth(20))
        titleLabel.text = title
        vm.$eventTitle.sink { [weak self] newEventTitle in
            guard let self = self, let newEventTitle = newEventTitle,
                  newEventTitle != self.titleLabel.text else {return}
            UIView.transition(with: self.titleLabel, duration: 0.3, options: .transitionCrossDissolve) {
                self.titleLabel.text = newEventTitle
            }
        }.store(in: &vm.cancellable)
    }
    
    fileprivate func setupCityLabel(with locationName: String, vm: FullDetailVM){
        addSubview(cityLabel)
        cityLabel.text = locationName.uppercased()
        vm.$locationName.sink { [weak self] newLocationName in
            guard let self = self, let newLocationName = newLocationName,
                  newLocationName.uppercased() != self.cityLabel.text else {return}
            UIView.transition(with: self.cityLabel, duration: 0.3, options: .transitionCrossDissolve) {
                self.cityLabel.text = newLocationName.uppercased()
            }
        }.store(in: &vm.cancellable)
    }
    
    fileprivate func setupDistanceLabel(with location: CLLocationCoordinate2D, vm: FullDetailVM){
        addSubview(distanceLabel)
//        distanceLabel.centerX(inView: self, topAnchor: titleLabel.bottomAnchor, paddingTop: .makeWidth(5))
        let attrString = NSMutableAttributedString(string: ", ", attributes: [NSMutableAttributedString.Key.font : UIFont.poppinsThin(size: .makeHeight(18)), NSMutableAttributedString.Key.foregroundColor : UIColor.nearlyBlack()])
        let midString = NSMutableAttributedString(string: "\(location.toDistance() ?? "Na") mi", attributes: [NSMutableAttributedString.Key.font : UIFont.poppinsMedium(size: .makeHeight(13.5))])
        let attrString2 = NSMutableAttributedString(string: " ,", attributes: [NSMutableAttributedString.Key.font : UIFont.poppinsThin(size: .makeHeight(20)), NSMutableAttributedString.Key.foregroundColor : UIColor.nearlyBlack()])
        attrString.append(midString)
        attrString.append(attrString2)
        self.distanceLabel.attributedText = attrString
        vm.$location.sink { [weak self] newLocation in
            guard let self = self, let newLocation = newLocation else {return}
            UIView.transition(with: self.cityLabel, duration: 0.3, options: .transitionCrossDissolve) {
                let attrString = NSMutableAttributedString(string: ", ", attributes: [NSMutableAttributedString.Key.font : UIFont.poppinsThin(size: .makeHeight(18)), NSMutableAttributedString.Key.foregroundColor : UIColor.nearlyBlack()])
                let midString = NSMutableAttributedString(string: "\(newLocation.toDistance() ?? "Na") mi", attributes: [NSMutableAttributedString.Key.font : UIFont.poppinsMedium(size: .makeHeight(13.5))])
                let attrString2 = NSMutableAttributedString(string: " ,", attributes: [NSMutableAttributedString.Key.font : UIFont.poppinsThin(size: .makeHeight(20)), NSMutableAttributedString.Key.foregroundColor : UIColor.nearlyBlack()])
                attrString.append(midString)
                attrString.append(attrString2)
                self.distanceLabel.attributedText = attrString
            }
        }.store(in: &vm.cancellable)
        
    }
    
    fileprivate func setupColors(colors: [ColorModel], vm: FullDetailVM){
        typeIcon.gradientColors = UIImageColors(background: .clear, primary: colors[0].uiColor(), secondary: colors[1].uiColor(), detail: colors[2].uiColor())
        
        addSubview(bottomSeperator)
        let gradient = bottomSeperator.layer.sublayers![0] as! CAGradientLayer
        gradient.colors = [colors[0].cgColor(), colors[1].cgColor(), colors[2].cgColor()]
        
        vm.$colors.sink { [weak self] newColors in
            guard let newColors = newColors, let self = self else {return}
            UIView.transition(with: self, duration: 1, options: [.transitionCrossDissolve, .allowUserInteraction]) {
                gradient.colors = [newColors[0].cgColor(), newColors[1].cgColor(), newColors[2].cgColor()]
            }
            self.typeIcon.gradientColors = UIImageColors(background: .clear, primary: newColors[0].uiColor(), secondary: newColors[1].uiColor(), detail: newColors[2].uiColor()) // gradient property already animates changes
        }.store(in: &vm.cancellable)
    }
    
    fileprivate func setupIcon(type eventType: EventType, vm: FullDetailVM){
        addSubview(typeIcon)
        var eventType: EventType = eventType
        
        if let imageView = typeIcon.subviews.first(where: {$0 is UIImageView}) as? UIImageView{
            var typeImage: UIImage? {
                switch eventType{
                case .open:
                    return UIImage(systemName: "mappin.and.ellipse")
                case .exclusive:
                    let image = UIImage(named: "Group 5")
                    return image?.resizeImage(targetSize: CGSize(width: .makeWidth(23), height: .makeWidth(19)))
                }
            }
            
            imageView.image = typeImage
            
            vm.$type.sink { type in
                guard let type = type else {return}
                eventType = type
                UIView.transition(with: imageView, duration: 0.3, options: .transitionCrossDissolve) {
                    imageView.image = typeImage
                }
            }.store(in: &vm.cancellable)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
