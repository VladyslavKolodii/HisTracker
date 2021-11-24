//
//  PredictionModel.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 12.11.2021.
//

import Foundation

class PredictionModel {
    init(moodType: MoodType, dates: [Date]) {
        self.moodType = moodType
        self.dates = dates
    }
    
    var moodType: MoodType
    var dates: [Date]
}
