//
//  NMTextFieldCell.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/5/22.
//

import UIKit

class NMTextFieldCell: UICollectionViewCell{
    static let id = "NMTextFieldCell"
    
    public func makeTextField(_ textField: UITextField?){
        
        guard let textField = textField else {return}
    
        textField.setWidth(.makeWidth(207).rounded(.down))
        textField.setHeight(.wProportioned(50))
        
        contentView.addSubview(textField)
        textField.anchor(left: contentView.leftAnchor, right: contentView.rightAnchor)
        textField.centerY(inView: contentView)
        
    }
}
