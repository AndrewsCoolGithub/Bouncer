//
//  ViewController.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/23/22.
//

import UIKit
import Combine
import SDWebImage
import UIImageColors
import NVActivityIndicatorView

class EventList: UIViewController {
    
    let codeSegmented = CustomSegmentedControl(frame: CGRect(x: .makeWidth(57), y:  .makeHeight(90), width: .makeWidth(300), height: .makeHeight(54)), buttonTitle: ["All Events", "My Events"])
   
    let allEventsVC = AllEventsViewController()
    let myEventsVC = MyEventsViewController()
    
    
    public var indexVar: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .greyColor()
        
        codeSegmented.delegate = self
        codeSegmented.backgroundColor = .greyColor()
        view.addSubview(codeSegmented)
        
        let cvViewFramePoint = CGPoint(x: 0, y: codeSegmented.frame.maxY)
        let collectionViewFrame = CGRect(origin: cvViewFramePoint, size: CGSize(width: view.frame.width,
                                                                                height:  view.frame.height - (cvViewFramePoint.y)))
        
        allEventsVC.view.frame = collectionViewFrame
        myEventsVC.view.frame = collectionViewFrame
        
        if codeSegmented.selectedIndex == 0 || indexVar == 0{
            self.addChild(allEventsVC)
            allEventsVC.didMove(toParent: self)
            view.addSubview(allEventsVC.view)
        }else if codeSegmented.selectedIndex == 1 || indexVar == 1{
            self.addChild(myEventsVC)
            myEventsVC.didMove(toParent: self)
            view.addSubview(myEventsVC.view)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("Segemnted Frame: \(codeSegmented.frame)")
    }
}

extension EventList: CustomSegmentedControlDelegate{
    func change(to index: Int) {
        indexVar = index

        if indexVar == 0{
            self.addChild(allEventsVC)
            allEventsVC.didMove(toParent: self)
            view.addSubview(allEventsVC.view)
            
            myEventsVC.view.removeFromSuperview()
            myEventsVC.removeFromParent()
        }else{
            self.addChild(myEventsVC)
            myEventsVC.didMove(toParent: self)
            view.addSubview(myEventsVC.view)
            
            allEventsVC.view.removeFromSuperview()
            allEventsVC.removeFromParent()
        }
    }
}
