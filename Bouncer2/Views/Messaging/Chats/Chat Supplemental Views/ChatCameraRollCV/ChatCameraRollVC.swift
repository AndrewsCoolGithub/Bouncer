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
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let collectionView = components.collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
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
        0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: (.makeWidth(414)/3) - 5, height: (.makeWidth(414)/3) - 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        0
    }
}
