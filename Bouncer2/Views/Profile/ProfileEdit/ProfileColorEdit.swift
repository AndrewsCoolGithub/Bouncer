//
//  ProfileColorEdit.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/19/22.
//

import Foundation
import UIImageColors
import NVActivityIndicatorView
import UIKit

class ProfileColorEdit: UIViewController{
    
    fileprivate let components = ProfileColorEditViewComponents()
    unowned var viewModel: ProfileViewModel!
    init(viewModel: ProfileViewModel){
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.setupTopBar()
        self.setupUI(viewModel.colors)
        
        view.backgroundColor = .greyColor()
    }
    
    fileprivate func setupUI(_ colorModel: [ColorModel]){
        let color1 = components.colorDotOne
        createColor(button: color1, colorModel[0].uiColor(), index: 0)
        let color2 = components.colorDotTwo
        createColor(button: color2, colorModel[1].uiColor(), index: 1)
        let color3 = components.colorDotThree
        createColor(button: color3, colorModel[2].uiColor(), index: 2)
        
        
        let gradientLine = components.gradientLine
        gradientLine.setDimensions(height: .makeWidth(6), width: .makeWidth(380))
        let gradient: CAGradientLayer = gradientLine.layer.sublayers?.first(where: {$0 is CAGradientLayer}) as! CAGradientLayer
        gradient.colors = colorModel.cgColors()
        
        view.addSubview(gradientLine)
        gradientLine.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: .makeHeight(300))
        
        let infoLabel = components.infoLabel
        view.addSubview(infoLabel)
        
        infoLabel.anchor(top: gradientLine.bottomAnchor, left: gradientLine.leftAnchor, paddingTop: .makeWidth(30), paddingLeft: 0)
    
    }
    
    fileprivate func createColor(button: UIButton, _ color: UIColor, index: Int){
        button.tag = index
        button.aspectSetDimensions(height: 110, width: 110)
        button.backgroundColor = color
        button.layer.cornerRadius = .makeWidth(55)
        button.layer.masksToBounds = true
        //button.addTarget(self, action: #selector(openColorPicker(sender:)), for: .touchUpInside)
        view.addSubview(button)
        switch index{
        case 0:
            button.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: .makeHeight(110), paddingLeft: .makeWidth(15))
        case 1:
            button.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: .makeHeight(110))
        case 2:
            button.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: .makeHeight(110), paddingRight: .makeWidth(15))
        default:
            return
        }
        
        let colorWell = UIColorWell()
        view.addSubview(colorWell)
        colorWell.supportsAlpha = false
        colorWell.tag = index
        colorWell.selectedColor = color
        colorWell.title = "Color \(index+1)"
        colorWell.center(inView: button)
        colorWell.setDimensions(height: .makeWidth(220), width: .makeWidth(220))
       
        colorWell.addTarget(self, action: #selector(updateColor(sender:)), for: .valueChanged)

    }
    
    
    @objc fileprivate func updateColor(sender: UIColorWell){
        let tag = sender.tag
        
        switch tag{
        case 0:
            components.colorDotOne.backgroundColor = sender.selectedColor
        case 1:
            components.colorDotTwo.backgroundColor = sender.selectedColor
        case 2:
            components.colorDotThree.backgroundColor = sender.selectedColor
        default:
            return
        }
        guard let color = sender.selectedColor else {return}
        adjustGradientLine(color: color, index: tag)
    }
    
    func adjustGradientLine(color: UIColor, index: Int){
        guard let gradient = components.gradientLine.layer.sublayers?.first(where: {$0 is CAGradientLayer}) as? CAGradientLayer, let colors = gradient.colors as? [CGColor] else {return}
        switch index {
        case 0:
            let newColors = [color.cgColor, colors[1], colors[2]]
            gradient.colors = newColors
        case 1:
            let newColors = [colors[0], color.cgColor, colors[2]]
            gradient.colors = newColors
        case 2:
            let newColors = [colors[0], colors[1], color.cgColor]
            gradient.colors = newColors
        default:
            return
        }
    }
    
    fileprivate func setupTopBar() {
        let chevron = components.chevron
        view.addSubview(chevron)
        chevron.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: .makeHeight(13.5))
        chevron.anchor(left: view.leftAnchor, paddingLeft: .makeWidth(15))
        chevron.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        let headerLabel = components.headerLabel
        view.addSubview(headerLabel)
        headerLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: .makeHeight(10))
        headerLabel.text = "Colors"
        
        let doneButton = components.doneButton
        view.addSubview(doneButton)
        doneButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: .makeHeight(8.5))
        doneButton.anchor(right: view.rightAnchor, paddingRight: .makeWidth(15))
        doneButton.addTarget(self, action: #selector(finishNUpdate), for: .touchUpInside)
    }
    
    @objc fileprivate func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func finishNUpdate(){
        guard let gradient = components.gradientLine.layer.sublayers?.first(where: {$0 is CAGradientLayer}) as? CAGradientLayer, let colors = gradient.colors as? [CGColor] else {
            self.goBack()
            return
        }
        Task{
            components.indicator.startAnimating()
            view.addSubview(components.indicator)
            let colorModel = colors.map({UIColor(cgColor: $0).getColorModel()})
            try await AuthManager.shared.uploadColors(colorModel)
            viewModel.colors = colorModel
            components.indicator.stopAnimating()
            components.indicator.removeFromSuperview()
            navigationController?.popViewController(animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



private struct ProfileColorEditViewComponents{
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(24))
        label.textColor = .white
        label.textAlignment = .center
        label.setWidth(.makeWidth(200))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        return label
    }()
    
    let indicator: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: .layoutRect(width: 414, height: 896, rectCenter: .center), type: .ballPulseSync, color: .white, padding: 150)
        view.backgroundColor = .black.withAlphaComponent(0.2)
        return view
    }()
    
    let chevron: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: .makeHeight(30))
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .center
        return button
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .poppinsMedium(size: .makeWidth(20))
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
//        button.titleLabel?.textAlignment = .natural
        
        return button
    }()
    
    let colorDotOne: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    let colorDotTwo: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    let colorDotThree: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    let gradientLine: UIView = {
        let view = UIView(frame: .zero)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = .makeWidth(3)
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: .makeWidth(380), height: .makeWidth(6)))
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = nil
        view.gradientColors = UIImageColors.clear
        view.layer.addSublayer(gradient)
        return view
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text =
"""
Colors give your profile a unique look.
Tap each circle to modify the gradient.
"""
        
        label.numberOfLines = 2
        label.font = .poppinsMedium(size: .makeWidth(15))
        label.textAlignment = .left
        label.setWidth(.makeWidth(405))
        label.textColor = .nearlyWhite()
        
        return label
    }()
    
}
