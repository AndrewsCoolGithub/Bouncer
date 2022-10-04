//
//  ProfileEditCell.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/15/22.
//

import Foundation
import UIKit

class ProfileEditCell: UITableViewCell {
    static let id = "profile-edit-cell"
    func setup(_ tab: ProfileEditContentController.EditTabsOptions){
        var config = UIListContentConfiguration.cell()
        config.text = tab.description
        config.textProperties.font = .poppinsMedium(size: .makeWidth(17))
        config.imageProperties.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: .makeWidth(30))
        config.imageToTextPadding = .makeWidth(20)
        config.imageProperties.reservedLayoutSize = CGSize(width: .makeWidth(80), height: .makeHeight(85))
        config.imageProperties.tintColor = .white
        let colors = User.shared.colors
        switch tab {
        case .ProfileImage:
            config.image = UIImage(systemName: "person.crop.square.fill")?.tintedWithLinearGradientColors(uiColors: colors?.uiColors())
        case .BackdropImage:
            config.image = UIImage(systemName: "rectangle.fill.badge.person.crop")?.tintedWithLinearGradientColors(uiColors: colors?.uiColors())
        case .Name:
            config.image = UIImage(systemName: "textformat")?.tintedWithLinearGradientColors(uiColors: colors?.uiColors())
        case .Username:
            config.image = UIImage(systemName: "face.smiling.fill")?.tintedWithLinearGradientColors(uiColors: colors?.uiColors())
        case .Bio:
            config.image = UIImage(systemName: "text.alignleft")?.tintedWithLinearGradientColors(uiColors: colors?.uiColors())
        case .Colors:
            config.image = UIImage(systemName: "circle.hexagonpath.fill")?.tintedWithLinearGradientColors(uiColors: colors?.uiColors())
        }
       
        let contentView = config.makeContentView()
        contentView.backgroundColor = .greyColor()
        self.backgroundColor = .greyColor()
        contentConfiguration = config
    }
    
    
}
