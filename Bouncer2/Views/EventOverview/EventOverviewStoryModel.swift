//
//  EventOverviewStoryModel.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/23/22.
//

import AVFoundation
import UIKit
import Combine
import FirebaseFirestore
import SDWebImage

final class EventOverviewStoryModel: ObservableObject{
    
    
    var stories: [Story] = [] {
        didSet{
            setup(self.stories)
        }
    }
    @Published var views: [StoryView] = []
    @Published var thumbnail: UIImage?
    
    var event: Event?
    var cancellable = Set<AnyCancellable>()
    var currentIndex: Int = 0
    
    var tempThumNailCache = Set<String>()
    
    private let listenerID = "EventOverviewStoryModel_Stories"
    
    init(event: Event?){
        self.event = event
        if let event = event{
            let query = STORY_REF.whereField(StoryFields.eventId.rawValue, isEqualTo: event.id!).order(by: StoryFields.date.rawValue)
            FirestoreSubscription.subscribeToCollection(with: query, id: listenerID).sink { [unowned self] snap in
                self.stories = snap.documents.compactMap { doc -> Story? in
                    return try? doc.data(as: Story.self)
                }
            }.store(in: &cancellable)
        }else{
            print("Setup story model for non-event uses")
        }
    }
    
    private func setup(_ stories: [Story]){
        determineCurrentIndex(stories)
        views = stories.map({StoryView(story: $0, event: event)})
        setThumbnail(stories)
    }
    
    fileprivate func determineCurrentIndex(_ stories: [Story]){
        guard let uid = User.shared.id else {return}
        guard stories.count > 0 else {return}
        for i in 0..<stories.count{
            let story = stories[i]
            guard story.storyViews.contains(where: {$0.uid == uid}) else {
                currentIndex = i
                break
            }
        }
    }
    
    fileprivate func setThumbnail(_ stories: [Story]) {
        if let last = stories.last, !tempThumNailCache.contains(last.id!), last.type == .video{
            createThumbnailOfVideoFromRemoteUrl(url: last.url, isMirrored: last.shouldMirror, completion: { [weak self] image in
                self?.thumbnail = image
            })
            tempThumNailCache.insert(last.id!)
        }else if let last = stories.last, last.type == .image{
            let imageView =  UIImageView()
            imageView.sd_setImage(with: URL(string: last.url)) { [weak self] I, E, C, U in
                self?.thumbnail = imageView.image
            }
        }else{
            //TODO: Make plus symbol same gradient as event image, remove camera button when no storiesa
            let config = UIImage.SymbolConfiguration(pointSize: .wProportioned(35))
            let image = UIImage(systemName: "plus", withConfiguration: config)
            
            let imageView = UIImageView(image: image)
            imageView.tintColor = .white
            self.thumbnail = imageView.image
        }
    }
    
    fileprivate func createThumbnailOfVideoFromRemoteUrl(url: String, isMirrored: Bool, completion: @escaping(UIImage) -> Void){
        
        let asset = AVAsset(url: URL(string: url)!)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(3.0, preferredTimescale: 600)
    
        generator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { (time, thumbnail, cmtime, result, error) in
            if (thumbnail != nil) {
                return completion(UIImage(cgImage: thumbnail!))
            }
        }
    }
    
    deinit{
        FirestoreSubscription.cancel(id: listenerID)
        cancellable.forEach({$0.cancel()})
    }
}
