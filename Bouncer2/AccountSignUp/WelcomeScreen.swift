//
//  WelcomeScreen.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/5/22.
//

import Foundation
import UIKit


class WelcomeScreen: UIViewController{
    
    let transformLayer = CATransformLayer()
    var currentAngle: CGFloat = 0
    var currentOffset: CGFloat = 0
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Bouncer"
        label.font = .poppinsMedium(size: .makeWidth(28))
        label.textColor = .white
        let label2 = UILabel()
        label2.text = "where adventure is made"
        label2.font = .poppinsMedium(size: .makeWidth(18))
        label2.textColor = .white
        label.addSubview(label2)
        label2.centerX(inView: label, topAnchor: label.topAnchor, paddingTop: .makeHeight(55))
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .greyColor()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panned(sender:)))
        view.addGestureRecognizer(panGesture)
        view.addSubview(topLabel)
        topLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: .makeHeight(50))
        
        transformLayer.frame = self.view.bounds
        view.layer.addSublayer(transformLayer)
        
        
        
        
        addCards()
        
        
        turnCarousel()
    }
    
    func addCards(){
        let layer = CALayer()
        
        let view = UIView(frame: .layoutRect(width: 614, height: 700, rectCenter: .centerX, padding: Padding(anchor: .top, padding: .makeHeight(189))))
        
        
        let card1 = UIImageView(frame: .layoutRect(width: 375, height: 180, padding: Padding(anchor: .top, .left, padding: 0, .makeWidth(110)), keepAspect: true))
        card1.image = UIImage(named: "card1")
        view.addSubview(card1)
        
        let card2 = UIImageView(frame: .layoutRect(width: 375, height: 180, padding: Padding(anchor: .top, .left, padding: .makeHeight(225), .makeWidth(220)), keepAspect: true))
        card2.image = UIImage(named: "card2")
        view.addSubview(card2)
        
        let card3 = UIImageView(frame: .layoutRect(width: 375, height: 180, padding: Padding(anchor: .bottom, .left, padding: .makeHeight(55 + 189), 0), keepAspect: true))
        card3.image = UIImage(named: "card3")
        view.addSubview(card3)
        
        
        layer.frame = view.frame
        guard let image = view.asImage().cgImage else {
            return
        }
        print(image)
       
        layer.contents = image
        layer.contentsGravity = .resizeAspectFill
        layer.masksToBounds = true
        
        layer.isDoubleSided = false
        
        transformLayer.addSublayer(layer)
    }
    
    func addNavigationDemo(){
        
    }
    
    @objc func panned(sender: UIPanGestureRecognizer){
        let xTranslation = sender.translation(in: view).x * 1.4
        
        if sender.state == .began{
            currentOffset = 0
        }
        
        
        let xDistance = xTranslation * 0.6 - currentOffset
        
        currentOffset += xDistance
        currentAngle += xDistance
        
        turnCarousel()
    }
    
    func turnCarousel(){
        guard let transformSubLayers = transformLayer.sublayers else {return}
        let segmentForImageCard = CGFloat(360 / transformSubLayers.count)
        
        var angleOffset = currentAngle
        
        for layer in transformSubLayers {
            var transform = CATransform3DIdentity
            transform.m34 = -0.00005
            transform = CATransform3DRotate(transform, angleOffset.asRadians(), 0, 1, 0)
            transform = CATransform3DTranslate(transform, 0, 0, 200)
            
            CATransaction.setAnimationDuration(0)
            
            layer.transform = transform
            
            angleOffset += 60
        }
    }
}
