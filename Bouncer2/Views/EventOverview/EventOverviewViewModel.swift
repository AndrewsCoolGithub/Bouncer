//
//  EventOverviewViewModel.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/11/22.
//

import Combine
import Foundation

class EventOverviewViewModel: ObservableObject{
    
    var cancellable = Set<AnyCancellable>()
    
     var event: Event {
        didSet{
           updateData(event)
        }
    }
    
    private var allIds: [String] { //Lump sum of all id's, only used as input parameter for 'updateGuestData'
        didSet{
            updateGuestData(allIds)
        }
    }
    
    private var guestIds: [String] = []
    private var peopleYouKnowIds: [String] = []
    
    @Published var colors: [ColorModel]
    @Published var imageURL: String
    @Published var title: String
    @Published var host: Profile!
    @Published var guests: [Profile] = []
    @Published var peopleYouKnow: [Profile] = []
    
    
    init(event: Event) {
        self.event = event
        self.imageURL = event.imageURL
        self.title = event.title
        self.allIds = event.guestIds ?? []
        self.colors = event.colors
        
        Task{
            self.host = await "OGilTZWBcHbRbcJwZGE6rkjxqsl2".getUser()
        }
        
        FirestoreSubscription.subscribe(id: "MR4kdMeeeQbnEyHcLEIW", collection: .Events).receive(on: DispatchQueue.main).sink { [weak self] doc in
            guard let event = try? doc.data(as: Event.self) else {return}
            self?.event = event
        }.store(in: &cancellable)
    }
    
    private func updateData(_ event: Event){
        self.imageURL = event.imageURL
        self.title = event.title
        self.allIds = event.guestIds ?? []
        self.colors = event.colors
    }
    
    private func updateGuestData(_ allIds: [String]){
        let following = User.shared.following
        self.guestIds = []
        self.peopleYouKnowIds = []
    
        for id in allIds {
            guard following.contains(id) else {self.guestIds.append(id); continue}
            self.peopleYouKnowIds.append(id)
        }
        
        Task{
            self.peopleYouKnow = await self.peopleYouKnowIds.getUsers()
            self.guests = await self.guestIds.getUsers()
        }
    }
}
