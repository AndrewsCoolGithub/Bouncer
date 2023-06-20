//
//  ChatCameraRollVC.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/1/23.
//

import UIKit
import Photos

class ChatCameraRollVC: UIViewController{
    
    var fetchResult: PHFetchResult<PHAsset> = PhotosManager.shared.fetchAssets()
    let components = ChatCameraRollViewComponents()
    
    weak var collectionView: UICollectionView?
    enum DragState{
        case collectionView
        case floatingPanel
    }
    
    var dragState: DragState = .collectionView
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let collectionView = components.collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        
        view.addSubview(collectionView)
        self.collectionView = collectionView
        collectionView.allowsMultipleSelection = true
    }
    
//    @objc func determineOffset(_ sender: UIPanGestureRecognizer){}
    
}

extension ChatCameraRollVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        fetchResult.count * 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let indexPath = IndexPath(row: Int.random(in: 0..<fetchResult.count), section: indexPath.section)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCameraRollCVCell.id, for: indexPath) as! ChatCameraRollCVCell
        let asset = fetchResult.object(at: indexPath.row)
        cell.setup(asset)
        return cell
    }
}

extension ChatCameraRollVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: (.makeWidth(414)/3), height: (.makeWidth(414)/3))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.panGestureRecognizer.location(in: view).y
         
        
        guard let panel = self.parent as? ChatCameraRollPanel else {return}
        let loc = panel.surfaceLocation
        let maxY = panel.surfaceLocation(for: .full).y
        
        if dragState == .floatingPanel || y < 0{
            panel.surfaceLocation = CGPoint(x: loc.x, y: max(loc.y + y, maxY))
            panel.floatingPanelDidMove(panel)
            dragState = .floatingPanel
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        guard let panel = self.parent as? ChatCameraRollPanel else {return}
        if dragState == .floatingPanel {
            let tipLocation = panel.surfaceLocation(for: .tip).y
            let tipRange = (tipLocation-45...tipLocation+45)
            if tipRange.contains(panel.surfaceLocation.y) {
                panel.move(to: .tip, animated: true)
            }else if tipRange.lowerBound < panel.surfaceLocation.y {
                panel.move(to: .hidden, animated: true)
                let chatVC = panel.parent as? ChatViewController
                chatVC?.showBar()
                panel.removePanelFromParent(animated: false)
            }else{
                panel.move(to: .full, animated: true)
            }
        }
        dragState = .collectionView
    }
}
