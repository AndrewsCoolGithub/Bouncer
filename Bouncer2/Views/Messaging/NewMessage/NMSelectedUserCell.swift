//
//  NMSelectedUserCell.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/27/22.
//

import UIKit

final class NMSelectedUserCell: UICollectionViewCell{
    
    static let id = "NMSelectedUserCell"
    
    private let mainView: UIView = {
        let view = UIView(frame: .zero, cornerRadius: .wProportioned(25), colors: nil, lineWidth: 1.5, direction: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setHeight(.wProportioned(50))
        return view
    }()
    
    private let nameBubble: SelectedUserTextBubble = {
        let label = SelectedUserTextBubble()
        label.backgroundColor = .nearlyBlack()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .poppinsMedium(size: .makeWidth(16.5))
        label.layer.cornerRadius = .wProportioned(25)
        label.setHeight(.wProportioned(50))
        label.insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return label
    }()
    
    private let xSymbol: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(20))
        let image = UIImage(systemName: "xmark", withConfiguration: config)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        imageView.backgroundColor = .clear
        imageView.tintColor = .white
        imageView.setHeight(.wProportioned(50))
        return imageView
    }()
    
    
    
    public func makeTextField(_ textField: UITextField?){
        guard let textField = textField else {return}
        mainView.addSubview(textField)
        textField.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
        contentView.addSubview(mainView)
        mainView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        mainView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        mainView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }
    
    let compositeView = UIView()
    
    public func setup(_ profile: Profile, _ isRed: Bool){
     
      
        contentView.layer.cornerRadius = .wProportioned(25)
        contentView.layer.masksToBounds = true
        
        nameBubble.text = profile.display_name
        
        if isRed{
            compositeView.setHeight(.wProportioned(50))
            compositeView.backgroundColor = UIColor(red: 1, green: 0, blue: 85/255, alpha: 1)
            nameBubble.backgroundColor = UIColor(red: 1, green: 0, blue: 85/255, alpha: 1)
            compositeView.addSubview(nameBubble)
            compositeView.addSubview(xSymbol)
            nameBubble.leftAnchor.constraint(equalTo: compositeView.leftAnchor).isActive = true
            xSymbol.centerYright(inView: compositeView, rightAnchor: compositeView.rightAnchor, paddingRight: .makeWidth(15))
            nameBubble.rightAnchor.constraint(equalTo: xSymbol.leftAnchor).isActive = true
            mainView.addSubview(compositeView)
            compositeView.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
            compositeView.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
        }else{
            mainView.addSubview(nameBubble)
            nameBubble.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
            nameBubble.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
        }
        
        contentView.addSubview(mainView)
        mainView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        mainView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        mainView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        if !isRed{
            addLabelGradient(profile.colors?.cgColors() ?? User.defaultColors.colors.map({$0.cgColor}))
        }
    }
    
    
    weak var gradient: CAGradientLayer?
    fileprivate func addLabelGradient(_ colors: [CGColor]) {
        nameBubble.layer.cornerRadius = .wProportioned(25)
        nameBubble.layer.masksToBounds = true
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: contentView.frame.origin, size: CGSize(width: nameBubble.intrinsicContentSize.width, height: .wProportioned(50)))
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = UIBezierPath(roundedRect: gradient.bounds.insetBy(dx: 0.45, dy: 0.45),
                                  cornerRadius: .wProportioned(25)).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        if let _gradient = self.gradient{
            self.layer.replaceSublayer(_gradient, with: gradient)
        }else{
            self.layer.addSublayer(gradient)
        }
        
        self.gradient = gradient
    }
    
    
    
}

fileprivate final class SelectedUserTextBubble: UILabel {
    var topInset: CGFloat = 0.0
    var leftInset: CGFloat = 0.0
    var bottomInset: CGFloat = 0.0
    var rightInset: CGFloat = 0.0

    var insets: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        }
        set {
            topInset = newValue.top
            leftInset = newValue.left
            bottomInset = newValue.bottom
            rightInset = newValue.right
        }
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var adjSize = super.sizeThatFits(size)
        adjSize.width += leftInset + rightInset
        adjSize.height += topInset + bottomInset
        
        return adjSize
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += leftInset + rightInset
        contentSize.height += topInset + bottomInset
        
        return contentSize
    }
}
