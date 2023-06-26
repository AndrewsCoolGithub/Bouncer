//
//  ChatCameraRollPanel.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/5/23.
//

import FloatingPanel

class ChatCameraRollPanel: FloatingPanelController{
    
    
    weak var chatCameraRollVC: ChatCameraRollVC?
    
    lazy var sendBanner: UIView = {
        let config = UIImage.SymbolConfiguration(pointSize: .makeHeight(30))
        let sendImageButton: UIButton = UIButton()
        sendImageButton.setImage(UIImage(systemName: "paperplane.fill", withConfiguration: config), for: .normal)
        sendImageButton.imageView?.contentMode = .center
        sendImageButton.tintColor = .white
        let view = UIView()
        view.setDimensions(height: .makeHeight(80), width: .makeWidth(414))
        view.backgroundColor = .greyColor()
        view.addSubview(sendImageButton)
        sendImageButton.centerYright(inView: view, rightAnchor: view.rightAnchor, paddingRight: .makeWidth(30))
        sendImageButton.addTarget(self, action: #selector(sendMedia), for: .touchUpInside)
        return view
    }()
    
    init(_ vc: ChatCameraRollVC){
        super.init(delegate: nil)
        delegate = self
        self.chatCameraRollVC = vc
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = .makeWidth(39.5)
        appearance.backgroundColor = .greyColor()
        
       
        layout = PanelLayout()
        surfaceView.appearance = appearance
        set(contentViewController: vc)
        
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class PanelLayout: FloatingPanelLayout{
        private let mHeight: CGFloat = .makeHeight(896)
        private let itemDimension: CGFloat = .makeWidth(414)/3
        var position: FloatingPanelPosition = .bottom
        var initialState: FloatingPanelState = .tip
        var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
            return [
                    .tip: FloatingPanelLayoutAnchor(
                    absoluteInset: mHeight - (itemDimension * 2),
                    edge: .top,
                    referenceGuide: .superview),
                        
                    .full: FloatingPanelLayoutAnchor(
                    absoluteInset: itemDimension * 2,
                    edge: .top,
                    referenceGuide: .safeArea)
                ]
        }
    }
    
    func showSendBanner(_ isShown: Bool){
        switch isShown{
        case true:
            sendBanner.removeFromSuperview()
            self.view.addSubview(sendBanner)
            sendBanner.centerXBottom(inView: self.view, bottomAnchor: self.view.bottomAnchor)
        case false:
            sendBanner.removeFromSuperview()
        }
    }
    
    @objc func sendMedia(_ sender: UIButton){
        let chatVC = self.parent as? ChatViewController
        guard let cameraRollVC = chatCameraRollVC else {return}
        let images = cameraRollVC.selectedAssets
        
        for i in 0..<images.count{
            let image = PhotosManager.shared.getImage(from: images[i])
            chatVC?.viewModel?.sendMessage(.image, content: image, replyReceipt: nil)
            
            if i == images.count - 1{
                let chatVC = self.parent as? ChatViewController
                
                self.removePanelFromParent(animated: true) {
                    chatVC?.showBar()
                }
            }
        }
    }
}



extension ChatCameraRollPanel: FloatingPanelControllerDelegate{
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        let surfaceY = max(fpc.surfaceLocation.y, 0)
        let maxY = fpc.surfaceLocation(for: .full).y
        chatCameraRollVC?.collectionView.frame.size.height = min(.makeHeight(896) - surfaceY, .makeHeight(896) - maxY)
    }
    
    func floatingPanelWillEndDragging(_ fpc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
        
        let tipLocation = self.surfaceLocation(for: .tip).y
        let tipRange = (tipLocation-45...tipLocation+45)
        if tipRange.lowerBound < self.surfaceLocation.y {
            self.move(to: .hidden, animated: true)
            let chatVC = self.parent as? ChatViewController
            
            self.removePanelFromParent(animated: true) {
                chatVC?.showBar()
            }
        }
    }
}
