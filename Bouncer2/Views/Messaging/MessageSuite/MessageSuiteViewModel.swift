//
//  MessageSuiteViewModel.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 8/28/22.
//

import Foundation
import Combine
import Firebase

class MessageSuiteViewModel: ObservableObject{
    
    @Published var messageDetails: [MessageDetail]?
    
    @Published var suggestedUsers = [Profile]()
    var isLoading: Bool {
        !User.shared.following.isEmpty
    }
    
    var cancellable = Set<AnyCancellable>()
    
    init(){
        FirestoreSubscription.subscribeToCollection(collection: .Chats, fromServer: false).sink { [weak self] snapshot in
            self?.messageDetails = snapshot.documents.compactMap { (doc) -> MessageDetail? in
                return try? doc.data(as: MessageDetail.self)
            }
        }.store(in: &cancellable)
        
        getDefaultUsers()
    }
    
    func getDefaultUsers(){
        Task{
            suggestedUsers = await User.shared.following.getUsers()
        }
    }
}
