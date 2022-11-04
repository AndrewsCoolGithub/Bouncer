//
//  EventCreationVC.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/29/22.
//

import Foundation
import Firebase
import UIKit
import FloatingPanel
import UIImageColors
import CoreLocation
import Combine
import NVActivityIndicatorView

final class EventCreationVC: UIViewController, ObservableObject{
    
    struct Static{ /// Disposable Singleton
        fileprivate static var instance: EventCreationVC?
        static var isDisposed: Bool = false
    }

    
    class var shared: EventCreationVC{
        if Static.instance == nil{
            Static.instance = EventCreationVC()
            Static.isDisposed = false
        }
        return Static.instance!
    }
    
    class func dispose(){
        EventCreationVC.Static.isDisposed = true
        EventCreationVC.Static.instance = nil
        EventCreationVC.initController = nil
        print("Disposed Singleton instance")
    }
    
    private static var initController: CurrentVC?
    static var initImage: UIImage?
    static var colors: UIImageColors!
    let viewModel = EventCreationVM()
    
    static var isDraft: Bool = false
    class func setup(_ currentVC: CurrentVC? = nil, image: UIImage, colors: UIImageColors, with data: EventDraft? = nil){
        EventCreationVC.initController = currentVC
        EventCreationVC.initImage = image
        EventCreationVC.colors = colors
        shared.viewModel.colors = EventCreationVC.colors
        shared.viewModel.image = image
       
        if let data = data {
            EventCreationVC.isDraft = true
            shared.viewModel.eventTitle = data.title
            shared.viewModel.descrip = data.description
            
            if let location = data.location {
                shared.viewModel.location = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            }
            
            if let startDate = data.startsAt{
                if startDate < .now{
                    shared.viewModel.startDate = .now.rounded(minutes: 15)
                }else{
                    shared.viewModel.startDate = startDate
                }
            }
            
            shared.viewModel.duration = data.duration ?? 3600
            shared.viewModel.eventType = data.type
            shared.viewModel.currentController = shared.viewModel.currentVC(type: EventCreationValidator.firstMissingProp)
        }else{
            shared.viewModel.currentController = currentVC
        }
    }
    
   
    //MARK: - Save Event Progress
    public func save(){
        viewModel.save()
        dismiss()
    }
    
    //MARK: - Dismiss and Dispose
    public func dismiss(){
        if let navController = navigationController{
                navController.popToRootViewController(animated: true)
                viewModel.currentController = nil
                viewModel.controllerInMemory.removeAll()
                cancellable.forEach({$0.cancel()})
                previewVC = nil
                EventCreationVC.dispose()
        }
    }
  
    
    @objc func openCamera(){
        if let index = navigationController?.tabBarController?.selectedViewController?.navigationController?.viewControllers.firstIndex(where: {$0 is CameraVC}){
            navigationController?.tabBarController?.selectedViewController?.navigationController?.viewControllers.remove(at: index)
        }
//        if let cameraVCIndex = navigationController?.viewControllers.firstIndex(where: {$0 is CameraVC}){
//            navigationController?.viewControllers.remove(at: cameraVCIndex)
//        }
        let cameraVC = CameraVC(currentVC: viewModel.currentController)
        navigationController?.pushViewController(cameraVC, animated: true)
    }
    
    
    var cancellable = Set<AnyCancellable>()
    
    //MARK: - Init
    private init(){
        super.init(nibName: nil, bundle: nil)
        
        guard let image = EventCreationVC.initImage else {
            fatalError("Error - you must call setup before accessing EventCreation.shared")
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextView(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
       
        panel.layout = PanelLayout()
        panel.delegate = self
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = .makeWidth(25)
        appearance.backgroundColor = .greyColor()
        
        panel.surfaceView.appearance = appearance
        panel.surfaceView.grabberHandle.isHidden = true
        panel.addPanel(toParent: self)
        panel.panGestureRecognizer.delegateProxy = self
        
        view.addSubview(rectImageView)
        
        rectImageView.image = image
        
        effectView.frame = rectImageView.bounds
        rectImageView.addSubview(effectView)
        
        view.addSubview(self.viewHeaderLabel)
        viewHeaderLabel.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: .makeHeight(85))
        
        view.addSubview(self.navigator)
        navigator.nextButton.addTarget(self, action: #selector(nextController), for: .touchUpInside)
        navigator.backButton.addTarget(viewModel, action: #selector(viewModel.previousController), for: .touchUpInside)
        
        view.sendSubviewToBack(self.rectImageView)
        
       
        xButton.frame.origin = CGPoint(x:  .makeWidth(12.5), y: SafeArea.topSafeArea() + .makeHeight(5))
        view.addSubview(xButton)

        let saveMenu = UIMenu(children: [
            UIAction(title: "Save", image: UIImage(systemName: "folder.fill")) { [weak self] _ in
                self?.save()
            },
            UIAction(title: "Discard", image: UIImage(systemName: "pencil.slash")) { [weak self] _ in
                self?.dismiss()
           }
        ])

        xButton.showsMenuAsPrimaryAction = true
        xButton.menu = saveMenu
  
        cameraButton.frame.origin = CGPoint(x:  .makeWidth(414 - 17.5) - cameraButton.frame.size.width, y: SafeArea.topSafeArea() + .makeHeight(5))
        view.addSubview(cameraButton)
        cameraButton.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        
        listenForCurrentVCChanges()
        listenForOverview()
    }
    
    @objc func nextController(){
        if let type = viewModel.currentController?.type.next(), viewModel.onPreview == false{
            viewModel.currentController = viewModel.currentVC(type: type)
        }else if viewModel.currentController?.type.next() == nil{
            Task{
                do{
                    //Loading Indicator
                    indicator.startAnimating()
                    view.addSubview(indicator)
                    try await viewModel.postEvent()
                    indicator.stopAnimating()
                    indicator.removeFromSuperview()
                    HapticsManager.shared.vibrate(for: .success)
                    //Stop Loading, present success
                    
                    self.dismiss()
                }catch{
                    //Stop Loading
                    indicator.stopAnimating()
                    indicator.removeFromSuperview()
                    print("Error Posting Event: \(error.localizedDescription)")
                    HapticsManager.shared.vibrate(for: .error)
                    //Determine failing data type  -> Please update info alert
                }
            }
        }else{
            viewModel.currentController = viewModel.currentVC(type: EventCreationValidator.firstMissingProp)
        }
    }
    
    fileprivate func listenForCurrentVCChanges() {
        viewModel.$currentController.sink { [unowned self] currentVC in
            guard let currentVC = currentVC else {return}
            self.rectImageView.image = EventCreationVC.initImage
            let type = currentVC.type
            let backButtonOpacity: Float = viewModel.onPreview ? 0 : 1
            switch type{
            case .eventTitle:
                panel.set(contentViewController: currentVC.controller)
                viewHeaderLabel.text = "Choose your event’s title"
                navigator.performAnimation(previous: 0, progress: 0.16, colors: EventCreationVC.shared.viewModel.colors!)
                navigator.deactivateButton()
                navigator.backButton.layer.opacity = 0
            case .eventDescription:
                panel.set(contentViewController: currentVC.controller)
                viewHeaderLabel.text = "Make a description"
                navigator.performAnimation(previous: 0.16, progress: 0.33, colors: EventCreationVC.shared.viewModel.colors!)
                navigator.backButton.layer.opacity = backButtonOpacity
            case .eventLocation:
                panel.set(contentViewController: currentVC.controller)
                viewHeaderLabel.text = "Where's your event?"
                navigator.performAnimation(previous: 0.33, progress: 0.48, colors: EventCreationVC.shared.viewModel.colors!)
                navigator.backButton.layer.opacity = backButtonOpacity
            case .eventSchedule:
                panel.set(contentViewController: currentVC.controller)
                viewHeaderLabel.text = "When's your event?"
                navigator.performAnimation(previous: 0.48, progress: 0.67, colors: EventCreationVC.shared.viewModel.colors!)
                navigator.backButton.layer.opacity = backButtonOpacity
            case .eventType:
                panel.set(contentViewController: currentVC.controller)
                viewHeaderLabel.text = "What kind of event is this?"
                viewHeaderLabel.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: .makeWidth(414) * (163 / 414) / 1.85)
                navigator.performAnimation(previous: 0.67, progress: 0.84, colors: EventCreationVC.shared.viewModel.colors!)
                navigator.backButton.layer.opacity = backButtonOpacity
            case .eventOverview:
                panel.set(contentViewController: currentVC.controller)
                viewHeaderLabel.text = "Are you ready to post?"
                viewHeaderLabel.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: .makeWidth(414) * (163 / 414) / 1.85)
                navigator.performAnimation(previous: 0.84, progress: 1, colors: EventCreationVC.shared.viewModel.colors!)
                navigator.backButton.layer.opacity = 1
            }
        }.store(in: &cancellable)
    }
    
    //MARK: - Navigation
    let overview = EventOverview()
    let interactor = Interactor()
    
    func listenForOverview(){
        viewModel.$shouldPresentOverview.sink { [unowned self] bool in
            guard bool != nil else {return}
            navigationController?.present(overview, animated: true)
            //viewModel.shouldPresentOverview = nil
        }.store(in: &cancellable)
    }

    var previewVC: CurrentVC?

    
    
    ///😡This is now broken, view starts to move up and pops back to original positon
    //MARK: - Keyboard
    lazy var dismissKeyboardGesture = UITapGestureRecognizer(target: panel, action: #selector(panel.dismissKeyboard))
//    @objc func updateTextView(notification: Notification){
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if notification.name == UIResponder.keyboardDidHideNotification{
//                view.removeGestureRecognizer(dismissKeyboardGesture)
//                view.frame.origin.y = 0
//                self.navigator.frame = CGRect(x: 0, y: .makeHeight(816), width: .makeWidth(414), height: .makeHeight(80))
//            }else{
//                view.addGestureRecognizer(dismissKeyboardGesture)
//                let change: CGFloat = viewModel.currentController!.type == .eventLocation ? -.makeHeight(200) : -.makeHeight(60)
//                let navigatorChange: CGFloat = viewModel.currentController!.type == .eventLocation ? .makeHeight(896 + 120) : .makeHeight(896 - 20)
//                view.frame.origin.y = change
//                self.navigator.frame = CGRect(x: 0, y: navigatorChange - keyboardSize.height, width: .makeWidth(414), height: .makeHeight(80))
//            }
//        }
//    }
//    @objc func updateTextView(notification: Notification){
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if notification.name == UIResponder.keyboardWillHideNotification{
//                view.removeGestureRecognizer(dismissKeyboardGesture)
//                view.frame.origin.y = 0
////                self.navigator.frame = CGRect(x: 0, y: .makeHeight(816), width: .makeWidth(414), height: .makeHeight(80))
//            }else{
//                view.addGestureRecognizer(dismissKeyboardGesture)
////                let change: CGFloat = viewModel.currentController?.type == .eventLocation ? -.makeHeight(200) : -.makeHeight(60)
////                let navigatorChange: CGFloat = viewModel.currentController?.type == .eventLocation ? .makeHeight(896 + 120) : .makeHeight(896 - 20)
//                view.frame.origin.y -= keyboardSize.height
////                self.navigator.frame = CGRect(x: 0, y: navigatorChange - keyboardSize.height, width: .makeWidth(414), height: .makeHeight(80))
//            }
//        }
//    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboard = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            

            panel.layout = TypingLayout()
            panel.invalidateLayout()
            panel.move(to: .full, animated: true)
            navigator.frame.origin.y = keyboard.origin.y - navigator.frame.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        
        
//        panel.delegate = nil
        panel.layout = PanelLayout()
        panel.invalidateLayout()
//        panel.delegate = self
        panel.move(to: .full, animated: true)
        navigator.frame.origin.y = .makeHeight(816)
//        if self.tabBarController?.view.frame.origin.y != 0 {
//            self.tabBarController?.view.frame.origin.y = 0
//        }
    }
    
    
    //MARK: - UI Elements
    let panel = FloatingPanelController()
    
    private let effectView: UIVisualEffectView = {
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.alpha = 1
        return effectView
    }()
   
    private let rectImageView: UIImageView = {
        let rectImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: .makeWidth(414), height: .makeWidth(414) * (183 / 414)))
        rectImageView.layer.masksToBounds = true
        rectImageView.clipsToBounds = true
        rectImageView.contentMode = .scaleAspectFill
        return rectImageView
    }()
    
    let navigator: EventCreationNavigator = {
         let navigator = EventCreationNavigator()
         return navigator
    }()
    
    private let viewHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(22))
        label.textColor = .white
        label.alpha = 1
        return label
    }()
    
    private let xButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: .makeWidth(45), height: .makeWidth(45))))
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(25))
        button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        return button
    }()
    
    let cameraButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: .makeWidth(45), height: .makeWidth(45))))
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(25))
        button.setImage(UIImage(systemName: "camera.badge.ellipsis", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        return button
    }()
    
//    private let popup: EventSavePopup = {
//        let popup = EventSavePopup()
//        popup.modalPresentationStyle = .overCurrentContext
//        popup.modalTransitionStyle = .crossDissolve
//        return popup
//    }()
    
    let indicator: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: .layoutRect(width: 414, height: 896, rectCenter: .center), type: .ballPulseSync, color: .white, padding: 150)
        view.backgroundColor = .black.withAlphaComponent(0.2)
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EventCreationVC: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       DismissAnimator()
    }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
       interactor.hasStarted ? interactor : .none
    }
}

class CurrentVC: Hashable{ //Linked List with values being UIViewController
    static func == (lhs: CurrentVC, rhs: CurrentVC) -> Bool {
        lhs.type == rhs.type
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
    }
    
    var type: EventCreateVCTypes
    var controller: UIViewController?
    var previous: CurrentVC?
    
    
    init(type: EventCreateVCTypes, controller: UIViewController? = nil, previous: CurrentVC?){
        self.controller = controller
        self.type = type
        self.previous = previous
    }
}

class TypingLayout: FloatingPanelLayout{
    var position: FloatingPanelPosition = .bottom
    var initialState: FloatingPanelState = .full
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [.full: FloatingPanelLayoutAnchor(absoluteInset: .makeHeight(100), edge: .top, referenceGuide: .safeArea)]
    }
}

class PanelLayout: FloatingPanelLayout{
    var position: FloatingPanelPosition = .bottom
    var initialState: FloatingPanelState = .full
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [.full: FloatingPanelLayoutAnchor(absoluteInset: .makeWidth(414) * 153/414, edge: .top, referenceGuide: .superview)]
    }
}

extension EventCreationVC: FloatingPanelControllerDelegate{
    
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        
        let loc = vc.surfaceLocation
        let minY = vc.surfaceLocation(for: .full).y
        let maxY = vc.surfaceLocation(for: .tip).y
        vc.surfaceLocation = CGPoint(x: loc.x, y: min(max(loc.y, minY), maxY))
        rectImageView.frame.size.height = min(max(loc.y, minY), maxY).rounded() + .makeHeight(35)
        
        let top = loc.y - .makeWidth(414) * 183/414
        effectView.alpha = 1 - (top / 80)
        viewHeaderLabel.alpha = 1 - (top / 80)
        xButton.alpha = 1 - (top / 80)
        cameraButton.alpha = 1 - (top / 80)
    }
}

extension EventCreationVC: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer is UITapGestureRecognizer && otherGestureRecognizer is UIPanGestureRecognizer {
            return true
        }
        
        if gestureRecognizer is UIPanGestureRecognizer && otherGestureRecognizer is UITapGestureRecognizer {
            return true
        }
        
        return false
    }
}


extension UIColor{
    
    /**
     Returns Codable friendly color data.
     Converts colors darker than 25.5 RGB to White for gradient visibility.
     */
    
    func getColorModel() -> ColorModel{
        guard let r = self.cgColor.components?.first, let g = self.cgColor.components?[1], let b = self.cgColor.components?[2] else { return ColorModel(r: 1, g: 1, b: 1)}
        let color = (r > 0.1 || g > 0.1 || b > 0.1) ? ColorModel(r: r, g: g, b: b) : ColorModel(r: 1, g: 1, b: 1)
        return color
    }
}

