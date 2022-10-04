//
//  SearchHeaderCell.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 8/1/22.
//

import Foundation
import UIKit

class SearchHeaderCell: UICollectionReusableView{
    static let id = "search-header-cell"
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(20))
        label.textColor = .white
        label.text = "Suggested"
        return label
    }()
    
    func setup(){
        backgroundColor = .greyColor()
        addSubview(headerLabel)
        headerLabel.centerY(inView: self, leftAnchor: self.leftAnchor, paddingLeft: .makeWidth(20))
    }
    
    func remove(){
        backgroundColor = .greyColor()
        headerLabel.removeFromSuperview()
    }
}
