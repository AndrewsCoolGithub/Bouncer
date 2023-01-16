//
//  Story.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/23/22.
//
import FirebaseFirestoreSwift

struct Story: Identifiable, Hashable, Equatable, Codable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Story, rhs: Story) -> Bool {
        return lhs.id == rhs.id
    }
    
    @DocumentID var id: String? = UUID().uuidString
    let eventId: String?
    let userId: String
    let url: String
    let type: MediaType
    let shouldMirror: Bool
    let date: Date
    private let _storyViews: [StoryViews]
    
    var storyViews = Set<StoryViews>()
    
    
     init(id: String? = nil, eventId: String?, userId: String, url: String, type: MediaType, shouldMirror: Bool, date: Date, _storyViews: [StoryViews], storyViews: Set<StoryViews> = Set<StoryViews>()) {
        self.id = id
        self.eventId = eventId
        self.userId = userId
        self.url = url
        self.type = type
        self.shouldMirror = shouldMirror
        self.date = date
        self._storyViews = _storyViews
        
        
        self.storyViews = storyViews.union(_storyViews)
        
        
        print(_storyViews)
        print(self.storyViews)
    }
    
    public func logView() {
        guard let id = id else {return}
        StoryManager.shared.logView(id, eventId)
    }
     
}

struct StoryViews: Codable, Hashable{
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
    
    let uid: String
    let date: Date
}

enum MediaType: String, Codable{
    case video = "video"
    case image = "image"
}
