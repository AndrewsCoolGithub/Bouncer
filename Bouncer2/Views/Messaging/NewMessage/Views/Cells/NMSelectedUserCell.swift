//
//  NMSelectedUserCell.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/5/22.
//

import UIKit
final class NMSelectedUserCell: UICollectionViewCell{
    
    static let id = "NMSelectedUserCell"
    
    private let mainView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = .wProportioned(25)
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(red: 1, green: 0, blue: 85/255, alpha: 1)
        return view
    }()
    
    private let nameBubble: SelectedUserTextBubble = {
        let label = SelectedUserTextBubble()
        label.backgroundColor = .nearlyBlack()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .poppinsMedium(size: .makeWidth(16.5))
        label.layer.cornerRadius = .wProportioned(25)
        label.layer.masksToBounds = true
        label.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        label.setHeight(.wProportioned(50))
        label.insets = UIEdgeInsets(top: 0, left: .makeWidth(12.5), bottom: 0, right: 0)
        label.backgroundColor = UIColor(red: 1, green: 0, blue: 85/255, alpha: 1)
        return label
    }()
    
    private let xSymbol: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(20))
        let image = UIImage(systemName: "xmark", withConfiguration: config)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        imageView.backgroundColor = UIColor(red: 1, green: 0, blue: 85/255, alpha: 1)
        imageView.tintColor = .white
        imageView.setHeight(.wProportioned(50))
        imageView.setWidth(.makeWidth(45))
        return imageView
    }()
    
    public func setup(_ profile: Profile){
        contentView.layer.cornerRadius = .wProportioned(25)
        contentView.layer.masksToBounds = true
        
        nameBubble.text = profile.display_name
        
        mainView.addSubview(xSymbol)
        mainView.addSubview(nameBubble)
        
        xSymbol.leftAnchor.constraint(equalTo: nameBubble.rightAnchor).isActive = true
        xSymbol.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
        
        nameBubble.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
        nameBubble.rightAnchor.constraint(equalTo: xSymbol.leftAnchor).isActive = true
        
        contentView.addSubview(mainView)
        mainView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        mainView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        mainView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
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
