//
//  ChatHeaderBackground.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/28/23.
//

import Pastel
import UIKit

class ChatHeaderBackground: PastelView {
    
     init(frame: CGRect, colors: [UIColor]){
        super.init(frame: frame)
         
        startPastelPoint = .bottomLeft
        endPastelPoint = .topRight
        animationDuration = 5
        setColors(colors)
        startAnimation()
         
        let shader = UIView()
        shader.frame = self.bounds

        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        gradient.colors = [CGColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.5),
                        CGColor(red: 1, green: 1, blue: 1, alpha: 0)]
        gradient.frame = shader.bounds

        shader.layer.addSublayer(gradient)
        self.addSubview(shader)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
