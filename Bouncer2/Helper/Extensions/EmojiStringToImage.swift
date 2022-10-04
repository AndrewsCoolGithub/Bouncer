//
//  EmojiStringToImage.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 9/13/22.
//

import UIKit

extension String {
    ///Uses .makeWidth for sizing and width val for font size
    func emojiStringToImage(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.poppinsMedium(size: .makeWidth(size.width))])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
