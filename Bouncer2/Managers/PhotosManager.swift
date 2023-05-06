//
//  PhotosManager.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/29/23.
//

import Photos
import UIKit

class PhotosManager{
    
    static let shared = PhotosManager()
    
    private init(){}
    
    func fetchAssets() -> PHFetchResult<PHAsset>{
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return PHAsset.fetchAssets(with: .image, options: fetchOptions)
    }
    
    func getImage(from asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        var thumbnail = UIImage()
        options.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 135, height: 135), contentMode: .aspectFill, options: options) { image, info in
            thumbnail = image ?? thumbnail
        }
        
        return thumbnail
    }
}


