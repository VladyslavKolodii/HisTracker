//
//  CalendarUtil.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 11.11.2021.
//

import Foundation

enum DateFormat {
    case FULL, MEDIUM, SHORT, MINITIME, FULLMONTH, FULLYEAR
    
    var format: String {
        switch self {
        case .FULL:
            return "EEEE, dd MMMM, yyyy"
        case .MEDIUM:
            return "yyyy-MMMM-dd"
        case .SHORT:
            return "yyyy-MM-dd"
        case .MINITIME:
            return "hh:mm a"
        case .FULLYEAR:
            return "yyyy"
        case .FULLMONTH:
            return "MMMM"
        }
    }
}

class CalendarUtil {
    let calendar = Calendar.current
    
    func plusMonth(date: Date) -> Date {
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    func minusMonth(date: Date) -> Date {
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func getNextDay(date: Date) -> Date {
        return calendar.date(byAdding: .day, value: 1, to: date)!
    }
    
    func getPreviousDay(date: Date) -> Date {
        return calendar.date(byAdding: .day, value: -1, to: date)!
    }
    
    func monthString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.FULLMONTH.format
        return dateFormatter.string(from: date)
    }
    
    func yearString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.FULLYEAR.format
        return dateFormatter.string(from: date)
    }
    
    func getAllDaysInMonth() -> [Date] {
        var days = [Date]()
        var day = firstOfMonth(date: Date())
        for _ in 1...daysInMonth(date: Date()) {
            days.append(day)
            day = getNextDay(date: day)
        }
        return days
    }
    
    func daysInMonth(date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    func dayOfMonth(date: Date) -> Int {
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    func firstOfMonth(date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    func weekDay(date: Date) -> Int {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }
    
    func convertDateToString(dateFormat: String, date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = dateFormat
        let strDate = df.string(from: date)
        return strDate
    }
        
    func convertStringToDate(dateFormat: String, date: String) -> Date {
        let df = DateFormatter()
        df.dateFormat = dateFormat
        let strDate = df.date(from: date)
        return strDate!
    }
    
    func getDiffBetweenTwoDate(start: Date, end: Date) -> Int {
        let startDate = calendar.startOfDay(for: start)
        let endDate = calendar.startOfDay(for: end)
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day!
    }
    
    func getDaySuffix(date: Date) -> String {
        let day = calendar.component(.day, from: date)
        if day % 10 == 1 {
            return "st"
        } else if day % 10 == 2 {
            return "nd"
        } else if day % 10 == 3 {
            return "rd"
        } else {
            return "th"
        }
    }
    
    func getDateWithSuffix(date: Date) -> String {
        let suffix = getDaySuffix(date: date)
        let df = DateFormatter()
        df.dateFormat = "dd'\(suffix)' MMMM yyyy"
        let strDate = df.string(from: date)
        return strDate
    }
}
