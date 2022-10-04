//
//  ContactsManager.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/7/22.
//

import Foundation
import Contacts
import Firebase

let REF_CONTACTS = Firestore.firestore().collection("Contact Requests")
final class ContactsManager {
    static let instance = ContactsManager()
    
    public lazy var contacts: [Contact] = {
        var alreadyThere = Set<Contact>()
        return self.getContacts().compactMap { (post) -> Contact? in
            guard !alreadyThere.contains(post) else { return nil }
            alreadyThere.insert(post)
            return post
        }
    }()

    private func getContacts() -> [Contact] {
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactThumbnailImageDataKey,
            CNContactImageDataAvailableKey,
            CNContactImageDataKey] as [Any]
        
        var results: [CNContact] = []
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                } catch {
                    print("Error fetching containers: \(error.localizedDescription)")
                }
            }
        }catch {
            print("Error with containers: \(error.localizedDescription)")
        }
       
        return makeContacts(results)
    }
    
    public func fetchContactsWAccount(_ contacts: [Contact]) async throws -> [Profile]{
        var allNumbers = contacts.map { $0.number }
        var result = [Profile]()
                
        while allNumbers.count > 0{
            let index = allNumbers.count - 10 > 0 ? allNumbers.count - 10 : 0
            let numbers = allNumbers.suffix(from: index)
            allNumbers.removeLast(numbers.count)
            let userDocs = try await USERS_COLLECTION.whereField(ProfileFields.number.rawValue, in: Array(numbers))
                .getDocuments()
                .documents
            result += userDocs.compactMap { doc in
                if User.shared.following.contains(doc.documentID) || doc.documentID == User.shared.id!{
                    return nil
                }else{
                    return try? doc.data(as: Profile.self)
                }
            }
        }
        
        return result
    }
    
    func makeContacts(_ cnContacts: [CNContact]) -> [Contact]{
        var results = [Contact]()
           
           
           for val in cnContacts {
               let contact = val
               if let number = contact.phoneNumbers.first?.value.stringValue, number.filter("0123456789".contains).count >= 9{
                   let image: UIImage? = contact.imageDataAvailable ? UIImage(data: contact.imageData!) : nil
                   let name = (contact.givenName + " " + contact.familyName).trimmingCharacters(in: .whitespacesAndNewlines)
                   var number = number.filter("0123456789".contains)
                   if name.count > 0{
                       while number.count > 10{
                           number = String(number.dropFirst())
                       }
                       
                       results.append(Contact(name: name, number: number, image: image))
                    }
                }
            }
              
            return results
    }
    
}
extension Collection{
    
    func myContactMap<T>(_ transform : (Contact) throws -> T ) rethrows -> [T] {
        var results = [T]()
           
           
           for val in self {
               if let contact = val as? CNContact, let number = contact.phoneNumbers.first?.value.stringValue, number.filter("0123456789".contains).count >= 9{
                   let image: UIImage? = contact.imageDataAvailable ? UIImage(data: contact.imageData!) : nil
                   let name = (contact.givenName + " " + contact.familyName).trimmingCharacters(in: .whitespacesAndNewlines)
                   var number = number.filter("0123456789".contains)
                   if name.count > 0{
                       while number.count > 10{
                           number = String(number.dropFirst())
                       }
                       
                       results.append(try transform(Contact(name: name, number: number, image: image)))
                    }
                }
            }
              
            return results
    }
}
