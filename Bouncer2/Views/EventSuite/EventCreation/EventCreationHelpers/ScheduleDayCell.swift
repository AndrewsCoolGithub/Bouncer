//
//  ScheduleCV.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/4/22.
//

import Foundation
import UIKit

class ScheduleDayCell: UICollectionViewCell{
    
    static let id = "days-schedule"
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        content?.removeFromSuperview()
        self.content = nil
        
        
    }
    override var isSelected: Bool { didSet{
        switch isSelected{
        case true:
            self.didSelect()
        case false:
            self.deselect()
        }
    }}
    public var content: UIView?
    
    private lazy var gradient: CAGradientLayer = {
        //make gradient
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.colors = [EventCreationVC.colors.primary.cgColor, EventCreationVC.colors.secondary.cgColor, EventCreationVC.colors.detail.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        //make shape
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = UIBezierPath(roundedRect: self.bounds.insetBy(dx: 1 / 2, dy: 1 / 2), cornerRadius: .makeWidth(35)).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        
        //make shape gradient mask
        gradient.mask = shape
        
        return gradient
    }()
    
    func setupCell(_ date: Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E,dd"
        
        let string = dateFormatter.string(from: date)
        let components = string.components(separatedBy: ",")
        let dayOfTheWeek = components[0]
        let dayOfTheMonth = components[1]
        
        let today = dateFormatter.string(from: Date())
        let todayComponents = today.components(separatedBy: ",")
        
        self.content = UIView(frame: CGRect(x: 0, y: 0, width: .makeWidth(85), height: .makeWidth(85)))
        
       
        
        guard let content = content else {
            return
        }

        content.backgroundColor = .greyColor()
        
           
        if dayOfTheWeek == todayComponents[0] && dayOfTheMonth == todayComponents[1]{
            let middleLabel = UILabel()
            middleLabel.text = "Today"
            middleLabel.font = .poppinsRegular(size: .makeWidth(18.5))
            middleLabel.textColor = .white
            content.addSubview(middleLabel)
            middleLabel.center(inView: content)
            
                
            
           
           
        }else{
            let topLabel = UILabel()
            topLabel.text = dayOfTheWeek
            topLabel.textColor = .white
            topLabel.font = .poppinsRegular(size: .makeWidth(20))
            content.addSubview(topLabel)
            topLabel.centerX(inView: content, topAnchor: content.topAnchor, paddingTop: .makeWidth(14))
            
            
            let bottomLabel = UILabel()
            bottomLabel.text = dayOfTheMonth
            bottomLabel.textColor = .white
            bottomLabel.font = .poppinsRegular(size: .makeWidth(20))
            content.addSubview(bottomLabel)
            bottomLabel.centerXBottom(inView: content, bottomAnchor: content.bottomAnchor, paddingBottom: .makeWidth(14))
        }
       
        
        content.layer.cornerRadius = .makeWidth(35)
        content.layer.borderWidth = 1
        content.layer.borderColor = UIColor.buttonFill().cgColor
        contentView.layer.applySketchShadow(color: .black.withAlphaComponent(0.3), alpha: 1, x: 0, y: 6, blur: 9, spread: 5, withRounding: .makeWidth(35))
        if isSelected{
            self.didSelect()
        }
        contentView.addSubview(content)
    }
    
    func didSelect(){
        guard let content = content else {
            return
        }
        //add gradient to view
        
        content.layer.borderWidth = 0
        content.layer.addSublayer(gradient)
    }
    
    func deselect(){
        gradient.removeFromSuperlayer()
        
        guard let content = content else {
            return
        }
        
        content.layer.borderColor = UIColor.buttonFill().cgColor
        content.layer.borderWidth = 1
    }
}
