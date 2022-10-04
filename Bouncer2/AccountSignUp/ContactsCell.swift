//
//  ContactsCell.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/7/22.
//

import Foundation
import UIKit
import Pastel

class ContactsCell: UICollectionViewCell{
    
    static let id = "contact-cell"
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(20))
        label.textAlignment = .left
        label.setWidth(.makeWidth(200))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textColor = .white
        return label
    }()
    
    fileprivate let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(18))
        label.textAlignment = .left
        label.setWidth(.makeWidth(200))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textColor = .nearlyWhite()
        return label
    }()
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: .makeWidth(10), y: .makeWidth(10), width: .makeWidth(80), height: .makeWidth(80)))
        imageView.layer.cornerRadius = .makeWidth(40)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        let randInt: Int = Int.random(in: 0...29)
        let gradientColors = PastelGradient(rawValue: randInt)?.colors().map({$0.cgColor})
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: imageView.frame.size)
        gradient.colors = gradientColors
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)

        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = UIBezierPath(roundedRect: imageView.bounds.insetBy(dx: 1, dy: 1), cornerRadius: .makeWidth(40)).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        imageView.layer.addSublayer(gradient)
        return imageView
    }()
    
    private let defaultLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: 25)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let sendTextButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(22))
        button.setImage(UIImage(systemName: "paperplane.fill", withConfiguration: config), for: .normal)
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        defaultLabel.removeFromSuperview()
    }
    
    var delegate: ContactDelegate!
    var number: String?
    
    func setup(_ item: Item){
        switch item {
        case .contact(let contact):
            self.number = contact.number
            contentView.addSubview(titleLabel)
            titleLabel.centerX(inView: contentView, topAnchor: contentView.topAnchor, paddingTop: .makeWidth(10))
            titleLabel.text = contact.name
            contentView.addSubview(numberLabel)
            numberLabel.centerX(inView: contentView, topAnchor: titleLabel.bottomAnchor, paddingTop: .makeWidth(19))
            let numberArray = contact.number.map({$0})
            numberLabel.text = "(\(String(numberArray[0]) + String(numberArray[1]) + String(numberArray[2]))) \(String(numberArray[3]) + String(numberArray[4]) + String(numberArray[5]))-\(String(numberArray[6]) + String(numberArray[7]) + String(numberArray[8]) + String(numberArray[9]))"
            contentView.addSubview(sendTextButton)
            sendTextButton.addTarget(self, action: #selector(sendTextInvite), for: .touchUpInside)
            sendTextButton.centerYright(inView: contentView, rightAnchor: contentView.rightAnchor, paddingRight: .makeWidth(25))
            
            contentView.backgroundColor = .greyColor()
            contentView.addSubview(imageView)
            
            
            
            
            if let image = contact.image{
                imageView.image = image
            }else{
                contentView.addSubview(defaultLabel)
                defaultLabel.center(inView: imageView)
                let names = contact.name.components(separatedBy: " ")
                if names.count >= 2{
                    guard let initial1 = names.first?.first else {
                        defaultLabel.text = "?"
                        return
                    }
                    guard let initial2 = names[1].first, initial2.isLetter else {
                        defaultLabel.text = String(initial1).capitalized
                        return
                    }
                    defaultLabel.text = String(initial1).capitalized + " " + String(initial2).capitalized
                }else{
                    guard let initial1 = names.first?.first else {
                        defaultLabel.text = "?"
                        return
                    }
                    defaultLabel.text = String(initial1).capitalized
                }
            }
        }
    }
    
    @objc func sendTextInvite(){
        guard let number = number else {return}
        delegate.sendText(number)
    }
}
