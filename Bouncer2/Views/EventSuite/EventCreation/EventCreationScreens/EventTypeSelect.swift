//
//  EventTypeSelect.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/2/22.
//

import Foundation
import UIImageColors
import UIKit

class EventTypeSelect: UIViewController{
    
    
    
    
    private let exclusiveButton: UIButton = {
        let button = UIButton(frame: CGRect(x: .makeWidth(414 - 140)/2, y: .makeHeight(55), width: .makeWidth(140), height: .makeWidth(140)), cornerRadius: .makeWidth(70), colors: UIImageColors(background: .buttonFill(), primary: .buttonFill(), secondary: .buttonFill(), detail: .buttonFill()), lineWidth: 2, direction: .horizontal)
        button.tag = 0
        button.setImage(UIImage(named: "ExclusiveIcon"), for: .normal)
        button.imageView?.setDimensions(height: .makeWidth(58), width: .makeWidth(70))
        button.backgroundColor = .greyColor()
        
        return button
    }()
    
    private let publicButton: UIButton = {
        let button = UIButton(frame: CGRect(x: .makeWidth(414 - 140)/2, y: .makeHeight(340), width: .makeWidth(140), height: .makeWidth(140)), cornerRadius: .makeWidth(70), colors: UIImageColors(background: .buttonFill(), primary: .buttonFill(), secondary: .buttonFill(), detail: .buttonFill()), lineWidth: 2, direction: .horizontal)
        button.tag = 1
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(65))
        button.setImage(UIImage(systemName: "mappin.and.ellipse", withConfiguration: config), for: .normal)
        button.backgroundColor = .greyColor()
        button.tintColor = .white
        
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let eventType = EventCreationVC.shared.viewModel.eventType{
            var selectedButton: UIButton {
                switch eventType {
                case .exclusive:
                    return self.exclusiveButton
                case .open:
                    return self.publicButton
                }
            }
            selectedButton.gradientColors = (EventCreationVC.shared.viewModel.colors, true)
            EventCreationVC.shared.navigator.activateButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EventCreationVC.shared.navigator.deactivateButton()
        
        view.addSubview(exclusiveButton)
        exclusiveButton.addTarget(self, action: #selector(selectType(sender:)), for: .touchUpInside)
        let exclabel = UILabel()
        exclabel.text = "Exclusive"
        exclabel.font = .poppinsMedium(size: .makeWidth(21))
        exclabel.textColor = .white
        view.addSubview(exclabel)
        exclabel.centerX(inView: exclusiveButton, topAnchor: exclusiveButton.bottomAnchor, paddingTop: .makeHeight(20))
        
        
        view.addSubview(publicButton)
        publicButton.addTarget(self, action: #selector(selectType(sender:)), for: .touchUpInside)
        let publabel = UILabel()
        publabel.text = "Public"
        publabel.font = .poppinsMedium(size: .makeWidth(21))
        publabel.textColor = .white
        view.addSubview(publabel)
        publabel.centerX(inView: publicButton, topAnchor: publicButton.bottomAnchor, paddingTop: .makeHeight(20))
    }
    
    
    var selectedType: EventType?
    let gradient = CAGradientLayer()
    @objc func selectType(sender: UIButton){
        EventCreationVC.shared.navigator.activateButton()
      //
        let eventType: EventType = sender.tag == 0 ? .exclusive : .open
        EventCreationVC.shared.viewModel.eventType = eventType
        switch eventType {
        case .exclusive:
            self.exclusiveButton.gradientColors = (EventCreationVC.shared.viewModel.colors, true)
            self.publicButton.gradientColors = (UIImageColors(background: .buttonFill(), primary: .buttonFill(), secondary: .buttonFill(), detail: .buttonFill()), true)
        case .open:
            self.publicButton.gradientColors = (EventCreationVC.shared.viewModel.colors, true)
            self.exclusiveButton.gradientColors = (UIImageColors(background: .buttonFill(), primary: .buttonFill(), secondary: .buttonFill(), detail: .buttonFill()), true)
        }
    }
}
