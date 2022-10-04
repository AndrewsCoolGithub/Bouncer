//
//  PastelButton.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/9/22.
//

import Foundation
import UIKit

class PastelButton: UIButton{
    let pastelView = Pastel()
    let background = PastelButtonForeground()
    unowned var upperView: UIView!
    
   
    convenience init(frame: CGRect, cornerRadius: CGFloat, upperView: UIView, selector: Selector? = nil) {
        self.init()
       
        self.upperView = upperView
        self.frame = frame
        self.layer.cornerRadius = cornerRadius
       
//        pastelView.setColors(User.colors.colors + User.colors.colors.reversed().dropFirst())
        
        pastelView.frame = self.bounds.insetBy(dx: -1, dy: -1)
        pastelView.layer.cornerRadius = cornerRadius
        pastelView.layer.masksToBounds = true
        addSubview(pastelView)
        sendSubviewToBack(pastelView)
        background.frame = self.bounds
        
        background.layer.cornerRadius = cornerRadius
        background.layer.masksToBounds = true
        background.isUserInteractionEnabled = true
        addSubview(background)
        layer.applySketchShadow(color: .black.withAlphaComponent(0.3), alpha: 1, x: 0, y: 3, blur: 6, spread: 5, withRounding: cornerRadius)
        if let selector = selector{
            let tapGesture = UITapGestureRecognizer(target: upperView.next, action: selector)
            background.addGestureRecognizer(tapGesture)
        }
        pastelView.startAnimation()
    }
    
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        background.image = image
    }
    
    func shake() {
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        translation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]
        
        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [translation]
        shakeGroup.duration = 0.6
        self.layer.add(shakeGroup, forKey: "shakeIt")
        
        HapticsManager.shared.vibrate(for: .warning)
    }
    
    
    //    buttonPastelView.frame = createButton.frame.insetBy(dx: -1, dy: -1)
//    buttonPastelView.layer.cornerRadius = createButton.layer.cornerRadius
//    buttonPastelView.layer.masksToBounds = true
}

class PastelButtonForeground: UIImageView{
}
