//
//  AppConstants.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 10.11.2021.
//

import Foundation
import UIKit

var APPUSER: UserModel = UserModel()

var FIRECONFIGSTATUS: [String] = [String]()

var LANDINGMODELS: [OnboardingModel] = [OnboardingModel]()

enum SegueNames: String {
    case goAuthSegue, goMainFromLogin, goSpouse, goSposeFromLogin, goMainFromRegister, goMainRegisterCompletion
}

enum MoodType: String {
    case NONE, OVULATION, MENSTURATION
    var description: String {
        switch self {
        case .NONE:
            return ""
        case .OVULATION, .MENSTURATION:
            return self.rawValue
        }
    }
    
    func getMoodStartEnd(arr: [MoodCalendarModel], type: MoodType) -> MoodStartEnd {
        if arr.isEmpty {
            return .START
        } else if arr.count == 41 {
            return .END
        } else {
            let beforeType = arr.last?.moodType
            if beforeType == type {
                return .NORMAL
            } else {
                arr.last?.startEnd = .END
                return .START
            }
        }
    }
}

enum MoodStartEnd {
    case START, END, NORMAL
}

enum BannerTitle: String {
    case Success, Failed, Warning
}
