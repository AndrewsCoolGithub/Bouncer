//
//  AccountData.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/7/22.
//

import Foundation
import FirebaseFirestoreSwift

struct AccountData: Codable, Identifiable, Equatable, Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: AccountData, rhs: AccountData) -> Bool {
        return lhs.id == rhs.id
    }
    
    @DocumentID var id: String? = UUID().uuidString
    var number: String?
    var user_name: String?
    var display_name: String?
    var image_url: String?
    
}
