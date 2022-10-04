//
//  EventOverview.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/21/22.
//

import Foundation
import UIKit
import UIImageColors

class EventOverview: UIViewController{
  
    let props: [OverviewProperties] = [.image, .title, .description, .location, .schedule, .type]
    let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(50))
    
    init(){
        super.init(nibName: nil, bundle: nil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .greyColor()
        createTabs()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layer.cornerRadius = .makeWidth(25)
        view.layer.applySketchShadow(color: .black.withAlphaComponent(0.3), alpha: 1, x: 0, y: .makeHeight(-2), blur: 6, spread: 6, withRounding: .makeWidth(25))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(sender:)))
        view.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGesture(sender: UITapGestureRecognizer){
        print("Tapped me")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.subviews.forEach { view in
            if let imageView = view.subviews.first(where: {$0 is UIImageView}) as? UIImageView{
                let image = imageView.image
                UIView.transition(with: imageView, duration: 2, options: .transitionCrossDissolve) {
                    imageView.image = image?.tintedWithLinearGradientColors(uiImageColors: EventCreationVC.shared.viewModel.colors!)
                }
            }
        }
        
        let eventTypeTab = view.subviews.first(where: {$0.tag == OverviewProperties.toTagValue(prop: .type)})
        guard let imageView = eventTypeTab?.subviews.first(where: {$0 is UIImageView}) as? UIImageView else {return}
        if let eventType = EventCreationVC.shared.viewModel.eventType{
            UIView.transition(with: imageView, duration: 2, options: .transitionCrossDissolve) {
                switch eventType {
                case .exclusive:
                    imageView.image = UIImage(named: "ExclusiveIcon")?.tintedWithLinearGradientColors(uiImageColors: EventCreationVC.shared.viewModel.colors!)
                case .open:
                    imageView.image = UIImage(systemName: "mappin.and.ellipse", withConfiguration: self.config)?.tintedWithLinearGradientColors(uiImageColors: EventCreationVC.shared.viewModel.colors!)
                }
            }
        }
    }
    
    
   
    
    func createTabs(){
       
        self.props.forEach { [weak self] prop in
            guard let self = self else {
                return
            }
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectAction(sender:)))
            let view = UIView(frame: CGRect(x: 0, y: 0, width: .makeWidth(170), height: .makeWidth(170) * 120/170))
            view.layer.cornerRadius = .makeWidth(12)
            view.layer.applySketchShadow(color: .black.withAlphaComponent(0.3), alpha: 1, x: 0, y: 5, blur: 9, spread: 5, withRounding: .makeWidth(12))
            view.backgroundColor = .greyColor()
            view.addGestureRecognizer(gestureRecognizer)
            view.isUserInteractionEnabled = true
            view.tag = OverviewProperties.toTagValue(prop: prop)
            let imageView = UIImageView()
            imageView.tintColor = .white
            imageView.contentMode = .center
            let label = UILabel()
            label.textColor = .nearlyWhite()
            label.font = .poppinsMedium(size: .makeWidth(14))
            label.textAlignment = .center
            label.setWidth(.makeWidth(170))
            label.text = prop.rawValue.capitalized
            
            switch prop{
            case .image:
                view.frame.origin = CGPoint(x: .makeWidth(25), y: .makeWidth(50))
                imageView.image = UIImage(systemName: "camera.on.rectangle", withConfiguration: config)?.tintedWithLinearGradientColors(uiImageColors: EventCreationVC.shared.viewModel.colors!)
                label.text = "Image"
            case .title:
                view.frame.origin = CGPoint(x: .makeWidth(219), y: .makeWidth(50))
                imageView.image = UIImage(systemName: "textformat", withConfiguration: config)?.tintedWithLinearGradientColors(uiImageColors: EventCreationVC.shared.viewModel.colors!)
            case .description:
                view.frame.origin = CGPoint(x: .makeWidth(25), y: .makeWidth(202))
                imageView.image = UIImage(systemName: "text.justify.left", withConfiguration: config)?.tintedWithLinearGradientColors(uiImageColors: EventCreationVC.shared.viewModel.colors!)
            case .location:
                view.frame.origin = CGPoint(x: .makeWidth(219), y: .makeWidth(202))
                imageView.image = UIImage(systemName: "map.fill", withConfiguration: config)?.tintedWithLinearGradientColors(uiImageColors: EventCreationVC.shared.viewModel.colors!)
            case .schedule:
                view.frame.origin = CGPoint(x: .makeWidth(25), y: .makeWidth(354))
                imageView.image = UIImage(systemName: "calendar", withConfiguration: config)?.tintedWithLinearGradientColors(uiImageColors: EventCreationVC.shared.viewModel.colors!)
            case .type:
                view.frame.origin = CGPoint(x: .makeWidth(219), y: .makeWidth(354))
                if let eventType = EventCreationVC.shared.viewModel.eventType{
                    switch eventType {
                    case .exclusive:
                        imageView.image = UIImage(named: "ExclusiveIcon")?.tintedWithLinearGradientColors(uiImageColors: EventCreationVC.shared.viewModel.colors!)
                    case .open:
                        imageView.image = UIImage(systemName: "mappin.and.ellipse", withConfiguration: config)?.tintedWithLinearGradientColors(uiImageColors: EventCreationVC.shared.viewModel.colors!)
                    }
                }
            }
            view.addSubview(imageView)
            view.addSubview(label)
            
            imageView.center(inView: view, yConstant: -.makeWidth(10))
            label.centerXBottom(inView: view, paddingBottom: .makeWidth(12.5))
            
            self.view.addSubview(view)
        }
    }
    
    @objc func selectAction(sender: UITapGestureRecognizer){
        guard let prop = OverviewProperties.fromTagValue(tagValue: sender.view?.tag) else {return}
        
        switch prop{
        case .image:
            EventCreationVC.shared.openCamera()
            self.dismiss(animated: true)
        case .title:
            EventCreationVC.shared.viewModel.currentController = EventCreationVC.shared.viewModel.currentVC(type: .eventTitle)
            self.dismiss(animated: true)
        case .description:
            EventCreationVC.shared.viewModel.currentController = EventCreationVC.shared.viewModel.currentVC(type: .eventDescription)
            self.dismiss(animated: true)
        case .location:
            EventCreationVC.shared.viewModel.currentController = EventCreationVC.shared.viewModel.currentVC(type: .eventLocation)
            self.dismiss(animated: true)
        case .schedule:
            EventCreationVC.shared.viewModel.currentController = EventCreationVC.shared.viewModel.currentVC(type: .eventSchedule)
            self.dismiss(animated: true)
        case .type:
            EventCreationVC.shared.viewModel.currentController = EventCreationVC.shared.viewModel.currentVC(type: .eventType)
            self.dismiss(animated: true)
        }
    }
    let interactor = Interactor()
    @objc func handleGesture(sender: UIPanGestureRecognizer) {
            let percentThreshold:CGFloat = 0.15
        
            
            let translation = sender.translation(in: view)
            let verticalMovement = translation.y / view.bounds.height
            let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
            let downwardMovementPercent = fminf(downwardMovement, 1.0)
            let progress = CGFloat(downwardMovementPercent)
    

            switch sender.state {
            case .began:
                interactor.hasStarted = true
              dismiss(animated: true)
            case .changed:
                interactor.shouldFinish = progress > percentThreshold
                
                interactor.update(progress)
            case .cancelled:
                interactor.hasStarted = false
                interactor.cancel()
            case .ended:
                interactor.hasStarted = false
                interactor.shouldFinish ? interactor.finish() :
                interactor.cancel()
            default:
             break
           }
        }
    
    
}
enum OverviewProperties: String, CaseIterable{
    case image
    case title
    case description
    case location
    case schedule
    case type
    
    static func fromTagValue(tagValue: Int?) -> OverviewProperties? {
        guard let tagValue = tagValue else {
            return nil
        }

        switch tagValue{
        case 0:
            return .image
        case 1:
            return .title
        case 2:
            return .description
        case 3:
            return .location
        case 4:
            return .schedule
        case 5:
            return .type
        default:
            return nil
        }
    }
    
    static func toTagValue(prop: OverviewProperties) -> Int{
        switch prop {
        case .image:
            return 0
        case .title:
            return 1
        case .description:
            return 2
        case .location:
            return 3
        case .schedule:
            return 4
        case .type:
            return 5
        }
    }
}

class Interactor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
    
    override init(){
        super.init()
        self.completionCurve = .easeInOut
        self.completionSpeed = 0.7
    }
   //  completionCurve: UIView.AnimationCurve = .easeInOut
}
private extension EventOverview {
    func configure() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .coverVertical
        transitioningDelegate = self
    }
}
extension EventOverview: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
           DismissAnimator()
        }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactor.hasStarted ? interactor : .none
    }
}
class PresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = presentingViewController.view.bounds
        let size = CGSize(width: .makeWidth(414), height: .makeHeight(600))
        let origin = CGPoint(x: bounds.midX - size.width / 2, y: .makeHeight(896 - 600))
        return CGRect(origin: origin, size: size)
    }

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        presentedView?.autoresizingMask = [
            .flexibleTopMargin,
            .flexibleBottomMargin,
            .flexibleLeftMargin,
            .flexibleRightMargin
        ]

        presentedView?.translatesAutoresizingMaskIntoConstraints = true
    }
}
class DismissAnimator: NSObject {
   let transitionDuration = 0.5
}

extension DismissAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
       transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
           
            else {
                return
        }
        let containerView = transitionContext.containerView
        if transitionContext.transitionWasCancelled {
          containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        }
        let screenBounds = UIScreen.main.bounds
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
     
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseInOut],
            animations: {
                fromVC.view.frame = finalFrame
            },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}
