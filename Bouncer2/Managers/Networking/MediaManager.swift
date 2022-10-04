//
//  MediaManager.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/13/22.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore

final class MediaManager{
    enum MediaError: Error{
        case failedToGetData
    }
    
    enum MediaType{
        case event
    }
    static func uploadImage(_ image: UIImage, path: StorageReference) async throws -> String{
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {throw MediaError.failedToGetData}
        let _ = try await path.putDataAsync(imageData)
        let url = try await path.downloadURL()
        return url.absoluteString
    }
}


