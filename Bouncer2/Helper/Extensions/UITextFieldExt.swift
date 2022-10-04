//
//  UITextFieldExt.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/9/22.
//

import Foundation
import UIKit

extension UITextField{
    
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
}
