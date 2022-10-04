//
//  UIViewExt.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/9/22.
//

import Foundation
import UIKit
extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
