//
//  EventCreationNavigator.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/30/22.
//

import Foundation
import UIKit
import UIImageColors

class EventCreationNavigator: UIView{
    
    let backButton: UIButton = {
        let button = UIButton(frame: CGRect(x: .makeWidth(40), y: .makeHeight(20), width: .makeWidth(50), height: .makeHeight(40)))
        button.backgroundColor = .clear
        button.setAttributedTitle(NSAttributedString(string: "Back", attributes:  [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single, NSAttributedString.Key.font: UIFont.poppinsMedium(size: .makeHeight(20)), NSAttributedString.Key.foregroundColor: UIColor.darkerGreyText()]), for: .normal)
        
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(frame: CGRect(x: .makeWidth(294), y: .makeHeight(15), width: .makeWidth(90), height: .makeHeight(50)), cornerRadius: .makeHeight(13.5), colors: EventCreationVC.colors, lineWidth: 1, direction: .horizontal)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .poppinsMedium(size: .makeHeight(20))
        button.layer.applySketchShadow(color: .black.withAlphaComponent(0.3), alpha: 1, x: 0, y: 3, blur: 6, spread: 4, withRounding: .makeHeight(13.5))
        button.backgroundColor = .greyColor()
        
        return button
    }()
    
    weak var gradientLayer: CAGradientLayer?
    
    init(){
        super.init(frame: CGRect(x: 0, y: .makeHeight(816), width: .makeWidth(414), height: .makeHeight(80)))
        backgroundColor = .greyColor()
        backButton.layer.opacity = 0
        addSubview(backButton)
        addSubview(nextButton)
    }
    
    func performAnimation(previous: CGFloat, progress: CGFloat, colors: UIImageColors){
        
        var previous: CGFloat = previous
        var progress: CGFloat = progress
        if let oldGradientMask = gradientLayer?.mask as? CAShapeLayer{
            progress =  previous < oldGradientMask.strokeStart ? oldGradientMask.strokeStart : progress
            previous =  progress < oldGradientMask.strokeEnd ? oldGradientMask.strokeEnd : previous
        }
        
        gradientLayer?.removeFromSuperlayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: frame.width, y: 0))

        // Gradient Mask
        let gradientMask = CAShapeLayer()
        gradientMask.fillColor = UIColor.clear.cgColor
        gradientMask.strokeColor = UIColor.black.cgColor
        gradientMask.lineWidth = 2
        gradientMask.frame = CGRect(x: 0, y: 1, width: .makeWidth(414), height: 2)
        gradientMask.path = path.cgPath
        gradientMask.strokeEnd = progress

        // Gradient Layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0)

        // make sure to use .cgColor
        gradientLayer.colors = [colors.primary.cgColor, colors.secondary.cgColor, colors.detail.cgColor]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: .makeWidth(414), height: 2)
        gradientLayer.mask = gradientMask
        layer.addSublayer(gradientLayer)
        
        self.gradientLayer = gradientLayer
    
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.fromValue = previous
        animation.toValue = progress
        
        animation.duration = 1
        gradientMask.add(animation, forKey: "LineAnimation")
        
        let oldGradient = nextButton.layer.sublayers?.first(where: {$0 is CAGradientLayer})
        
        //MARK: Updates next button gradient border

        if oldGradient != nil{
            let gradient = oldGradient as! CAGradientLayer
            UIView.transition(with: nextButton, duration: 2, options: [.transitionCrossDissolve, .allowUserInteraction]) {
                gradient.colors = [colors.primary.cgColor, colors.secondary.cgColor, colors.detail.cgColor]
            }
        }
    }
    
    func deactivateButton(){
        nextButton.isEnabled = false
        let gradient = nextButton.layer.sublayers?.first(where: {$0 is CAGradientLayer})
        gradient?.opacity = 0.0
        nextButton.layer.shadowPath = nil
    }
    
    func activateButton(){
        nextButton.isEnabled = true
        let gradient = nextButton.layer.sublayers?.first(where: {$0 is CAGradientLayer})
        gradient?.opacity = 1
        nextButton.layer.applySketchShadow(color: .black.withAlphaComponent(0.3), alpha: 1, x: 0, y: 3, blur: 6, spread: 4, withRounding: .makeHeight(13.5))
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
