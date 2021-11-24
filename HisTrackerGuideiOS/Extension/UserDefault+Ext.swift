//
//  UserDefaultUtil.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 9.11.2021.
//

import Foundation

extension UserDefaults {
    private enum Keys: String {
        case isPassedLanding, isLoggedIn, isCompleteSpose, fcmToken, userName
    }
    
    class var isPassedLanding: Bool {
        get {
            return self.standard.bool(forKey: Keys.isPassedLanding.rawValue)
        }
        set {
            self.standard.set(newValue, forKey: Keys.isPassedLanding.rawValue)
        }
    }
    
    class var isLoggedIn: Bool {
        get {
            return self.standard.bool(forKey: Keys.isLoggedIn.rawValue)
        }
        set {
            self.standard.set(newValue, forKey: Keys.isLoggedIn.rawValue)
        }
    }
    
    class var isCompleteSpouse: Bool {
        get {
            return self.standard.bool(forKey: Keys.isCompleteSpose.rawValue)
        }
        set {
            self.standard.setValue(newValue, forKey: Keys.isCompleteSpose.rawValue)
        }
    }
    
    class var fcmToken: String {
        get {
            return self.standard.string(forKey: Keys.fcmToken.rawValue)!
        } set {
            self.standard.set(newValue, forKey: Keys.fcmToken.rawValue)
        }
    }
    
    class var userName: String {
        get {
            return self.standard.string(forKey: Keys.userName.rawValue)!
        } set {
            self.standard.set(newValue, forKey: Keys.userName.rawValue)
        }
    }
}
