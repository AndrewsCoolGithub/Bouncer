//
//  EventPreviewHeader.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/12/22.
//

import Foundation
import UIKit
class EventPreviewHeader: UIView{
    
    var isAnimatingFromButton: Bool = false
    
    let slider: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: .makeHeight(27), width: .makeWidth(414) * 0.33, height: .makeHeight(4)))
        view.layer.masksToBounds = true
        view.layer.cornerRadius = .makeHeight(2)
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: view.frame.size)
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = EventCreationVC.colors.colors.map({$0.cgColor})
        view.layer.addSublayer(gradient)
    
        return view
    }()
    
    public var buttons = [UIButton]()
    init(buttonTitles: [String]){
        super.init(frame: CGRect(x: 0, y: .makeHeight(20), width: .makeWidth(414), height: .makeHeight(45)))
        
        var tag: Int = 0
        
        self.buttons = buttonTitles.map({ title -> UIButton in
            let button = createButton(title: title, tag: tag)
            addSubview(button)
            tag += 1
            return button
        })
        addSubview(slider)
    }
    
    private func createButton(title: String, tag: Int) -> UIButton{
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: .makeWidth(414) * 0.33, height: .makeHeight(25)))
        button.backgroundColor = .clear
        button.setTitle(title, for: .normal)
        button.tag = tag
        button.titleLabel?.font = .poppinsMedium(size: .makeWidth(18))
        button.titleLabel?.textAlignment = .center
        
        if tag == 0{
            button.setTitleColor(.white, for: .normal)
        }else{
            button.setTitleColor(.nearlyWhite(), for: .normal)
        }
        
        switch tag{
        case 0:
            button.center = CGPoint(x: .makeWidth(414) * (0.175), y: .makeHeight(10))
        case 1:
            button.center = CGPoint(x: .makeWidth(414) * (0.5), y: .makeHeight(10))
        case 2:
            button.center = CGPoint(x: .makeWidth(414) * (0.825), y: .makeHeight(10))
        default:
            break
        }
        return button
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var lastIndex: Int? = 0
    func animateToPosition(_ index: Int, fromButton: Bool = false){
        isAnimatingFromButton = true
        switch index {
        case 0:
            if lastIndex == 2{
                self.pacManAnimation(.forward)
                self.lastIndex = index
            }else{
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear, .beginFromCurrentState]) {
                    self.slider.frame.origin.x = 0
                    self.lastIndex = index
                } completion: { _ in
                    self.isAnimatingFromButton = false
                }
            }
        case 1:
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear, .beginFromCurrentState]) {
                self.slider.frame.origin.x = .makeWidth(414) * 0.33
                self.lastIndex = index
            } completion: { _ in
                self.isAnimatingFromButton = false
            }
        case 2:
            if lastIndex == 0{
                self.pacManAnimation(.backward)
                self.lastIndex = index
            }else{
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear, .beginFromCurrentState]) {
                    self.slider.frame.origin.x = .makeWidth(414) * 0.66
                    self.lastIndex = index
                }completion: { _ in
                    self.isAnimatingFromButton = false
                }
            }
        default:
            break
        }
        
        
        let previous = self.buttons.first(where: {$0.titleColor(for: .normal) == .white})
        previous?.setTitleColor(.nearlyWhite(), for: .normal)
        self.buttons[index].setTitleColor(.white, for: .normal)
    }
    
    func pacManAnimation(_ direction: AnimationDirection){
        if direction == .forward{
            UIView.animate(withDuration: 0.12, delay: 0, options: [.curveLinear, .beginFromCurrentState]) {
                self.slider.frame.origin.x = .makeWidth(414) * 1
            }completion: {  [weak self] _ in
                self?.slider.frame.origin.x = -(self?.slider.frame.width ?? .makeWidth(414) * 0.33)
                UIView.animate(withDuration: 0.15, delay: 0, options: [.curveLinear, .beginFromCurrentState]) {
                    self?.slider.frame.origin.x = 0
                }completion: { _ in
                    self?.isAnimatingFromButton = false
                }
            }
        }else{
            UIView.animate(withDuration: 0.12, delay: 0, options: [.curveLinear, .beginFromCurrentState]) {
                self.slider.frame.origin.x = -(self.slider.frame.width)
            }completion: { [weak self] _ in
                self?.slider.frame.origin.x = .makeWidth(414) * 1
                UIView.animate(withDuration: 0.15, delay: 0, options: [.curveLinear, .beginFromCurrentState]) {
                    self?.slider.frame.origin.x = .makeWidth(414) * 0.66
                }completion: { _ in
                    self?.isAnimatingFromButton = false
                }
            }
        }
    }
    
    func translateSlider(change: CGFloat){
        if change != 1.0 && change != 0.0 && !isAnimatingFromButton{
            guard let lastIndex = lastIndex else {return}
            var startPosition: CGFloat{
                switch lastIndex{
                case 0:
                    return 0
                case 1:
                    return 0.33
                case 2:
                    return 0.66
                default:
                    return 0
                }
            }
            self.slider.frame.origin.x = ((self.slider.frame.width * change) + (.makeWidth(414) * startPosition))
        }
    }
    
    enum AnimationDirection{
        case forward
        case backward
    }
}
