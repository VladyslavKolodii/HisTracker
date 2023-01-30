//
//  AppUtil.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 12.11.2021.
//

import Foundation
import CRNotifications

class AppUtil {
    
    static func showBanner(type: CRNotificationType, title: BannerTitle, content: String) {
        CRNotifications.showNotification(type: type, title: title.rawValue, message: content, dismissDelay: 2.0)
    }
    
    static func onShowProgressView(_ parentVC: UIViewController) {
        let child = LoadingVC()
        parentVC.addChild(child)
        child.view.frame = parentVC.view.frame
        parentVC.view.addSubview(child.view)
        child.didMove(toParent: parentVC)
    }
    
    static func onHideProgressView(_ parentVC: UIViewController) {
        parentVC.children.forEach { (child) in
            if child.isKind(of: LoadingVC.self) {
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
            }
        }
    }
    
    static func getMoodType(moodStartDate: Date, currentDate: Date) -> MoodType {
        let diff = CalendarUtil().getDiffBetweenTwoDate(start: moodStartDate, end: currentDate)
        let mode = abs(diff % 28)
        if mode == 0 {
            return .MENSTURATION
        }
        if diff > 0 {
            if mode < 6 {
                return .MENSTURATION
            } else if mode > 13 && mode < 20 {
                return .OVULATION
            } else {
                return .NONE
            }
        } else {
            if mode > 22 {
                return .MENSTURATION
            } else if mode >= 9 && mode <= 14 {
                return .OVULATION
            } else {
                return .NONE
            }
        }
    }
    
    static func getMoodTypeStartDate(moodDate: Date) -> [Date] {
        var dateStartArr = [Date]()
        dateStartArr.append(CalendarUtil().getDateFromDate(diff: 14, date: moodDate))/// ovulation
        dateStartArr.append(moodDate)/// menstrual
        dateStartArr.append(CalendarUtil().getDateFromDate(diff: 6, date: moodDate))/// luteal
        dateStartArr.append(CalendarUtil().getDateFromDate(diff: 20, date: moodDate))/// follicular
        return dateStartArr
    }
}
