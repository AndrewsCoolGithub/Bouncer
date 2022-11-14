//
//  EventFull.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/8/22.
//

import Foundation
import CoreLocation
import UIImageColors
import UIKit

class EventFull: UIViewController{
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: .makeWidth(414), height: .makeHeight(233))))
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        let blurView = UIVisualEffectView(frame: CGRect(x: 0, y: .makeHeight(167), width: .makeWidth(414), height: .makeHeight(65)))
        blurView.effect = UIBlurEffect(style: .regular)
        imageView.addSubview(blurView)
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font =  .poppinsMedium(size: .makeWidth(22))
        label.textColor = .white
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.setWidth(.makeWidth(287))
        label.textAlignment = .center
        
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(12.5))
        label.textColor = .nearlyWhite()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.setWidth(.makeWidth(120))
        
        return label
    }()
    
    private let decriptionLabel: UILabel = {
        let label = UILabel()
        label.setWidth(.makeWidth(387.5))
        label.numberOfLines = 5
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.font = .poppinsRegular(size: .makeWidth(16.5))
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: .makeWidth(240), height: .makeWidth(240) * 60/240))
        button.aspectSetDimensions(height: 60, width: 240)
        
        button.layer.cornerRadius = .makeWidth(20)
        button.backgroundColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        //todo: make it a frame for shadow to work
        button.layer.applySketchShadow(color: .black.withAlphaComponent(0.25), alpha: 1, x: 0.5, y: 4.5, blur: 7, spread: 4, withRounding: .makeWidth(20))
        button.tintColor = .white
        
        return button
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(17.5))
        label.textColor = .white
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.setWidth(.makeWidth(195))
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(23), weight: UIImage.SymbolWeight.medium)
        let timeIcon = UIImageView(image: UIImage(systemName: "clock.fill", withConfiguration: config))
        timeIcon.tintColor = .white
        label.addSubview(timeIcon)
        timeIcon.centerYright(inView: label, rightAnchor: label.leftAnchor, paddingRight: .makeWidth(12.5))
        
        return label
    }()
    
    
    
    init(_ event: EventDraft, isPreview: Bool? = false, image: UIImage? = nil){
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .greyColor()
        if let image = image {
            imageView.image = image
        }
        
        view.addSubview(imageView)
        imageView.addSubview(titleLabel)
        imageView.addSubview(locationLabel)
        
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: imageView.frame.height))
        path.addLine(to: CGPoint(x: .makeWidth(414), y: imageView.frame.height))
      
        let gradientMask = CAShapeLayer()
        //gradientMask.frame = CGRect(x: 0, y: 100, width: .makeWidth(414), height: 2)
        gradientMask.fillColor = UIColor.clear.cgColor
        gradientMask.strokeColor = UIColor.black.cgColor
        gradientMask.lineWidth = 2
        gradientMask.path = path.cgPath
        gradientMask.strokeEnd = 1

        // Gradient Layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        gradientLayer.colors = [event.colors[0].cgColor(), event.colors[1].cgColor(), event.colors[2].cgColor()]
        gradientLayer.frame = CGRect(x: 0, y: imageView.frame.height - 1.5, width: .makeWidth(414), height: 2)
        gradientLayer.mask = gradientMask
        
       
        imageView.layer.addSublayer(gradientMask)
        imageView.layer.addSublayer(gradientLayer)
        
        
        
        
        
        let typeIcon = UIImageView(frame: CGRect(x: .makeWidth(10), y: .makeHeight(167 + 12.5), width: .makeHeight(40), height: .makeHeight(40)), cornerRadius: .makeHeight(20), colors: UIImageColors(background: .white, primary: event.colors[0].uiColor(), secondary: event.colors[1].uiColor(), detail: event.colors[2].uiColor()), lineWidth: 1, direction: .horizontal)
        typeIcon.image = event.type == .exclusive ? UIImage(named: "SmallExclusiveIcon") : UIImage(systemName: "mappin.and.ellipse")
        typeIcon.tintColor = .white
       
        typeIcon.contentMode = .center
        imageView.addSubview(typeIcon)
        
        
        
        
        titleLabel.centerX(inView: imageView, topAnchor: imageView.topAnchor, paddingTop: .makeHeight(170))
        locationLabel.centerX(inView: imageView, topAnchor: titleLabel.bottomAnchor, paddingTop: 0)
        
        titleLabel.text = event.title
        if let location = event.location{
            getAddress(from: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), completion: { [weak self] location in
                self?.locationLabel.text = location
            })
        }else{
            self.locationLabel.text = "Unknown"
        }
        
        
        view.addSubview(decriptionLabel)
        decriptionLabel.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: .makeHeight(250))
        decriptionLabel.text = event.description
        
        view.addSubview(actionButton)
        actionButton.centerX(inView: view, topAnchor: decriptionLabel.bottomAnchor, paddingTop: .makeHeight(25))
        let config = UIImage.SymbolConfiguration(pointSize: .makeHeight(27))
        
        //Live
       
        actionButton.setImage(UIImage(systemName: "bell.and.waveform.fill", withConfiguration: config), for: .normal)
        
       
        
        
        view.addSubview(timeLabel)
        timeLabel.anchor(right: actionButton.rightAnchor)
        timeLabel.anchor(top: actionButton.bottomAnchor, paddingTop: .makeHeight(17.5))
        //timeLabel.text = "April 21st 8:00-11:30PM "
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "E. MMM d, h:mma"
        let string1 = dateFormatter1.string(from: event.startsAt!)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "h:mma"
        let string2 = dateFormatter2.string(from: event.startsAt!.addingTimeInterval(event.duration!))
        
        timeLabel.text = string1 + "-" + string2
        
        
    }
    
    func updateView(){
        self.imageView.image = EventCreationVC.initImage!
        if let typeIcon = self.imageView.subviews.first(where: {$0 is UIImageView}) as? UIImageView{
            typeIcon.gradientColors = (EventCreationVC.shared.viewModel.colors!, true)
            typeIcon.image = EventCreationVC.shared.viewModel.eventType == .exclusive ? UIImage(named: "SmallExclusiveIcon") : UIImage(systemName: "mappin.and.ellipse")
        }
        self.decriptionLabel.text = EventCreationVC.shared.viewModel.descrip
        self.titleLabel.text = EventCreationVC.shared.viewModel.eventTitle
        if let gradientDivider = self.imageView.layer.sublayers?.first(where: {$0 is CAGradientLayer}) as? CAGradientLayer{
            gradientDivider.colors = [EventCreationVC.shared.viewModel.colors!.primary.cgColor, EventCreationVC.shared.viewModel.colors!.secondary.cgColor, EventCreationVC.shared.viewModel.colors!.detail.cgColor]
        }
        
        getAddress(from: EventCreationVC.shared.viewModel.location!, completion: { [weak self] location in
            self?.locationLabel.text = location
        })
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "E. MMM d, h:mma"
        let string1 = dateFormatter1.string(from: EventCreationVC.shared.viewModel.startDate!)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "h:mma"
        let string2 = dateFormatter2.string(from: EventCreationVC.shared.viewModel.startDate!.addingTimeInterval(EventCreationVC.shared.viewModel.duration!))
        
        timeLabel.text = string1 + "-" + string2
    }
    
    func imageResize(image:UIImage,imageSize:CGSize)->UIImage{
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func getAddress(from coordinate: CLLocationCoordinate2D, completion: @escaping(String?) -> Void){
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { places, e in
            if e == nil{
                if let location = places?.first{
                    guard let city = location.locality, let state = location.administrativeArea else{return completion(nil)}
                    return completion("\(city), \(state)")
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
