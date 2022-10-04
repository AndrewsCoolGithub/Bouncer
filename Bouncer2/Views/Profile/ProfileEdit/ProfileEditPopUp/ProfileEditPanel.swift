//
//  ProfileEditView.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/13/22.
//

import UIKit
import FloatingPanel
import YPImagePicker

class ProfileEditPanel: FloatingPanelController{
    
    var profileEditContentController: ProfileEditContentController!
   
    init(viewModel: ProfileViewModel){
        super.init(delegate: nil)
        self.delegate = self
        self.profileEditContentController = ProfileEditContentController(viewModel: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = .makeWidth(25)
        appearance.backgroundColor = .greyColor()
        layout = PanelLayout()
        surfaceView.appearance = appearance
        set(contentViewController: profileEditContentController)
    }
    
    class PanelLayout: FloatingPanelLayout {
        var position: FloatingPanelPosition = .bottom
        var initialState: FloatingPanelState = .full
        var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
            return [.full: FloatingPanelLayoutAnchor(absoluteInset: .makeHeight(369), edge: .top, referenceGuide: .superview)]
        }
    }
}


extension ProfileEditPanel: FloatingPanelControllerDelegate{
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        
        let loc = vc.surfaceLocation
        let minY = vc.surfaceLocation(for: .full).y
        let maxY = vc.surfaceLocation(for: .tip).y
        vc.surfaceLocation = CGPoint(x: loc.x, y: min(max(loc.y, minY), maxY))
        
        if loc.y >= .makeHeight(550){
            vc.removePanelFromParent(animated: true)
        }
    }
}


