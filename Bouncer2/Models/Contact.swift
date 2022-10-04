//
//  ContactModel.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/7/22.
//

import Foundation
import FirebaseFirestoreSwift
import UIKit

struct Contact: Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(number)
    }
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.number == rhs.number
    }
    
    
    let name: String
    let number: String
    let image: UIImage?
    
}
