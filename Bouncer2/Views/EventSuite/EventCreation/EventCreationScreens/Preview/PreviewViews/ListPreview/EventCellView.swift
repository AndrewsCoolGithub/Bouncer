//
//  EventCellView.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/11/22.
//

import Foundation
import UIKit

class EventCellView: UIView{
    
    private let label = UILabel()
    var lastCount: Int!
    
    private let imageView = UIImageView()
    private let gradientView = UIView()
    let newImageView = UIImageView()
    let sideView = UIView(frame: .zero)
    let timeLabel = UILabel()
    
    init(event: EventDraft, image: UIImage){
        super.init(frame: CGRect(x: .makeHeight(414 - 375)/2, y: .makeHeight(200), width: .makeWidth(375), height: .makeWidth(375) * 160/375))
        self.layer.applySketchShadow(alpha: 0.3, y: .makeHeight(9), blur: .makeWidth(9), spread: .makeWidth(7), withRounding: .makeHeight(25))
        
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: .makeWidth(375), height: .makeWidth(375) * 160/375))
        self.addSubview(contentView)
        contentView.layer.cornerRadius = .makeHeight(25)
        contentView.layer.masksToBounds = true
        
        contentView.backgroundColor = .greyColor()
        
        
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.frame = contentView.bounds

        //375 x 50
        let overlay = UIView()
        overlay.frame = CGRect(x: 0, y: contentView.frame.height * 0.6875, width: contentView.frame.width, height: contentView.frame.height * 0.3125)
        contentView.addSubview(overlay)
        overlay.layer.compositingFilter = "multiplyBlendMode"
        
        let gradientOverlay = CAGradientLayer()
        gradientOverlay.frame = overlay.bounds
        gradientOverlay.colors = [UIColor.white.cgColor, UIColor.greyColor().cgColor]
        gradientOverlay.startPoint = CGPoint(x: 0.5, y: 0)
        gradientOverlay.endPoint = CGPoint(x: 0.5, y: 1)
        overlay.layer.insertSublayer(gradientOverlay, at: 1)
        
       
        label.text = event.title
        label.textColor = .white
        label.font = .poppinsMedium(size: .makeWidth(16))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        contentView.addSubview(label)
        label.setWidth(.makeWidth(220))
        label.anchor(bottom: overlay.bottomAnchor, paddingBottom: .makeHeight(15))
        label.anchor(left: overlay.leftAnchor, paddingLeft: .makeWidth(15))
        
       
        sideView.frame = CGRect(x: .makeWidth(262.5), y: 0, width: .makeWidth(112.5), height: contentView.frame.height)
        sideView.backgroundColor = .greyColor()
        contentView.addSubview(sideView)
        self.addProfileImage()
        
        //75x30
        let button = UIButton()
        button.backgroundColor = UIColor.init(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        button.layer.cornerRadius = .makeHeight(12)
        button.frame = CGRect(x: .makeWidth(18.5), y: contentView.frame.height * 120 / 160, width: .makeWidth(75), height: contentView.frame.height * 30 / 160)
        button.layer.applySketchShadow(alpha: 0.5, y: .makeHeight(7), blur: .makeWidth(9), spread: .makeWidth(-4), withRounding: .makeHeight(12))
        sideView.addSubview(button)
    //https://source.unsplash.com/random/?college%2Fparty/1060x837
        
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(12))
        
        let bellLabel = UILabel()
        bellLabel.text = "0"
        bellLabel.font = .poppinsMedium(size: .makeWidth(11.5))
        bellLabel.textColor = .white
        bellLabel.setWidth(18.5)
        let bellIcon = UIImageView(image: UIImage(systemName: "bell.fill", withConfiguration: config))
        bellIcon.tintColor = .white
        
        sideView.addSubview(bellLabel)
        bellLabel.anchor(left: newImageView.leftAnchor, paddingLeft: .makeWidth(8))
        bellLabel.anchor(top: newImageView.bottomAnchor, paddingTop: .makeWidth(375) * 20/375)
        
        sideView.addSubview(bellIcon)
        bellIcon.anchor(right: newImageView.leftAnchor, paddingRight: -.makeWidth(3))
        bellIcon.anchor(top: newImageView.bottomAnchor, paddingTop: .makeWidth(375) * 20/375)
        
       
        if let timeTillLive = event.startsAt?.timeIntervalSince(.now){
            var value: Int
            var unit: String?
            if timeTillLive >= 86400{
                value = Int(round(timeTillLive / 86400))
                unit = "d"
            }else if timeTillLive >= 3600{
                value = Int(round(timeTillLive / 3600))
                unit = "h"
            }else{
                value = Int(round(timeTillLive / 60))
                unit = "m"
            }
            timeLabel.text = "\(value)" + (unit ?? "")
        }else{
            timeLabel.text = "TBD"
        }
        
        
        
       
        timeLabel.font = .poppinsMedium(size: .makeWidth(11.5))
        timeLabel.textColor = .nearlyWhite()
        timeLabel.setWidth(.makeWidth(20))
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.numberOfLines = 1
       
        let timeIcon = UIImageView(image: UIImage(systemName: "clock.fill", withConfiguration: config))
        timeIcon.tintColor = .white
        
        sideView.addSubview(timeLabel)
        timeLabel.anchor(top: newImageView.bottomAnchor, paddingTop: .makeWidth(375) * 20/375)
        timeLabel.anchor(left: newImageView.rightAnchor, paddingLeft: -.makeWidth(3))
        
        sideView.addSubview(timeIcon)
        timeIcon.anchor(top: newImageView.bottomAnchor, paddingTop: .makeWidth(375) * 20/375)
        timeIcon.anchor(right: newImageView.rightAnchor, paddingRight: .makeWidth(8))
       
       
        
        imageView.image = image
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    func addProfileImage(){
   
    
    gradientView.layer.masksToBounds = true
    gradientView.frame = CGRect(x: .makeWidth(23.75), y: .makeHeight(10), width: .makeWidth(65), height: .makeWidth(65))
    gradientView.layer.cornerRadius = .makeWidth(25)
    sideView.addSubview(gradientView)
    
    let gradient = CAGradientLayer()
        gradient.colors = [EventCreationVC.shared.viewModel.colors!.primary.cgColor, EventCreationVC.shared.viewModel.colors!.secondary.cgColor, EventCreationVC.shared.viewModel.colors!.detail.cgColor]
    gradient.startPoint = CGPoint(x: 1, y: 0)
    gradient.endPoint = CGPoint(x: 0, y: 1)
    gradient.frame =  gradientView.bounds
    gradientView.layer.insertSublayer(gradient, at: 0)
    
    
    newImageView.contentMode = .scaleAspectFill
    newImageView.layer.masksToBounds = true
    newImageView.layer.cornerRadius = .makeWidth(23)
    newImageView.backgroundColor = .greyColor()
    newImageView.setDimensions(height: .makeWidth(61), width: .makeWidth(61))
    gradientView.addSubview(newImageView)
    newImageView.center(inView: self.gradientView)
    
    let randInt: Int = Int.random(in: 300...1920)
    let randInt2: Int = Int.random(in: 300...1920)
    newImageView.sd_setImage(with: URL(string: "https://source.unsplash.com/random/?person/\(randInt)x\(randInt2)"))
    }
    
    func updateView(){
        if let gradient = gradientView.layer.sublayers?[0] as? CAGradientLayer{
            gradient.colors = [EventCreationVC.shared.viewModel.colors!.primary.cgColor, EventCreationVC.shared.viewModel.colors!.secondary.cgColor, EventCreationVC.shared.viewModel.colors!.detail.cgColor]
        
        }
        label.text = EventCreationVC.shared.viewModel.eventTitle!
        
        imageView.image = EventCreationVC.initImage
        if let timeTillLive = EventCreationVC.shared.viewModel.startDate?.timeIntervalSince(Date()){
            var value: Int
            var unit: String
            if timeTillLive >= 86400{
                value = Int(round(timeTillLive / 86400))
                unit = "d"
            }else if timeTillLive >= 3600{
                value = Int(round(timeTillLive / 3600))
                unit = "h"
            }else{
                value = Int(round(timeTillLive / 60))
                unit = "m"
            }
            timeLabel.text = "\(value)" + unit
        }
    }
}
