//
//  DraftManager.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/16/22.
//

import Foundation
import UIImageColors

class DraftManager: ObservableObject{
    
    
    static let shared = DraftManager()
    private init(){
        self.draftPublisher = eventDraft
    }
    
    @Published var draftPublisher: EventDraft?
    
    private var eventDraft: EventDraft? {
        get{
            if let object = UserDefaults.standard.value(forKey: DraftKeys.events) as? Data {
                let decoder = JSONDecoder()
                do{
                    let eventsDecoded = try decoder.decode(EventDraft.self, from: object) as EventDraft
                    return eventsDecoded
                }catch{
                    print(error)
                    return nil
                }
            }else{
                return nil
            }
        }
        set{
            self.draftPublisher = newValue
        }
    }
    
    
    public func saveEventDraft(_ event: EventDraft, image: UIImage) throws{
         do {
             let encoder = JSONEncoder()
             //if let eventDraft = DraftManager.shared.eventDraft{
                 //if try self.removeEventDraft(id: eventDraft.id){
                     try self.saveImage(image: image, id: event.id)
                     let data = try encoder.encode(event)
                     UserDefaults.standard.set(data, forKey: DraftKeys.events)
                     self.eventDraft = event
//                 }else{
//                     throw ImageError.failedToDelete
//                 }
            // }else{
//                 try self.saveImage(image: image, id: event.id)
//                 let data = try encoder.encode(event)
//                 UserDefaults.standard.set(data, forKey: DraftKeys.events)
//                 self.eventDraft = event
//             }
         } catch {
             print("Unable to Encode Event (\(error.localizedDescription))")
             throw error
         }
     }
    
    public func removeEventDraft(id: String) throws -> Bool{
        do{
            try deleteImage(id: id)
            UserDefaults.standard.removeObject(forKey: DraftKeys.events)
            self.eventDraft = nil
            return true
        }catch{
            throw error
        }
    }
    
    private func deleteImage(id: String) throws {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = paths.appendingFormat("/" + "\(id).jpeg")
        do {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                try fileManager.removeItem(atPath: filePath)
            }
        }catch{
            print(error.localizedDescription)
            throw error
        }
    }
    
    private func saveImage(image: UIImage, id: String) throws {
        guard let data = image.jpegData(compressionQuality: 1) else { throw ImageError.failedToSave}
        do {
            let directory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as URL
            try data.write(to: directory.appendingPathComponent("\(id).jpeg"))
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}

enum ImageError: Error{
    case failedToSave
    case failedToDelete
}
class DraftKeys{
    static let events = "eventDrafts"
}

