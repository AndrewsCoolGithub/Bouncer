//
//  Doubles.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 9/29/22.
//

import Foundation

extension Double {
    func rounded(_ decimalPlaces: Int) -> Double {
        return Double(String(format: "%.\(decimalPlaces)f", self))!
    }
    
}
