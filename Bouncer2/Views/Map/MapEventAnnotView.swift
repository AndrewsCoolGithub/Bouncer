//
//  MapEventAnnotView.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/20/22.
//

import Foundation
import Mapbox
import SDWebImage

class MapEventAnnotView: MGLAnnotationView{
    
    lazy var skeletonGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        let animation = makeAnimationGroup()
        animation.beginTime = 0.0
        gradient.add(animation, forKey: "backgroundColor")
        gradient.frame = self.bounds
        return gradient
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: self.bounds.insetBy(dx: 1, dy: 1))
        imageView.layer.cornerRadius = .makeWidth(25)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    
    init(_ annot: MapEventAnnotation, id: String) {
        super.init(annotation: annot, reuseIdentifier: id)
        self.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: .makeWidth(50), height: .makeWidth(50)))
        
       
        isSelected = true
        layer.cornerRadius = .makeWidth(25)
        layer.masksToBounds = true
        layer.addSublayer(skeletonGradient)

        isUserInteractionEnabled = true
        addGradientLayer(annot.event.colors)
        
        imageView.sd_setImage(with: URL(string: annot.event.imageURL)!) { [unowned self] i, e, c, u in
            self.addSubview(self.imageView)
            self.skeletonGradient.removeFromSuperlayer()
        }
    }
    
    fileprivate func addGradientLayer(_ colors: [ColorModel]) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors.map({$0.cgColor()})
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = UIBezierPath(roundedRect: self.bounds.insetBy(dx: 1, dy: 1), cornerRadius: .makeWidth(25)).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        self.layer.addSublayer(gradient)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MapEventAnnotView: SkeletonLoadable{}
