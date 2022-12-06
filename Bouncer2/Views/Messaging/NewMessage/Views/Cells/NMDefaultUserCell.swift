//
//  NMSelectedUserCell.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/27/22.
//

import UIKit

final class NMDefaultUserCell: UICollectionViewCell{
    
    static let id = "NMDefaultUserCell"
    
    private let mainView: UIView = {
        let view = UIView(frame: .zero, cornerRadius: .wProportioned(25), colors: nil, lineWidth: 1.5, direction: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
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
        label.insets = UIEdgeInsets(top: 0, left: .makeWidth(12.5), bottom: 0, right: .makeWidth(12.5))
        return label
    }()
    
    public func setup(_ profile: Profile){
        contentView.layer.cornerRadius = .wProportioned(25)
        contentView.layer.masksToBounds = true
        
        nameBubble.text = profile.display_name

        mainView.addSubview(nameBubble)
        nameBubble.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
        nameBubble.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
        
        contentView.addSubview(mainView)
        mainView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        mainView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        mainView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
      
        addLabelGradient(profile.colors?.cgColors() ?? User.defaultColors.colors.map({$0.cgColor}))
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
