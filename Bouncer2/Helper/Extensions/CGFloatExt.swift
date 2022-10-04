//
//  CGFloatExt.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/5/22.
//

import UIKit


extension CGFloat{
    func asRadians() -> CGFloat{
        return (self * CGFloat.pi)/180
    }
}
