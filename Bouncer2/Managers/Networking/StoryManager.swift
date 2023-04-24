//
//  StoryManager.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/23/22.
//

import FirebaseFirestoreSwift
import FirebaseFirestore

let STORY_REF = Firestore.firestore().collection("Stories")
final class StoryManager{
    
    static let shared = StoryManager()
    
    private init(){}
    
    
    public func postStory(_ story: Story, _ ref: DocumentReference) throws{
        try ref.setData(from: story)
//        USERS_COLLECTION.document(story.userId).updateData(["storiesPosted":  FieldValue.arrayUnion([ref.documentID])])
//        if let eventID = story.eventId {
//            try EVENTS_COLLECTION.document(eventID).collection("Stories").document(ref.documentID).setData(from: story)
//        }
    }
    
    public func delete(_ storyID: String){
        STORY_REF.document(storyID).delete()
    }
    
    public func logView(_ storyID: String, _ eventID: String? = nil){
        guard let uid = User.shared.id else {return}
        STORY_REF.document(storyID).collection("Views").document(uid).setData(["date": Date.now])
    }
}
