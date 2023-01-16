//
//  EventOverviewSectionHeader.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/12/22.
//

import UIKit

final class EventOverviewSectionHeader: UICollectionReusableView{
    
    static let id = "EventOverviewSectionHeader"
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(22.5))
        label.textColor = .white
        return label
    }()
    
    func setup(_ section: EventOverviewContent.Section){
        label.text = section.rawValue
        backgroundColor = .clear
        addSubview(label)
        label.centerY(inView: self, leftAnchor: self.leftAnchor, paddingLeft: .makeWidth(20))
    }
}

