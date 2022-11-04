//
//  EventSuitCell.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/16/22.
//

import Foundation
import UIKit
import Firebase
import CoreLocation
class EventSuiteCell: UICollectionViewCell{
    static let id = "event-suite-cell"
    let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
       
    }
    
    private let bottomSheet: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: .makeWidth(105), width: .makeWidth(375), height: .makeWidth(375) * 55/375))
        view.backgroundColor = .greyColor()
        let innerShadow = InnerShadowLayer(forView: view, edge: .Top, shadowRadius: 8, toColor: .clear, fromColor: .black.withAlphaComponent(0.3))
        view.layer.addSublayer(innerShadow)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .poppinsMedium(size: .makeWidth(15))
        label.setWidth(.makeWidth(230))
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .nearlyWhite()
        label.font = .poppinsMedium(size: .makeWidth(12.5))
        label.setWidth(.makeWidth(180))
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(16.5))
        let icon = UIImageView(image: UIImage(systemName: "clock.fill", withConfiguration: config))
        icon.tintColor = .nearlyWhite()
        label.font = .poppinsMedium(size: .makeWidth(13))
        label.textColor = .nearlyWhite()
        label.addSubview(icon)
        icon.centerYright(inView: label, rightAnchor: label.leftAnchor, paddingRight: .makeWidth(5))
        
        return label
    }()
    
    private var deleteButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private var eventTypeIcon: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
   
    
    weak var viewModel: EventSuiteCellViewModel?
    func create(with viewModel: EventSuiteCellViewModel){
        self.viewModel = viewModel
        switch viewModel.dataType{
        case .draft(let event):
            self.setupDraft(event)
        case .event(let event):
            self.setupEvent(event)
        }
    }
    
    
    private let backDrop: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemUltraThinMaterial)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.alpha = 1
        return effectView
    }()
    
    private func setupEvent(_ event: Event){
        contentView.layer.cornerRadius = .makeHeight(25)
        contentView.layer.masksToBounds = true
        layer.applySketchShadow(alpha: 0.3, y: .makeHeight(9), blur: .makeWidth(9), spread: .makeWidth(7), withRounding: .makeHeight(25))
        contentView.backgroundColor = .greyColor()
        
        eventTypeIcon = UIImageView(frame: CGRect(x: .makeWidth(10), y: .makeWidth(10), width: .makeWidth(40), height: .makeWidth(40)), cornerRadius: .makeWidth(20), colors: event.uiImageColors(), lineWidth: 1.5, direction: .horizontal)
        eventTypeIcon.contentMode = .center
        eventTypeIcon.backgroundColor = .greyColor().withAlphaComponent(0.69)
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(22))
        
        switch event.type{
        case .exclusive:
            eventTypeIcon.image = UIImage(named: "Group5")
        case .open:
            eventTypeIcon.image = UIImage(systemName: "mappin.and.ellipse", withConfiguration: config)
        }
       
        eventTypeIcon.tintColor = .white
        
        self.deleteButton.removeFromSuperview()

        backDrop.removeFromSuperview()
        contentView.addSubview(imageView)

        contentView.addSubview(eventTypeIcon)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.frame = contentView.bounds
        imageView.sd_setImage(with: URL(string: event.imageURL))

       
        
        
        contentView.addSubview(bottomSheet)
        bottomSheet.addSubview(titleLabel)
        titleLabel.anchor(top: bottomSheet.topAnchor, paddingTop: .makeWidth(9))
        titleLabel.anchor(left: bottomSheet.leftAnchor, paddingLeft: .makeWidth(11))
        titleLabel.text = event.title.capitalized
        
        bottomSheet.addSubview(locationLabel)
        locationLabel.anchor(top: titleLabel.bottomAnchor, left: bottomSheet.leftAnchor, paddingLeft: .makeWidth(11))
       
        locationLabel.text = event.locationName
        
        bottomSheet.addSubview(timeLabel)
        timeLabel.centerYright(inView: bottomSheet, rightAnchor: bottomSheet.rightAnchor, paddingRight: .makeWidth(15))
        
        let endTime = event.endsAt
        let timeSinceEnded = endTime.timeIntervalSinceNow.timeInUnits
        timeLabel.text = "Hosted \(timeSinceEnded) ago"
    }
    
    
    private func setupDraft(_ event: EventDraft){
        contentView.layer.cornerRadius = .makeHeight(25)
        contentView.layer.masksToBounds = true
        layer.applySketchShadow(alpha: 0.3, y: .makeHeight(9), blur: .makeWidth(9), spread: .makeWidth(7), withRounding: .makeHeight(25))
        contentView.backgroundColor = .greyColor()
        
        eventTypeIcon = UIImageView(frame: CGRect(x: .makeWidth(10), y: .makeWidth(10), width: .makeWidth(40), height: .makeWidth(40)), cornerRadius: .makeWidth(20), colors: event.uiImageColors(), lineWidth: 1.5, direction: .horizontal)
        eventTypeIcon.contentMode = .center
        eventTypeIcon.backgroundColor = .greyColor().withAlphaComponent(0.69)
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(22))
        eventTypeIcon.image = UIImage(systemName: "pencil", withConfiguration: config)
        eventTypeIcon.tintColor = .white
        
        deleteButton = UIButton(frame: CGRect(x: contentView.frame.maxX - .makeWidth(45), y: .makeWidth(-10), width: .makeWidth(45), height: .makeWidth(45)), cornerRadius: .makeWidth(22.5), colors: event.uiImageColors(), lineWidth: 1.5, direction: .horizontal)
        deleteButton.backgroundColor = .nearlyBlack()
        deleteButton.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        deleteButton.tintColor = .white
        deleteButton.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
        
        contentView.addSubview(imageView)
        self.addSubview(deleteButton)
        contentView.addSubview(eventTypeIcon)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.frame = contentView.bounds
        imageView.image = getSavedImage(named: "\(event.id).jpeg") //Only works for drafts

        
        backDrop.frame = imageView.bounds
        imageView.addSubview(backDrop)
        
        contentView.addSubview(bottomSheet)
        bottomSheet.addSubview(titleLabel)
        titleLabel.anchor(top: bottomSheet.topAnchor, paddingTop: .makeWidth(9))
        titleLabel.anchor(left: bottomSheet.leftAnchor, paddingLeft: .makeWidth(11))
        titleLabel.text = event.title?.capitalized
        
        bottomSheet.addSubview(locationLabel)
        locationLabel.anchor(top: titleLabel.bottomAnchor, left: bottomSheet.leftAnchor, paddingLeft: .makeWidth(11))
        if let geoPoint = event.location{
            self.determineLocation(geoPoint, completion: { [weak self] location  in
                self?.locationLabel.text = location ?? "No where, USA"
            })
        }else{
            locationLabel.text = "No where"
        }
        
        bottomSheet.addSubview(timeLabel)
        timeLabel.centerYright(inView: bottomSheet, rightAnchor: bottomSheet.rightAnchor, paddingRight: .makeWidth(15))
        timeLabel.text = "Live in 2d 6h"
        
        if let timeTillLive = event.startsAt?.timeIntervalSince(.now), timeTillLive.sign == .plus{
            var value: Int
            var value2: Int?
            var unit: String
            var unit2: String?
            if timeTillLive >= 86400{
                value = Int(round(timeTillLive / 86400))
                unit = "d"
                let hours = (Int(round(timeTillLive)) % 86400) / 3600
                value2 = hours
                unit2 = "h"
            }else if timeTillLive >= 3600{
                value = Int(round(timeTillLive / 3600))
                unit = "h"
                let minutes = (Int(round(timeTillLive)) % 3600) / 60
                value2 = minutes
                unit2 = "m"
            }else{
                value = Int(round(timeTillLive / 60))
                unit = "m"
                value2 = nil
                unit2 = nil
            }
            
            if let value2 = value2, let unit2 = unit2, value2 > 0 {
                let first = "\(value)" + unit
                let second = "\(value2)" + unit2
                timeLabel.text = "Live in \(first)" + " " + second
            }else{
                timeLabel.text = "Live in \(value)" + unit
            }
        }else{
            timeLabel.text = "To be determined"
        }
    }
    
    @objc func deletePressed(){
        viewModel?.delete()
    }
    
    func determineLocation(_ location: GeoPoint, completion: @escaping(String?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude)) { places, e in
            if let placemark = places?.first,  let city = placemark.locality,
               let state = placemark.administrativeArea, e == nil{
                return completion("\(city),\(state)")
            }else{
                return completion(nil)
            }
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            //print((dir).appendingPathComponent(named).path)
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}
