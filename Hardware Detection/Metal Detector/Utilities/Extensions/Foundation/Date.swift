//
//  Date.swift
//  myRivu
//
//  Created by TBC on 24/02/20.
//  Copyright © 2020 Hakikat Singh. All rights reserved.
//

import Foundation

// MARK: DIFFRENT DATE FORMATTERS

extension NSDate {
    func ToLocalStringWithFormat(dateFormat: String) -> String {
        // change to a readable time format and change to local time zone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: self as Date)
        return timeStamp
    }
}

extension Date{
    
    func getDateFor(days:Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: Date())
    }
    
    func dateString( _ days : Int) -> String{
        let dateFormatter = DateFormatter()
        let date = self.getDateFor(days: days)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let _date = date else{return ""}
        return dateFormatter.string(from: _date)
    }
    
    func isoDate(_ days : Int)-> String{
        let date = self.getDateFor(days: days)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        guard let _date = date else{return ""}
        return formatter.string(from: _date)
    }
    
    func stringToDate(string: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd HH:mm:ss"
        let date = dateFormatter.date(from: string) ?? Date()
        return date
    }
    
    
    func getFormattedDate() -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "EEEE, MMM d, yyyy"
        return dateformat.string(from: self)
    }
}


extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}


extension Formatter {
    static let iso8601 = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}


extension String {
    var iso8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
    
}

// MARK: UTC TIME TO LOCALE

public func UTCtoNow(convertedDate: String) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    let date = dateFormatter.date(from: convertedDate)
    
    dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
    dateFormatter.timeZone = NSTimeZone.local
    guard let _date = date else{return ""}
    let timeStamp = dateFormatter.string(from: _date)
    return timeStamp
    
}

// MARK: TIME CALCULATION

extension Date {
    
    // time to display in mins,hours,date(old chat)
    func timeAgoDisplay() -> String {
        
        let calendar = Calendar.current
        
        guard let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date()) else {return ""}
        guard let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date()) else {return ""}
        guard let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date()) else {return ""}
        guard let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) else {return ""}
        
        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            debugPrint(diff)
            return "Just now"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            if diff == 1{
                return "\(diff) min ago"
            }
            return "\(diff) mins ago"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            if diff == 1{
                return "\(diff) hour ago"
            }
            return "\(diff) hours ago"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            if diff == 1{
                return "\(diff) day ago"
            }
            return "\(diff) days ago"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        if diff == 1{
            return "\(diff) week ago"
        }
        return "\(diff) weeks ago"
        
    }
    
    // time to display in date only(New chat)
    func dateAgoDisplay() -> String {
        let calendar = Calendar.current
        
        let currentDate = Date()
        let startOfToday = calendar.startOfDay(for: currentDate)
        
        // Calculate the time interval in seconds between the message date and now
        let timeInterval = currentDate.timeIntervalSince(self)
        
        if calendar.isDateInToday(self) {
            return "Today"
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        } else {
            return self.getFormattedDate()
        }
    }
    
}
