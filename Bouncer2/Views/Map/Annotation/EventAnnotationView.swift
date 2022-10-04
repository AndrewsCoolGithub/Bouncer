//
//  EventAnnotationView.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/4/22.
//

import Foundation
import Mapbox
import UIImageColors
class EventAnnotationView: MGLAnnotationView{
    
    
    private let imageView: UIImageView = {
       let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: .makeWidth(50).rounded(), height: .makeWidth(50).rounded())), cornerRadius: .makeWidth(25).rounded(), colors: EventCreationVC.colors ?? UIImageColors(background: .white, primary: .purple, secondary: .cyan, detail: .orange), lineWidth: 2, direction: .horizontal)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
       
    }
    
    init(image: UIImage? = nil, annotation: EventPointAnnot!, reuseIdentifier: String?, isDrag: Bool = true){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
//        self.imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: .makeWidth(50).rounded(), height: .makeWidth(50).rounded())), cornerRadius: .makeWidth(25).rounded(), colors: EventCreationVC.colors ?? UIImageColors(background: .white, primary: .purple, secondary: .cyan, detail: .orange), lineWidth: 2, direction: .horizontal)
//        self.imageView.contentMode = .scaleAspectFill
        
        self.addSubview(imageView)
        self.frame = imageView.frame
        
        self.imageView.image = image
        isDraggable = isDrag
            
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // Custom handler for changes in the annotation’s drag state.
    override func setDragState(_ dragState: MGLAnnotationViewDragState, animated: Bool) {
    super.setDragState(dragState, animated: animated)
     
    switch dragState {
    case .starting:
        print("Starting", terminator: "")
        startDragging()
    case .dragging:
        print(".", terminator: "")
    case .ending, .canceling:
        print("Ending")
        endDragging()
    case .none:
        break
    @unknown default:
        fatalError("Unknown drag state")
        }
    }
     
    // When the user interacts with an annotation, animate opacity and scale changes.
    func startDragging() {
    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
    self.layer.opacity = 0.8
    self.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
    }) { _ in
        NotificationCenter.default.post(name: Notification.Name("dragAnnot"), object: EventAnnotationView.self, userInfo: ["isDragging": true])
    }
     
    // Initialize haptic feedback generator and give the user a light thud.
    
    let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
    hapticFeedback.impactOccurred()
    
    }
     
    func endDragging() {
    transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
    self.layer.opacity = 1
    self.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        
    }) { _ in
        NotificationCenter.default.post(name: Notification.Name("dragAnnot"), object: EventAnnotationView.self, userInfo: ["isDragging": false])
    }
     
    // Give the user more haptic feedback when they drop the annotation.
    
    let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
    hapticFeedback.impactOccurred()
    
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

