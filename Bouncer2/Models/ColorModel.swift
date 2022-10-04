//
//  ColorModel.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/14/22.
//

import Foundation
import UIKit
///A codable color data structure, can be used in database
public struct ColorModel: Codable{
    var r: CGFloat
    var g: CGFloat
    var b: CGFloat
    
    func cgColor() -> CGColor{
        return UIColor(red: self.r, green: self.g, blue: self.b, alpha: 1).cgColor
    }
    
    func uiColor() -> UIColor{
        return UIColor(red: self.r, green: self.g, blue: self.b, alpha: 1)
    }
    
    func toDictionary() -> [String : CGFloat]{
        return ["r": self.r, "g": self.g, "b": self.b]
    }
}
