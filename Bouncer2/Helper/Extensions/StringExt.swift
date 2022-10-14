//
//  StringExt.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/12/22.
//

import UIKit

extension String{
    
    func isValid(_ minCount: Int) -> Bool{
        return self.trimmingCharacters(in: .whitespacesAndNewlines).count >= minCount
    }
    
   
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }

    func sizeOfString(usingFont font: UIFont, maxHeight: CGFloat, maxWidth: CGFloat) -> CGSize {
        var width = self.widthOfString(usingFont: font)
        var numOfLines: CGFloat?
        if width > maxWidth{
            numOfLines = ceil(width / maxWidth)
            width = maxWidth
        }
            
        var height = self.heightOfString(usingFont: font)
        if let numOfLines = numOfLines{
            height = height * numOfLines
        }
        let size = CGSize(width: min(width, maxWidth), height: min(height, maxHeight))
//        print(size)
            
        return CGSize(width: min(width + 18, maxWidth), height: min(height + 16, maxHeight))
    }
}
