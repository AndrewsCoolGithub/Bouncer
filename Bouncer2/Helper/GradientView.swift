//
//  GradientView.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/30/22.
//

import UIImageColors
import Foundation

enum Direction {
    case horizontal
    case vertical
}

extension UIView {
    /** should animate gradient changes, default is true*/
    
    var gradientColors: (colors: UIImageColors?, shouldAnimate: Bool)? {
        get{
            if let gradientColors = (self.layer.sublayers?.first(where: {$0 is CAGradientLayer}) as? CAGradientLayer)?.colors{
                return (colors: UIImageColors(background: .white, primary: UIColor(cgColor: gradientColors[0] as! CGColor), secondary:  UIColor(cgColor: gradientColors[0] as! CGColor), detail:  UIColor(cgColor: gradientColors[0] as! CGColor)), shouldAnimate: true)
            }else{
                return nil
            }
        }
        set{
            if let gradient = self.layer.sublayers?.first(where: {$0 is CAGradientLayer}) as? CAGradientLayer, let colors = newValue{
                if colors.shouldAnimate{
                    UIView.transition(with: self, duration: 1, options: [.transitionCrossDissolve, .allowUserInteraction]) {
                        gradient.colors = [colors.colors?.primary.cgColor, colors.colors?.secondary.cgColor, colors.colors?.detail.cgColor].compactMap({$0})
                    }
                }else{
                    gradient.colors = [colors.colors?.primary.cgColor, colors.colors?.secondary.cgColor, colors.colors?.detail.cgColor].compactMap({$0})
                }
               
            }else if let gradient = self.layer.sublayers?.first(where: {$0 is CAGradientLayer}) as? CAGradientLayer{
                
                gradient.colors = nil
            }
        }
    }
   
    convenience init(frame: CGRect? = nil, cornerRadius: CGFloat, colors: UIImageColors? = nil, uiColors: [UIColor]? = nil, lineWidth: CGFloat = 5, direction: Direction = .horizontal) {
        self.init(frame: frame ?? .zero)

        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
        
        let colorArray: [CGColor] = {
            if let colors = colors{
                return [colors.primary.cgColor, colors.secondary.cgColor, colors.detail.cgColor]
            }else if let uiColors = uiColors{
                return uiColors.map({$0.cgColor})
            }else{
                return Array(repeating: UIColor.greyColor().cgColor, count: 3)
            }
        }()
        gradient.colors = colorArray

        switch direction {
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 1, y: 1)
        case .vertical:
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 0, y: 1)
        }

        let shape = CAShapeLayer()
        shape.lineWidth = lineWidth
        shape.path = UIBezierPath(roundedRect: self.bounds.insetBy(dx: 0.45,
                                                                   dy: 0.45), cornerRadius: cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape

        self.layer.addSublayer(gradient)
        
    }
}


import UIKit

extension UIImage {

    func tintedWithLinearGradientColors(cgColors: [CGColor]? = nil, uiColors: [UIColor]? = nil, uiImageColors: UIImageColors? = nil) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
    guard let context = UIGraphicsGetCurrentContext() else {
        return UIImage()
    }
    context.translateBy(x: 0, y: self.size.height)
    context.scaleBy(x: 1, y: -1)

    context.setBlendMode(.normal)
    let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)

    // Create gradient
    let colors: CFArray? = {
        if let cgColors = cgColors {
            return cgColors as CFArray
        }else if let uiColors = uiColors {
            return uiColors.map({$0.cgColor}) as CFArray
        }else if let uiImageColors = uiImageColors {
            return [uiImageColors.primary.cgColor, uiImageColors.secondary.cgColor, uiImageColors.detail.cgColor] as CFArray
        }else{
            return nil
        }
    }()
        
    guard let colors = colors else {return self}
    let space = CGColorSpaceCreateDeviceRGB()
    let gradient = CGGradient(colorsSpace: space, colors: colors, locations: nil)
       
    // Apply gradient
    context.clip(to: rect, mask: self.cgImage!)
        context.drawLinearGradient(gradient!, start: CGPoint(x: 0, y: self.size.height), end: CGPoint(x: self.size.width, y: self.size.height), options: .drawsAfterEndLocation)
    let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return gradientImage!
    }
}
