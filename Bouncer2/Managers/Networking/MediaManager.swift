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
import AVFoundation

final class MediaManager{
    enum MediaError: Error{
        case failedToGetData
        case nilImage
    }
    
    enum MediaType{
        case event
    }
    static func uploadImage(_ image: UIImage?, path: StorageReference) async throws -> String{
        guard let image = image else {throw MediaError.nilImage}
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {throw MediaError.failedToGetData}
        let _ = try await path.putDataAsync(imageData)
        let url = try await path.downloadURL()
        return url.absoluteString
    }
    
    static func uploadVideo(_ url: URL, path: StorageReference, shouldFlip: Bool = false) async throws -> String {
        
        let metadata = StorageMetadata()
        metadata.contentType = "video/mp4"
        
        let name = "\(Int(Date().timeIntervalSince1970)).mp4"
        let tempPath = NSTemporaryDirectory() + name
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let outputurl = documentsURL.appendingPathComponent(name)
        let ur = outputurl
        try await self.convertVideo(toMP4: url, outputURL: outputurl, shouldFlip: shouldFlip)
            

        guard let data = NSData(contentsOf: ur as URL) as? Data else {throw MediaError.failedToGetData}
        do {
            try data.write(to: URL(fileURLWithPath: tempPath), options: .atomic)
        } catch {

            print(error)
        }


        let _ = try await path.putDataAsync(data, metadata: metadata)
        let url = try await path.downloadURL()
        return url.absoluteString
    }
    
    private static func convertVideo(toMP4 inputURL: URL, outputURL: URL, shouldFlip: Bool) async throws{
        
        let asset = AVAsset(url: inputURL)
        
        let composition = AVMutableComposition()
        let assetVideoTrack = asset.tracks(withMediaType: .video).last!
        if let audio = try await asset.loadTracks(withMediaType: .audio).last{
            let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))
            try? audioTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: asset.duration),
                                        of: audio,
                                        at: CMTime.zero)
        
        }
        
        let compositionVideoTrack = composition.addMutableTrack(withMediaType: AVMediaType.video,
                                                                preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))
        
        try? compositionVideoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: asset.duration),
                                                    of: assetVideoTrack,
                                                    at: CMTime.zero)
        if shouldFlip{
            
            compositionVideoTrack?.preferredTransform = assetVideoTrack.preferredTransform
        }else{
            compositionVideoTrack?.preferredTransform = assetVideoTrack.preferredTransform
        }
        
        
        try? FileManager.default.removeItem(at: outputURL as URL)

        let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)!
        exportSession.outputURL = outputURL
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.outputFileType = .mp4
        await exportSession.export()
    }
}


