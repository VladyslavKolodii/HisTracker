//
//  CalendarModel.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 11.11.2021.
//

import Foundation

class CalendarModel {
    var date: String
    var title: String
    var isInCurrentMonth: Bool
    var isSelected: Bool
    
    
    init(date: Date, title: String, isInCurrentMonth: Bool, isSelected: Bool) {
        self.date = CalendarUtil().convertDateToString(dateFormat: "EEEE, dd MMMM, yyyy", date: date)
        self.title = title
        self.isInCurrentMonth = isInCurrentMonth
        self.isSelected = isSelected
    }
}
