//
//  PageViewController.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/12/22.
//

import Foundation
import UIKit

class PageViewController: UIPageViewController{
    
    init(frame: CGRect){
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.view.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
