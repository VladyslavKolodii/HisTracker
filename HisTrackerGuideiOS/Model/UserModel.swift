//
//  UserModel.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 12.11.2021.
//

import Foundation
import FirebaseFirestore

class UserModel {
    
    var token: String = Bundle.main.bundleIdentifier!
    var userID: String = ""
    var name: String = ""
    var email: String = ""
    var wifename: String = ""
    var mood: String = ""
    var period: Int = 28
       
    
    func initFromFireStore(snapShot: [String: Any]) {
        if let token = snapShot["token"] as? String {
            self.token = token
        } else {
            self.token = ""
        }
        
        if let userID = snapShot["userID"] as? String {
            self.userID = userID
        } else {
            self.userID = ""
        }
        
        if let name = snapShot["name"] as? String {
            self.name = name
        } else {
            self.name = ""
        }
        
        if let email = snapShot["email"] as? String {
            self.email = email
        } else {
            self.email = ""
        }
        
        if let wifename = snapShot["wifename"] as? String {
            self.wifename = wifename
        } else {
            self.wifename = ""
        }
        
        if let mood = snapShot["mood"] as? String {
            self.mood = mood
        } else {
            self.mood = ""
        }
        
        if let period = snapShot["period"] as? Int {
            self.period = period
        } else {
            self.period = 28
        }
    }
    
    func toFireStore() -> [String: Any] {
        return [
            "token": token,
            "userID": userID,
            "name": name,
            "email": email,
            "wifename": wifename,
            "mood": mood,
            "period": period
        ]
    }
}
