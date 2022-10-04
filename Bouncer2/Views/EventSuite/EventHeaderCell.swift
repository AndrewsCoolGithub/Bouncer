//
//  EventHeaderCell.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/24/22.
//

import Foundation
import UIKit

class EventHeaderCell: UICollectionReusableView{
    
    static let id = "event-header-cell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(22.5))
        label.textColor = .white
        return label
    }()
    
    public func setup(title: String){
        label.text = title
        backgroundColor = .clear
        addSubview(label)
        label.centerY(inView: self, leftAnchor: self.leftAnchor, paddingLeft: .makeWidth(20))
    }
}
