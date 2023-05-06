//
//  ChatCameraRollPanel.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/5/23.
//

import FloatingPanel

class ChatCameraRollPanel: FloatingPanelController{
    
    init(_ vc: ChatCameraRollVC){
        super.init(delegate: nil)
        delegate = self
       
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = .makeWidth(25)
        appearance.backgroundColor = .greyColor()
        
       
        layout = PanelLayout()
        surfaceView.appearance = appearance
        set(contentViewController: vc)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class PanelLayout: FloatingPanelLayout{
        var position: FloatingPanelPosition = .bottom
        var initialState: FloatingPanelState = .full
        var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
            return [.tip: FloatingPanelLayoutAnchor(absoluteInset: .makeHeight(896) - ((.wProportioned(414)/3)*2.1), edge: .top, referenceGuide: .superview), .full: FloatingPanelLayoutAnchor(fractionalInset: 0.33, edge: .top, referenceGuide: .superview)]
        }
    }
}



extension ChatCameraRollPanel: FloatingPanelControllerDelegate{
    
}
