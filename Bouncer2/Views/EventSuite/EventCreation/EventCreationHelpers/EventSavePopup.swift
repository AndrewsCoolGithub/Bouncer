//
//  EventSavePopup.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/18/22.
//

import Foundation
import UIKit
import UIImageColors

class EventSavePopup: UIViewController{

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        
        return view
    }()
    
    private let sheetView: UIView = {
        let view = UIView()
        view.aspectSetDimensions(height: 500, width: 360)
        view.layer.cornerRadius = .makeHeight(25)
        view.backgroundColor = .greyColor()
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        return view
    }()
    
    private let actionButton: ActionPopupButton = {
        let button = ActionPopupButton(frame: CGRect(x: 0, y: .makeHeight(370), width: .makeHeight(500) * 360/500, height: .makeHeight(65)))
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = .poppinsMedium(size: .makeWidth(18))
        let div = UIView()
        button.addSubview(div)
        div.setDimensions(height: 0.5, width: .makeHeight(500) * 360/500)
        div.centerX(inView: button, topAnchor: button.topAnchor)
        div.backgroundColor = .darkGray
        button.tag = 0
        return button
    }()
    
    private let cancelButton: CancelPopupButton = {
        let button = CancelPopupButton(frame: CGRect(x: 0, y: .makeHeight(500) - .makeHeight(65), width: .makeHeight(500) * 360/500, height: .makeHeight(65)))
        button.setTitle("Discard", for: .normal)
        button.titleLabel?.font = .poppinsMedium(size: .makeWidth(18))
        button.setTitleColor(.nearlyWhite(), for: .normal)
         
        let div = UIView()
        button.addSubview(div)
        div.setDimensions(height: 0.5, width: .makeHeight(500) * 360/500)
        div.centerX(inView: button, topAnchor: button.topAnchor)
        div.backgroundColor = .darkGray
        button.tag = 1
        return button
    }()
    
    private let icon: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: .makeHeight(100))
        let iv = UIImageView(image: UIImage(systemName: "square.and.pencil", withConfiguration: config)?.tintedWithLinearGradientColors(uiImageColors: EventCreationVC.colors))
        
        return iv
    }()
    
    private let primaryLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeHeight(26))
        label.textColor = .white
        label.text = "Save your progress"
        label.textAlignment = .center
        
        return label
    }()
    
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsRegular(size: .makeHeight(17.5))
        label.textColor = .nearlyWhite()
        label.text = "When all of the details are figured out start where you left off."
        label.setWidth(.makeHeight(500) * 320/500)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center

        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let config = UIImage.SymbolConfiguration(pointSize: .makeHeight(100))
        self.icon.image = UIImage(systemName: "square.and.pencil", withConfiguration: config)?.tintedWithLinearGradientColors(uiImageColors: EventCreationVC.shared.viewModel.colors)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false
        view.backgroundColor = .clear
        
        backgroundView.frame = view.bounds
        view.addSubview(backgroundView)
        view.addSubview(sheetView)
        sheetView.center(inView: view)
        
        //Icon
        sheetView.addSubview(icon)
        icon.centerX(inView: sheetView, topAnchor: sheetView.topAnchor, paddingTop: .makeHeight(55))
        
        //Primary Label
        sheetView.addSubview(primaryLabel)
        primaryLabel.centerX(inView: sheetView, topAnchor: sheetView.topAnchor, paddingTop: .makeHeight(215))
        
        //Secondary Label
        sheetView.addSubview(secondaryLabel)
        secondaryLabel.centerX(inView: sheetView, topAnchor: sheetView.topAnchor, paddingTop: .makeHeight(270))
        
        //Action Button
        sheetView.addSubview(actionButton)
        actionButton.cancelButton = cancelButton
        actionButton.setTitleColor(self.gradientColor(bounds: self.actionButton.titleLabel!.bounds.insetBy(dx: -.makeWidth(10), dy: 0), colors: EventCreationVC.colors), for: .normal)

        //Discard Button
        sheetView.addSubview(cancelButton)
        cancelButton.actionButton = actionButton
        
        UIView.animate(withDuration: 0.5) {
            self.backgroundView.alpha = 0.5
        }
    }
    
    func gradientColor(bounds: CGRect, colors: UIImageColors) -> UIColor? {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [colors.primary.cgColor, colors.secondary.cgColor, colors.detail.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 1)
        gradient.endPoint = CGPoint(x: 1.0, y: 1)
        UIGraphicsBeginImageContext(gradient.bounds.size)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image!)
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        
        let location = touches.first!.location(in: self.view)
        let view = self.view.hitTest(location, with: event)
        
        if view is ActionPopupButton{
            actionButton.select()
        }else if view is CancelPopupButton{
            cancelButton.select()
        }else{
            cancelButton.backgroundColor = .clear
            actionButton.backgroundColor = .clear
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        cancelButton.backgroundColor = .clear
        actionButton.backgroundColor = .clear
        
        let location = touches.first!.location(in: self.view)
        let view = self.view.hitTest(location, with: event)
        if view is ActionPopupButton{
            actionButton.triggered()
        }else if view is CancelPopupButton{
            cancelButton.triggered()
        }
    }
}

//MARK: - BUTTON STUFF (Don't look ☹️)
class CancelPopupButton: UIButton{
    var actionButton: ActionPopupButton?
    
    internal func start(){
        HapticsManager.shared.selectionVibration()
        self.backgroundColor = .nearlyBlack()
    }
    
    internal func select(){
        if actionButton?.backgroundColor == .nearlyBlack(){
            HapticsManager.shared.selectionVibration()
        }
        
        self.backgroundColor = .nearlyBlack()
        actionButton?.backgroundColor = .clear
    }
    
    internal func deselect(){
        if self.backgroundColor == .nearlyBlack(){
            HapticsManager.shared.selectionVibration()
        }
       
        actionButton?.backgroundColor = .nearlyBlack()
        self.backgroundColor = .clear
    }
    
    internal func end(){
        self.backgroundColor = .clear
        self.actionButton?.backgroundColor = .clear
    }
    
    internal func triggered(){
        self.actionButton = nil
        EventCreationVC.shared.dismiss()
    }
}

class ActionPopupButton: UIButton{
    var cancelButton: CancelPopupButton?
    
    internal func start(){
        HapticsManager.shared.selectionVibration()
        self.backgroundColor = .nearlyBlack()
    }
    
    internal func select(){
        if cancelButton?.backgroundColor == .nearlyBlack(){
            HapticsManager.shared.selectionVibration()
        }
        
        self.backgroundColor = .nearlyBlack()
        cancelButton?.backgroundColor = .clear
    }
    
    internal func deselect(){
        if self.backgroundColor == .nearlyBlack(){
            HapticsManager.shared.selectionVibration()
        }
       
        cancelButton?.backgroundColor = .nearlyBlack()
        self.backgroundColor = .clear
    }
    
    internal func end(){
        self.backgroundColor = .clear
        self.cancelButton?.backgroundColor = .clear
    }
    
    internal func triggered(){
        self.cancelButton = nil
        EventCreationVC.shared.save()
    }
}

extension CancelPopupButton{
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){

        let actionButton = actionButton!
        let location = touches.first!.location(in: self)
        let otherLocation = touches.first!.location(in: actionButton)
        
        
        if self.hitTest(location, with: event) != nil{
            self.select()
            
        }else if actionButton.hitTest(otherLocation, with: event) != nil{
            self.deselect()
            
        }else{
            self.end()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.start()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        let actionButton = actionButton!
        self.backgroundColor = .clear
        actionButton.backgroundColor = .clear
        
        let location = touches.first!.location(in: self)
        let otherLocation = touches.first!.location(in: actionButton)
        
        if self.hitTest(location, with: event) != nil{
            //CANCEL
            self.triggered()
        }else if actionButton.hitTest(otherLocation, with: event) != nil{
            //ACTION
            actionButton.triggered()
        }
    }
}

extension ActionPopupButton{
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){

        let cancelButton = cancelButton!
        let location = touches.first!.location(in: self)
        let otherLocation = touches.first!.location(in: cancelButton)
        
        if self.hitTest(location, with: event) != nil{
            self.select()
            
        }else if cancelButton.hitTest(otherLocation, with: event) != nil{
            self.deselect()
        }else{
            self.end()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.start()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        let cancelButton = cancelButton!
        self.backgroundColor = .clear
        cancelButton.backgroundColor = .clear
        
        let location = touches.first!.location(in: self)
        let otherLocation = touches.first!.location(in: cancelButton)
        
        if self.hitTest(location, with: event) != nil{
           //ACTION
            self.triggered()
        }else if cancelButton.hitTest(otherLocation, with: event) != nil{
           //CANCEL
            cancelButton.triggered()
        }
    }
}
