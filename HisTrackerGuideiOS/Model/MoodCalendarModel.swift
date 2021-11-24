//
//  MoodCalendarModel.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 13.11.2021.
//

import Foundation

class MoodCalendarModel {
    
    var moodType: MoodType
    var startEnd: MoodStartEnd
    var calendarModel: CalendarModel
    
    init(moodType: MoodType, startEnd: MoodStartEnd, calendarModel: CalendarModel) {
        self.moodType = moodType
        self.startEnd = startEnd
        self.calendarModel = calendarModel
    }
}
