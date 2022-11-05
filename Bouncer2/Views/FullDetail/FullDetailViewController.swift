//
//  FullDetailViewController.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/30/22.
//

import Foundation
import FloatingPanel
import Combine
import UIKit

class FullDetailViewController: UIViewController{
    
    /*Top Level of event's full detail view, includes image, back button, and floating panel */
    
    fileprivate var components = FullDetailViewComponents()
    fileprivate var contentController: TestScroll!
    
    let panel = FloatingPanelController()
    var vm: FullDetailVM!
    var grabberHandle: FullDetailGrabberHandle!
    var colors: [CGColor]!
    
    init(event: Event, image: UIImage? = nil, from frame: CGRect? = nil){
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = event.colors.first?.uiColor()
        self.vm = FullDetailVM(id: event.id!, event: event)
        
        contentController = TestScroll(components: components, event: event, vm: vm)
        setupImage(components.eventImageView, image: image, initURL: URL(string: event.imageURL)!)
        setupPanel(event)
        setupBackButton(components.backButton)
        
        vm.$colors.sink { [weak self] colors in
            if let colors = colors{
                self?.colors = colors.cgColors()
            }
        }.store(in: &vm.cancellable)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let vm = vm{
            FirestoreSubscription.cancel(id: vm.id)
            vm.cancellable.forEach({$0.cancel()})
            vm.timerCancellable?.cancel()
            vm.timerCancellable = nil
            self.contentController = nil
            self.vm = nil
        }
        self.colors = nil
        self.grabberHandle = nil
    }
    
    fileprivate func setupPanel(_ data: Event) {
        panel.layout = PanelLayout()
        panel.delegate = self
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = .makeWidth(25)
        appearance.backgroundColor = .greyColor()
        
        panel.backdropView.alpha = 0
        panel.surfaceView.appearance = appearance
        panel.surfaceView.grabberHandle.isHidden = true
        panel.addPanel(toParent: self)
        panel.set(contentViewController: contentController)
        panel.surfaceView.grabberHandle.isHidden = true
        panel.surfaceView.grabberHandlePadding = 0
        panel.surfaceView.grabberHandleSize = .init(width: .makeWidth(414), height: .makeHeight(414) * 85/414)
        
        let grabberHandle = FullDetailGrabberHandle(event: data, vm: vm)
        self.grabberHandle = grabberHandle
        panel.surfaceView.addSubview(grabberHandle)
      
        
    }
    
    fileprivate func setupImage(_ imageView: UIImageView, image: UIImage? = nil, initURL: URL){
        if let image = image{
            components.eventImageView.image = image
        }else{
            components.eventImageView.layer.addSublayer(components.skeletonGradient)
            components.eventImageView.sd_setImage(with: initURL) { [weak self] i, e, c, u in
                if e == nil{
                    self?.components.skeletonGradient.removeFromSuperlayer()
                }
            }
        }
        
        vm.$imageURL.sink { [weak self] imageString in
            guard let imageString = imageString, let imageURL = URL(string: imageString), let skeleton = self?.components.skeletonGradient else {return}
            
           
            self?.components.eventImageView.image = nil
            self?.components.eventImageView.layer.addSublayer(skeleton)
            self?.components.eventImageView.sd_setImage(with: imageURL) { i, e, c, u in
                if e == nil{
                    skeleton.removeFromSuperlayer()
                }
            }
        }.store(in: &vm.cancellable)
        
        view.addSubview(imageView)
    }
    
    
    fileprivate func setupBackButton(_ button: UIButton){
        view.addSubview(button)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    
    
    
//    weak var gradient: CAGradientLayer?
//    fileprivate func distanceLabelGradient(_ colors: [CGColor]) {
//        grabberHandle.distanceLabel.layer.cornerRadius = .makeHeight(12)
//        grabberHandle.distanceLabel.layer.masksToBounds = true
//        let gradient = CAGradientLayer()
//        gradient.frame = CGRect(origin: grabberHandle.distanceLabel.frame.origin, size: grabberHandle.distanceLabel.frame.size)
//        gradient.colors = colors
//        gradient.startPoint = CGPoint(x: 0, y: 1)
//        gradient.endPoint = CGPoint(x: 1, y: 1)
//
//        let shape = CAShapeLayer()
//        shape.lineWidth = 1
//        shape.path = UIBezierPath(roundedRect: grabberHandle.distanceLabel.bounds.insetBy(dx: 0.45,
//                                                                                          dy: 0.45), cornerRadius: .makeHeight(12)).cgPath
//        shape.strokeColor = UIColor.black.cgColor
//        shape.fillColor = UIColor.clear.cgColor
//        gradient.mask = shape
//        if let _gradient = self.gradient{
//            grabberHandle.layer.replaceSublayer(_gradient, with: gradient)
//        }else{
//            grabberHandle.layer.addSublayer(gradient)
//        }
//
//        self.gradient = gradient
//    }
    
    @objc func goBack(){
        navigationController?.popViewController(animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class PanelLayout: FloatingPanelLayout{
        var position: FloatingPanelPosition = .bottom
        var initialState: FloatingPanelState = .full
        var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
            return [.full: FloatingPanelLayoutAnchor(absoluteInset: .makeWidth(414) * 213/414, edge: .top, referenceGuide: .superview)]
        }
        func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
            switch state{
            default:
                return 0
            }
        }
    }
}

extension FullDetailViewController: FloatingPanelControllerDelegate{
    
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        
        let loc = vc.surfaceLocation
        let minY = vc.surfaceLocation(for: .full).y
        let maxY = vc.surfaceLocation(for: .tip).y
        vc.surfaceLocation = CGPoint(x: loc.x, y: min(max(loc.y, minY), maxY))
        components.eventImageView.frame.size.height = min(max(loc.y, minY), maxY).rounded() + .makeHeight(35)
        
        let top = loc.y - .makeWidth(414) * 243/414
        components.backButton.alpha = 1 - (top / 80)
    }
}

//extension FullDetailViewController: UIGestureRecognizerDelegate{
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//
//        if gestureRecognizer is UITapGestureRecognizer && otherGestureRecognizer is UIPanGestureRecognizer {
//            return true
//        }
//
//        if gestureRecognizer is UIPanGestureRecognizer && otherGestureRecognizer is UITapGestureRecognizer {
//            return true
//        }
//
//        return false
//    }
//}


