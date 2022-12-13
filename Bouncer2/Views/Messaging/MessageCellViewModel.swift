//
//  MessageCellViewModel.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/10/22.
//

import Foundation

class MessageCellViewModel: ObservableObject{
    
    let messageDetail: MessageDetail
    @Published var userData = [String: Profile]()
    
   
    
    init(_ messageDetail: MessageDetail){
        self.messageDetail = messageDetail
        
        for i in messageDetail.users{
            Task{
                userData[i] = try await USERS_COLLECTION.document(i).getDocument(as: Profile.self)
            }
        }
    }
}
