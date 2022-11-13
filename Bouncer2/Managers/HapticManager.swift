//
//  HapticManager.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/30/22.
//

import Foundation
import UIKit

final class HapticsManager {
    static let shared = HapticsManager()
    
    private init(){}
        
    public func selectionVibration(){
        DispatchQueue.main.async {
            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
                selectionFeedbackGenerator.prepare()
                selectionFeedbackGenerator.selectionChanged()
        }
    }
        
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType){
        DispatchQueue.main.async {
            let notificationGenerator = UINotificationFeedbackGenerator()
            notificationGenerator.prepare()
            notificationGenerator.notificationOccurred(type)
        }
    }
}
