//
//  UIImageColorsExt.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/10/22.
//

import Foundation
import UIImageColors

extension UIImageColors{
    
    public var colors: [UIColor] {
           return [primary, secondary, detail]
    }
    
    public var colorModel: [ColorModel] {
        let arrayForMapping = [self.primary, self.secondary, self.detail]
        return arrayForMapping.compactMap { $0?.getColorModel() }
    }
    
    static var clear: UIImageColors{
        return UIImageColors(background: .clear, primary: .clear, secondary: .clear, detail: .clear)
    }
    
//    static func clear() -> UIImageColors{
//        return UIImageColors(background: .clear, primary: .clear, secondary: .clear, detail: .clear)
//    }
}
