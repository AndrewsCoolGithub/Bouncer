//
//  Pastel.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/23/22.
//

import Foundation
import Pastel

class Pastel: PastelView{
    
    override init(frame: CGRect){
        super.init(frame: frame)
        startPastelPoint = .bottomLeft
        endPastelPoint = .topRight
        animationDuration = 5
      
        if let colors = User.shared.colors{
            setColors(colors.uiColors())
        }else{
            setColors(User.defaultColors.colors)
        }
        
        startAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
