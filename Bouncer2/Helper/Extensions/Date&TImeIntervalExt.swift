//
//  DateExt.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/4/22.
//

import Foundation

extension Date{
    
    enum DateRoundingType {
        case round
        case ceil
        case floor
    }
    
    static func timeAt(hour: Int, minute: Int) -> Date{
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!

        //get the month/day/year componentsfor today's date.
        var date_components = calendar.components(
          [NSCalendar.Unit.hour,
           NSCalendar.Unit.minute],
          from: .now)

        //Create an NSDate for the specified time today.
       
        date_components.hour = hour
        date_components.minute = minute
        date_components.second = 0
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
   
    func rounded(minutes: TimeInterval, rounding: DateRoundingType = .round) -> Date {
        return rounded(seconds: minutes * 60, rounding: rounding)
    }
    
    func rounded(seconds: TimeInterval, rounding: DateRoundingType = .round) -> Date {
        var roundedInterval: TimeInterval = 0
        switch rounding  {
        case .round:
            roundedInterval = (timeIntervalSinceReferenceDate / seconds).rounded() * seconds
        case .ceil:
            roundedInterval = ceil(timeIntervalSinceReferenceDate / seconds) * seconds
        case .floor:
            roundedInterval = floor(timeIntervalSinceReferenceDate / seconds) * seconds
        }
        return Date(timeIntervalSinceReferenceDate: roundedInterval)
    }
    
    
    
    
//    func timeAt(hour: Int, minute: Int) -> Date{
//        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
//
//        //get the month/day/year componentsfor today's date.
//        var date_components = calendar.components(
//          [NSCalendar.Unit.hour,
//           NSCalendar.Unit.minute],
//          from: self)
//
//        //Create an NSDate for the specified time today.
//
//        date_components.hour = hour
//        date_components.minute = minute
//        date_components.second = 0
//        let newDate = calendar.date(from: date_components)!
//        return newDate
//    }
}
extension TimeInterval{
    
    /** Format:  // 4 hours
     // 1 day
     // 30 seconds // etc. */
    var timeInUnits: String {
        let timeDif = self
        
        let minute: Double = 60
        let hour: Double = 3600
        let day: Double = 86400
        
        if timeDif >= 1 && timeDif < minute{ //Seconds
            let result = abs(Int(timeDif.rounded(.towardZero)))
            return "\(result) seconds"
        }else if timeDif >= minute && timeDif < hour{ //Minutes
            let result = abs(Int(timeDif/minute.rounded(.towardZero)))
            return result > 1 ? "\(result) minutes" : "\(result) minute"
        }else if timeDif >= hour && timeDif < day{ //Hours
            let result = abs(Int(timeDif/hour.rounded(.towardZero)))
            return result > 1 ? "\(result) hours" : "\(result) hour"
        }else{ //Days
            let result = abs(Int(timeDif/day.rounded(.towardZero)))
            return result > 1 ? "\(result) days" : "\(result) day"
        }
    }
    
    /** Format: 1d 11h 11m */
    var countDownWithUnits: String{
        let timeDif = abs(self)
        let minute: Double = 60
        let hour: Double = 3600
        let day: Double = 86400
        
        
        if timeDif > day{
            let d = (timeDif/day).rounded(.towardZero)
            let h = ((timeDif - d * day)/hour).rounded(.towardZero)
            let m = ((timeDif - (h * hour) - (d * day))/minute).rounded(.towardZero)
            return "\(Int(d))d \(Int(h))h \(Int(m))m"
        }else if timeDif > hour{
            let h = (timeDif/hour).rounded(.towardZero)
            let m = ((timeDif - (h * hour))/minute).rounded(.towardZero)
            let s = timeDif - (h * hour) - (m * minute)
            return "\(Int(h))h \(Int(m))m \(Int(s))s"
        }else if timeDif > minute{
            let m = (timeDif/minute).rounded(.towardZero)
            let s = timeDif - (m * minute)
            return "\(Int(m))m \(Int(s))s"
        }else{
            return "\(Int(timeDif.rounded(.towardZero)))s"
        }
        
        
    }
    /** Format: Just now // 10h // 1d // etc.  */
    var timeInSmallUnits: String {
        let timeDif = self
        
        let minute: Double = 60
        let hour: Double = 3600
        let day: Double = 86400
        
        if timeDif > 0 && timeDif < minute{ //Seconds
            //let result = Int(timeDif.rounded(.towardZero))
            return "Just now"
        }else if timeDif >= minute && timeDif < hour{ //Minutes
            let result = Int(timeDif/minute.rounded(.towardZero))
            return "\(result)m"
        }else if timeDif >= hour && timeDif < day{ //Hours
            let result = Int(timeDif/hour.rounded(.towardZero))
            return "\(result)h"
        }else{ //Days
            let result = Int(timeDif/day.rounded(.towardZero))
            return "\(result)d"
        }
    }
    /** Format:  6 months // Today  // 1 year // etc. */
    var timeInBigUnits: String{
        let day: Double = 86400
        let month: Double = day * 30
        let year: Double = day * 365
        
        let time = abs(self)
        
        
        if time / day <= 1{
            return "Today"
        }else if time / day > 1 && time < month {
            return "\(time/day.rounded(.towardZero)) days"
        }else if time / month >= 1 && time < year {
            let val = time / month.rounded(.towardZero)
            return val > 1 ? "\(val) months" : "\(val) month"
        }else{
            let val = time / year.rounded(.towardZero)
            return val == 1 ? "\(val) year" : "\(val) years"
        }
    }
}
