//
//  UImageViewExt.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/1/23.
//

import UIKit
import Photos

extension UIImageView {
    func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize, version:  PHImageRequestOptionsVersion = .current, deliveryMode: PHImageRequestOptionsDeliveryMode = .opportunistic) {
        let options = PHImageRequestOptions()
        options.version = version
        options.deliveryMode = deliveryMode
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options) { image, _ in
            guard let image = image else { return }
            switch contentMode {
            case .aspectFill: self.contentMode = .scaleAspectFill
            case .aspectFit:  self.contentMode = .scaleAspectFit
            @unknown default: fatalError()
            }
            self.image = image
        }
    }
}
