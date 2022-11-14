//
//  EventPreview.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/11/22.
//

import Foundation
import UIKit
import UIImageColors

class EventPreview: UIViewController, UIPageViewControllerDelegate{
    
    private let pageVC: PageViewController = {
        let pageVC = PageViewController(frame: CGRect(x: 0, y: .makeHeight(60), width: .makeWidth(414), height: .makeHeight(896-100)))
        return pageVC
    }()
    
    @Published var panRec: UIPanGestureRecognizer?
    
    private var views = [UIViewController]()
    
    private var currentIndex: Int {
        guard let vc = pageVC.viewControllers?.first else { return 0 }
        return self.views.firstIndex(of: vc) ?? 0
    }
    
    private let previewHeader: EventPreviewHeader = {
        let previewHeader = EventPreviewHeader(buttonTitles: ["List", "Full", "Map"])
        return previewHeader
    }()
    
   
    init(event: EventDraft, image: UIImage){
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .greyColor()
        
        let eventList = EventCellPreview(event: event, image: image)
        eventList.view.tag = 0
        let fullView = EventFull(event, image: image)
        fullView.view.tag = 1
        let mapView = EventMapPreview(event: event, image: image)
        mapView.view.tag = 2
        
        self.views = [eventList, fullView, mapView]
        
        pageVC.setViewControllers([eventList], direction: .forward, animated: true)
        pageVC.dataSource = self
        pageVC.delegate = self
        addChild(pageVC)
        pageVC.didMove(toParent: self)
        view.addSubview(pageVC.view)
        
        let pageVC_ScrollView = pageVC.view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView
        pageVC_ScrollView?.delegate = self
        pageVC_ScrollView?.panGestureRecognizer.maximumNumberOfTouches = 1
        
        
        view.addSubview(previewHeader)
        previewHeader.buttons.forEach({$0.addTarget(self, action: #selector(buttonPress(sender:)), for: .touchUpInside)})
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //slider
        previewHeader.slider.gradientColors = (EventCreationVC.shared.viewModel.colors!, true)
        //for list:
        let listCell = self.views[0] as? EventCellPreview
        listCell?.updateView()
        
        //for full:
        let full = self.views[1] as? EventFull
        full?.updateView()
        
        //for map:
        let mapPreview = self.views[2] as? EventMapPreview
        mapPreview?.updateAnnotation()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        opacityAnimation.duration = 1.5
        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.fillMode = .forwards
        EventCreationVC.shared.cameraButton.layer.add(opacityAnimation, forKey: "cameraButtonOpacity0")
       
        
       // gradientView.layer.insertSublayer(gradient, at: 0)
        
        //for map
//
        let nextButtonTitle = EventCreationVC.shared.viewModel.oldEvent == nil ? "Post It" : "Update"
        UIView.transition(with: EventCreationVC.shared.navigator.nextButton.titleLabel!, duration: 1, options: [.curveEaseOut, .transitionCrossDissolve]) {
            
            EventCreationVC.shared.navigator.nextButton.setTitle(nextButtonTitle, for: .normal)
            
        }
        
        UIView.transition(with: EventCreationVC.shared.navigator.backButton.titleLabel!, duration: 1, options: [.curveEaseOut, .transitionCrossDissolve]) { EventCreationVC.shared.navigator.backButton.setAttributedTitle(NSAttributedString(string: "Edit", attributes:  [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single, NSAttributedString.Key.font: UIFont.poppinsMedium(size: .makeHeight(20)), NSAttributedString.Key.foregroundColor: UIColor.darkerGreyText()]), for: .normal)
           
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0
        opacityAnimation.toValue = 1
        opacityAnimation.duration = 1.5
        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.fillMode = .forwards
        
        //TODO: Place this logic in Navigator 
        if !EventCreationVC.Static.isDisposed{
            EventCreationVC.shared.cameraButton.layer.add(opacityAnimation, forKey: "cameraButtonOpacity1")
           // EventCreationVC.shared.navigator.nextButton.setTitle(nil, for: .normal)
            
            UIView.transition(with: EventCreationVC.shared.navigator.nextButton.titleLabel!, duration: 1, options: [.curveEaseInOut, .transitionCrossDissolve]) { EventCreationVC.shared.navigator.nextButton.setTitle(" Preview ", for: .normal)
               
            }
        }
    }
    
    @objc func buttonPress(sender: UIButton){
        previewHeader.animateToPosition(sender.tag, fromButton: true)
        guard sender.tag != self.currentIndex else {return}
        let controller = views[sender.tag]
        let direction: UIPageViewController.NavigationDirection = self.currentIndex > sender.tag ? .reverse : .forward
        pageVC.setViewControllers([controller], direction: direction, animated: true)
    }
}
enum PreviewPostion{
    case list
    case full
    case map
}

extension EventPreview: UIScrollViewDelegate{
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        var percentComplete: CGFloat
        percentComplete = (point.x - view.frame.size.width)/view.frame.size.width
        previewHeader.translateSlider(change: percentComplete)
        print("%", percentComplete)
    }
}

extension EventPreview: UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard completed else {return}
       previewHeader.animateToPosition((pageViewController.viewControllers?.first?.view.tag)!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let firstIndex = self.views.firstIndex(of: viewController), firstIndex > 0 else {
            return self.views.last
        }
        
        return self.views[firstIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let firstIndex = self.views.firstIndex(of: viewController), firstIndex < 2 else {
            return self.views.first
        }
        
        return self.views[firstIndex + 1]
    }
}

class HeaderButton: UIButton{
    var position: PreviewPostion!
    
    init(position: PreviewPostion, title: String, tag: Int){
        super.init(frame: CGRect(x: 0, y: 0, width: .makeWidth(80), height: .makeHeight(35)))
        self.position = position
        self.setTitle(title, for: .normal)
        self.tag = tag
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
