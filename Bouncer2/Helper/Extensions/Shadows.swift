//
//  Sketch.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/24/22.
//

import UIKit

extension CALayer {
  func applySketchShadow(
    color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4, spread: CGFloat = 0, withRounding: CGFloat = 0){
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = withRounding == 0 ? UIBezierPath(rect: rect).cgPath : UIBezierPath (roundedRect: rect, cornerRadius: withRounding).cgPath
            
        }
    }
    func removeShadow(){
        shadowOpacity = 0
        shadowOffset = .zero
        shadowRadius = 0
        shadowPath = nil
    }
    
    func defaultShadow(_ rounding: CGFloat){
        applySketchShadow(color: .black.withAlphaComponent(0.3), alpha: 1, x: 0, y: .wProportioned(6), blur: .makeWidth(9), spread: .makeWidth(5), withRounding: rounding)
    }
}
public class InnerShadowLayer: CAGradientLayer {

    

    public init(forView view: UIView,
                edge: Edge = Edge.Top,
                shadowRadius radius: CGFloat = 20.0,
                toColor: UIColor = UIColor.white,
                fromColor: UIColor = UIColor.black) {
        super.init()
        self.colors = [fromColor.cgColor, toColor.cgColor]
        self.shadowRadius = radius

        let viewFrame = view.frame

        switch edge {
            case .Top:
                startPoint = CGPoint(x: 0.5, y: 0.0)
                endPoint = CGPoint(x: 0.5, y: 1.0)
                self.frame = CGRect(x: 0.0, y: 0.0, width: viewFrame.width, height: shadowRadius)
            case .Bottom:
                startPoint = CGPoint(x: 0.5, y: 1.0)
                endPoint = CGPoint(x: 0.5, y: 0.0)
                self.frame = CGRect(x: 0.0, y: viewFrame.height - shadowRadius, width: viewFrame.width, height: shadowRadius)
            case .Left:
                startPoint = CGPoint(x: 0.0, y: 0.5)
                endPoint = CGPoint(x: 1.0, y: 0.5)
                self.frame = CGRect(x: 0.0, y: 0.0, width: shadowRadius, height: viewFrame.height)
            case .Right:
                startPoint = CGPoint(x: 1.0, y: 0.5)
                endPoint = CGPoint(x: 0.0, y: 0.5)
                self.frame = CGRect(x: viewFrame.width - shadowRadius, y: 0.0, width: shadowRadius, height: viewFrame.height)
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
public enum Edge {
    case Top
    case Left
    case Bottom
    case Right
}
