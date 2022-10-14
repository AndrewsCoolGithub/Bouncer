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
       // let myColors: [UIColor]
        //blue p p o o b
      
//        let colors = [User.colors.primary!, User.colors.secondary!, User.colors.secondary!, User.colors.detail!, User.colors.detail!, User.colors.primary!]
//        if let colors = User.defaultColors{
        setColors(User.defaultColors.colors)
//        }
        if let colors = User.shared.colors{
            setColors(colors.uiColors())
        }
        
        startAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
