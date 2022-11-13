//
//  SuiteCellDelegate.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/12/22.
//

import Foundation

protocol SuiteCellDelegate: AnyObject {
    
    func openProfile(_ profile: Profile)
    
    /** Notifies users from Suggested Section that you want them to RSVP if event is open type. Sends invite from either Requests Section or Suggested Section if event is exclusive type. */
    func inviteUser(_ id: String)
    
    /** Removes users from Requests Section if event is exclusive */
    func removeUser(_ id: String)
    
    /** Cancels a sent invitation */
    func cancelInvite(_ id: String)
    
}
