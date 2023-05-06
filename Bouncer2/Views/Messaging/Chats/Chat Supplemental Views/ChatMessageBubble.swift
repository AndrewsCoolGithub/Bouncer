//
//  ChatMessageBubble.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/28/23.
//

import Pastel
import UIKit

class ChatMessageBubble: PastelView {
    
     init(frame: CGRect, colors: [UIColor]){
        super.init(frame: frame)
         
        startPastelPoint = .bottomLeft
        endPastelPoint = .topRight
        animationDuration = 5
        setColors(colors)
        startAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
