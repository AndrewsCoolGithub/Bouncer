//
//  NewMessageViewController+UIGestureRecognizer.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/6/22.
//

import UIKit

extension NewMessageViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        ///Orginally added a tap gesture to cv to make up for hard coded width of textField, this code allows children to receive taps consistently
        ///Unfortnately, isDescendant method is true when the view is itself so that's where the first 'if' statement comes from
        if touch.view == components.bubbleCV{
            return true
        }else if touch.view?.isDescendant(of: components.bubbleCV) == true {
            return false
        }
        
        return true
    }
}
