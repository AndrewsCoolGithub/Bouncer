//
//  SegmentView.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/12/22.
//

import Foundation
import UIKit
protocol CustomSegmentedControlDelegate:AnyObject {
    func change(to index:Int)
}

class CustomSegmentedControl: UIView {
   
    private var buttonTitles: [String]!
    private var buttons: [UIButton]!
    private var selectorView: UIView!
    
    var textColor: UIColor = .white
    var selectorViewColor: UIColor = .lightGreyColor2()
    var selectorTextColor: UIColor = .white
    
    weak var delegate: CustomSegmentedControlDelegate?
    
    public private(set) var selectedIndex : Int = 0
    
    convenience init(frame:CGRect,buttonTitle:[String]) {
        self.init(frame: frame)
        self.buttonTitles = buttonTitle
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
//        self.layer.cornerRadius = self.frame.height * 0.5
//        self.layer.masksToBounds = true
        
        updateView()
        
        
    }
    
    func setButtonTitles(buttonTitles:[String]) {
        self.buttonTitles = buttonTitles
        self.updateView()
    }
    
    func setIndex(index:Int) {
        buttons.forEach({ $0.setTitleColor(textColor, for: .normal) })
        let button = buttons[index]
        selectedIndex = index
        delegate?.change(to: selectedIndex)
        button.setTitleColor(selectorTextColor, for: .normal)
        let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(index)
        UIView.animate(withDuration: 0.2) {
            self.selectorView.frame.origin.x = selectorPosition
        }
    }
    
    @objc func buttonAction(sender:UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                selectedIndex = buttonIndex
                delegate?.change(to: selectedIndex)
                
                
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }
}

//Configuration View
extension CustomSegmentedControl {
    private func updateView() {
        createButton()
        configSelectorView()
        configStackView()
        
    }
    
    private func configStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    private func configSelectorView() {
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        selectorView = UIView(frame: CGRect(x: 0, y: frame.height - 3, width: selectorWidth, height: .makeHeight(4)))
        selectorView.layer.cornerRadius = .makeHeight(2)
        selectorView.layer.masksToBounds = true
        selectorView.backgroundColor = selectorViewColor
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: selectorView.frame.size)
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = User.shared.colors.cgColors()
        selectorView.layer.addSublayer(gradient)
        addSubview(selectorView)
        //NotificationCenter.default.post(name: .segmentedViewFinished, object: nil)
    }
    
//    private let slider: UIView = {
//        let view = UIView(frame: CGRect(x: 0, y: .makeHeight(27), width: .makeWidth(414) * 0.33, height: .makeHeight(4)))
//        view.layer.masksToBounds = true
//        view.layer.cornerRadius = .makeHeight(2)
//        let gradient = CAGradientLayer()
//        gradient.frame = CGRect(origin: CGPoint.zero, size: view.frame.size)
//        gradient.startPoint = CGPoint(x: 0, y: 1)
//        gradient.endPoint = CGPoint(x: 1, y: 1)
//        gradient.colors = User.colors.colors.map({$0.cgColor})
//        view.layer.addSublayer(gradient)
//    
//        return view
//    }()
    
    private func createButton() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = .poppinsMedium(size: .makeWidth(18))
            button.addTarget(self, action:#selector(CustomSegmentedControl.buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            buttons.append(button)
        }
        
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
       
    }
    
    
}
