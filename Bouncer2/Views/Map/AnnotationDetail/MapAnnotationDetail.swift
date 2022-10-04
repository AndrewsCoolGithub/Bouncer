//
//  MapAnnotationDetail.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/21/22.
//

import Foundation
import UIKit

protocol Navigatable: AnyObject{
    func navigate(to event: Event)
}

class MapAnnotationDetailCell: UICollectionViewCell, SkeletonLoadable {
    
    
    static let id = "annotation-detail-cell"
    weak var delegate: Navigatable?
    
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
    
    private let eventImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: .makeWidth(12), y: .makeWidth(12), width: .makeWidth(76), height: .makeWidth(76)))
        imageView.layer.cornerRadius = .makeWidth(38)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: .makeWidth(100), y: .makeWidth(22), width: .makeWidth(148), height: .makeHeight(25)))
        label.font = .poppinsMedium(size: .makeWidth(16))
        label.numberOfLines = 1

        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(frame: CGRect(x: .makeWidth(262), y: .makeWidth(22.05), width: .makeWidth(60), height: .makeWidth(60)))
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(26))
        button.setImage(UIImage(systemName: "location.fill", withConfiguration: config), for: .normal)
        button.backgroundColor = .greyColor()
        button.layer.cornerRadius = .makeWidth(18)
        button.layer.masksToBounds = true
        button.tintColor = .white
        return button
    }()
    
    fileprivate let buttonBackgroundGradient: UIView = { // 65 x 65
        let gradientView = UIView(frame: CGRect(x: .makeWidth(260), y: .makeWidth(20), width: .makeWidth(64), height: .makeWidth(64)))
        gradientView.layer.masksToBounds = true
        gradientView.layer.cornerRadius = .makeWidth(20)
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: gradientView.frame.size)
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        gradientView.layer.addSublayer(gradient)
        return gradientView
    }()
    
    
    var event: Event!
    func setup(_ event: Event){
        self.event = event
        backgroundColor = .greyColor()
        layer.cornerRadius = .makeWidth(20)
        layer.masksToBounds = true
        layer.applySketchShadow(color: .nearlyBlack().withAlphaComponent(0.3), alpha: 1, x: 0, y: .makeHeight(4), blur: .makeWidth(7), spread: .makeWidth(3), withRounding: .makeWidth(15))
        

            addImage(event: event, image: nil)
            addTitle(event: event)
            addButton(event: event)
       
        
        
    }
    
    fileprivate func addButton(event: Event) {
        contentView.addSubview(buttonBackgroundGradient)
        if let gradientLayer = buttonBackgroundGradient.layer.sublayers?.first(where: {$0 is CAGradientLayer}) as? CAGradientLayer{
            gradientLayer.colors = event.colors.map({$0.cgColor()})
        }
        contentView.addSubview(actionButton)
        actionButton.addTarget(self, action: #selector(navigate), for: .touchUpInside)
    }
    
    @objc func navigate(){
        delegate?.navigate(to: event)
    }
    
    fileprivate func addTitle(event: Event) {
        contentView.addSubview(titleLabel)
        titleLabel.text = event.title
    }
    
    fileprivate func addImage(event: Event, image: UIImage?) {
        addGradientLayer(to: eventImageView, cornerRadius: .makeWidth(38), colors: event.colors)
        if let image = image{
            eventImageView.image = image
        }else{
            eventImageView.layer.addSublayer(skeletonGradient)
            eventImageView.sd_setImage(with: URL(string: event.imageURL)) { [weak self] i, e, c, u in
                self?.skeletonGradient.removeFromSuperlayer()
            }
        }
        contentView.addSubview(eventImageView)
    }
    
    fileprivate func addGradientLayer(to view: UIView, cornerRadius: CGFloat, colors: [ColorModel]) {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = colors.map({$0.cgColor()})
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.path = UIBezierPath(roundedRect: view.bounds.insetBy(dx: 1, dy: 1), cornerRadius: cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        view.layer.addSublayer(gradient)
    }
}
