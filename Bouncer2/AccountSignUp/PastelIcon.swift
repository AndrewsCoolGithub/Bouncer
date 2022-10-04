//
//  PastelIcon.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/17/22.
//

import Foundation
import UIKit

class PastelIcon: UIView{
    
    let pastel = Pastel()
    
    init(frame: CGRect, colors: [UIColor], symbolName: String, backgroundColor: UIColor){
        super.init(frame: frame)
        
        self.backgroundColor = backgroundColor
        
        pastel.frame = self.bounds
        addSubview(pastel)
        pastel.setColors(colors)

        let imageView = UIImageView(frame: self.bounds)
        imageView.image = UIImage(systemName: symbolName)
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)

        pastel.mask = imageView
        pastel.startAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
