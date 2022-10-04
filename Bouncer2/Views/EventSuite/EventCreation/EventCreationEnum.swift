//
//  EventCreationEnum.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/1/22.
//

import Foundation
enum EventCreateVCTypes: Error{
    case eventTitle
    case eventDescription
    case eventLocation
    case eventSchedule
    case eventType
    case eventOverview
}

extension EventCreateVCTypes{
    func next() -> EventCreateVCTypes?{
        switch self {
        case .eventTitle:
            return .eventDescription
        case .eventDescription:
            return .eventLocation
        case .eventLocation:
            return .eventSchedule
        case .eventSchedule:
            return .eventType
        case .eventType:
            return .eventOverview
        case .eventOverview:
            return nil
        }
    }
}
