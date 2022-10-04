//
//  StringExt.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/12/22.
//

import Foundation

extension String{
    
    func isValid(_ minCount: Int) -> Bool{
        return self.trimmingCharacters(in: .whitespacesAndNewlines).count >= minCount
    }
    
   
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
}
