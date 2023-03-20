//
//  StoryViewController.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/24/22.
//

import UIKit



final class StoryViewController: UIViewController, UIPageViewControllerDelegate{
    
    private var currentView: StoryView {
        return views[currentIndex]
    }
    
    //MARK: - UI Components
    let pageVC: PageViewController = {
        let pageVC = PageViewController(frame: CGRect(x: 0, y: 0, width: .makeWidth(414), height: .makeHeight(896)))
        return pageVC
    }()
    
    private let leftView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let rightView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private var currentIndex: Int {
        guard let vc = pageVC.viewControllers?.first else { return 0 }
        return self.views.firstIndex(of: vc as! StoryView) ?? 0
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var views = [StoryView]()
    var forwardGesture: UITapGestureRecognizer!
    var backGesture: UITapGestureRecognizer!
    var pauseGesture: UILongPressGestureRecognizer!
    var pauseGesture2: UILongPressGestureRecognizer!
    
    init(_ views: [StoryView], startIndex: Int, event: Event?){
        super.init(nibName: nil, bundle: nil)
        self.views = views
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        
        pageVC.dataSource = self
        pageVC.delegate = self
        addChild(pageVC)
        pageVC.didMove(toParent: self)
        view.addSubview(pageVC.view)
        pageVC.gestureRecognizers.forEach({$0.isEnabled = false})
        pageVC.view.layer.masksToBounds = true
        pageVC.setViewControllers([views[startIndex]], direction: .forward, animated: true)
        
        view.addSubview(leftView)
        leftView.centerY(inView: view, leftAnchor: view.leftAnchor)
        leftView.setDimensions(height: .makeHeight(896), width: .makeWidth(207))

        view.addSubview(rightView)
        rightView.centerYright(inView: view, rightAnchor: view.rightAnchor)
        rightView.setDimensions(height: .makeHeight(896), width: .makeWidth(207))
        
        pauseGesture = UILongPressGestureRecognizer(target: self, action:  #selector(pause))
        pauseGesture.minimumPressDuration = 0.2
        pauseGesture2 = UILongPressGestureRecognizer(target: self, action:  #selector(pause))
        pauseGesture2.minimumPressDuration = 0.2
        
        forwardGesture = UITapGestureRecognizer(target: self, action: #selector(tapForward))
        forwardGesture.require(toFail: pauseGesture)
        
        backGesture = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        pauseGesture.require(toFail: pauseGesture2)
       
        leftView.addGestureRecognizer(backGesture)
        leftView.addGestureRecognizer(pauseGesture)
       
        rightView.addGestureRecognizer(forwardGesture)
        rightView.addGestureRecognizer(pauseGesture2)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        views.forEach({$0.player?.pause()})
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func pause(_ sender: UILongPressGestureRecognizer){
        guard currentIndex < views.count else {return}
        let storyView = views[currentIndex]
        storyView.pause(sender.state)
    }

    
    @objc func tapForward(){
        if currentIndex < views.count - 1 {
            pageVC.setViewControllers([views[currentIndex + 1]], direction: .forward, animated: false)
        }else{
            navigationController?.dismiss(animated: true)
        }
    }

    @objc func tapBack(){
        if currentIndex > 0 {
            pageVC.setViewControllers([views[currentIndex - 1]], direction: .reverse, animated: false)
        }else{
            navigationController?.dismiss(animated: true)
        }
    }
}


extension StoryViewController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let firstIndex = views.firstIndex(of: viewController as! StoryView), firstIndex > 0 else {
            return nil
        }
        
        return views[firstIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let firstIndex = views.firstIndex(of: viewController as! StoryView), firstIndex < views.count - 1 else {
            return nil
        }
        
        return self.views[firstIndex + 1]
    }
}
