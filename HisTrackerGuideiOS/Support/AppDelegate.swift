//
//  AppDelegate.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 9.11.2021.
//

import UIKit
import IQKeyboardManager
import Firebase
import FirebaseMessaging
import Foundation
import AudioToolbox
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate {
    
    var window: UIWindow?
    var audioPlayer: AVAudioPlayer?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared().isEnabled = true
        FirebaseApp.configure()
        
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {(granted, error) in
                
            })
            application.registerForRemoteNotifications()
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        Messaging.messaging().delegate = self
        
        //Alarm Part
        var error: NSError?
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch let error1 as NSError{
            error = error1
            print("could not set session. err:\(error!.localizedDescription)")
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error1 as NSError{
            error = error1
            print("could not active session. err:\(error!.localizedDescription)")
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
//    @available(iOS 9.0, *)
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        return GIDSignIn.sharedInstance.handle(url)
//    }
    
//    //receive local notification when app in foreground
//    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
//
//        //show an alert window
//
//        var isSnooze: Bool = false
//        var soundName: String = ""
//        var title: String = ""
//        var index: Int = -1
//        if let userInfo = notification.userInfo {
//            isSnooze = userInfo["snooze"] as! Bool
//            soundName = userInfo["soundName"] as! String
//            index = userInfo["index"] as! Int
//        }
//        self.alarmModel = Alarms()
//        let diff = CalendarUtil().getDiffBetweenTwoDate(start: Date(), end: alarmModel.alarms[index].date)
//        if abs(diff) % 28 != 0 {
//            return
//        }
//        title = alarmModel.alarms[index].label
//        let storageController = UIAlertController(title: "Alarm", message: title, preferredStyle: .alert)
//        playSound(soundName)
//        //schedule notification for snooze
//        if isSnooze {
//            let snoozeOption = UIAlertAction(title: "Snooze", style: .default) {
//                (action:UIAlertAction)->Void in self.audioPlayer?.stop()
//                self.alarmScheduler.setNotificationForSnooze(snoozeMinute: 9, soundName: soundName, index: index)
//            }
//            storageController.addAction(snoozeOption)
//        }
//        let stopOption = UIAlertAction(title: "OK", style: .default) {
//            (action:UIAlertAction)->Void in self.audioPlayer?.stop()
//            AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
//            self.alarmModel = Alarms()
//            self.alarmModel.alarms[index].onSnooze = false
//        }
//        storageController.addAction(stopOption)
//        window = (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).window
//        window?.visibleViewController?.present(storageController, animated: true, completion: nil)
//    }
//
//    //snooze notification handler when app in background
//    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
//        var index: Int = -1
//        var soundName: String = ""
//        if let userInfo = notification.userInfo {
//            soundName = userInfo["soundName"] as! String
//            index = userInfo["index"] as! Int
//        }
//        self.alarmModel = Alarms()
//        let diff = CalendarUtil().getDiffBetweenTwoDate(start: Date(), end: alarmModel.alarms[index].date)
//        if abs(diff) % 28 != 0 {
//            completionHandler()
//        } else {
//            self.alarmModel.alarms[index].onSnooze = false
//            if identifier == Id.snoozeIdentifier {
//                alarmScheduler.setNotificationForSnooze(snoozeMinute: 9, soundName: soundName, index: index)
//                self.alarmModel.alarms[index].onSnooze = true
//            }
//            completionHandler()
//        }
//    }
//
//    //AlarmApplicationDelegate protocol
//    func playSound(_ soundName: String) {
//
//        //vibrate phone first
//        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//        //set vibrate callback
//        AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate),nil,
//            nil,
//            { (_:SystemSoundID, _:UnsafeMutableRawPointer?) -> Void in
//                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//            },
//            nil)
//        let url = URL(fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: "mp3")!)
//
//        var error: NSError?
//
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: url)
//        } catch let error1 as NSError {
//            error = error1
//            audioPlayer = nil
//        }
//
//        if let err = error {
//            print("audioPlayer error \(err.localizedDescription)")
//            return
//        } else {
//            audioPlayer!.delegate = self
//            audioPlayer!.prepareToPlay()
//        }
//
//        //negative number means loop infinity
//        audioPlayer!.numberOfLoops = -1
//        audioPlayer!.play()
//    }
//
//    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
//
//        print(notificationSettings.types.rawValue)
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        alarmScheduler.checkNotification()
//    }
    
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token  = fcmToken {
            #if DEBUG
            print(token)
            #endif
        } else {
            #if DEBUG
            print(Bundle.main.bundleIdentifier!)
            #endif
        }
        
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
}



