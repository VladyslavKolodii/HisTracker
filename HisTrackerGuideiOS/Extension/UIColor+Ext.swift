//
//  UIColor+Ext.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 19.12.2021.
//

import Foundation
import UIKit

extension UIColor {
    class var articleBackgroundColor: Self {
        let moodStartDate = CalendarUtil().convertStringToDate(dateFormat: "yyyy-MM-dd", date: APPUSER.mood)
        let moodType: MoodType = AppUtil.getMoodType(moodStartDate: moodStartDate, currentDate: Date())
        if moodType == .MENSTURATION {
            return self.init(named: "redGradientStart")!
        } else if moodType == .OVULATION {
            return self.init(named: "yellowGradientStart")!
        } else {
            return self.init(named: "mainSky_10")!
        }
    }
}
