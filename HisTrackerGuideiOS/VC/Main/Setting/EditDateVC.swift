//
//  EditDateVC.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 12.11.2021.
//

import UIKit
import CRNotifications

class EditDateVC: UIViewController {

    @IBOutlet weak var dateTF: IconTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dateTF.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCalenderTF)))
        let moodDate = CalendarUtil().convertStringToDate(dateFormat: "yyyy-MM-dd", date: APPUSER.mood)
        let strMoodDate = CalendarUtil().convertDateToString(dateFormat: "EEEE, dd MMMM, yyyy", date: moodDate)
        dateTF.setValue(value: strMoodDate)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func didTapCalenderTF() {
        let vc = CalendarPickerVC.instantiatFromAppStoryboard(appStoryboard: .Auth)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func makeTitleString(index: Int) -> String {
        if index == 0 {
            return "3 days before"
        } else if index == 1 {
            return "2 days before"
        } else if index == 2 {
            return "1 day before"
        } else {
            return "On"
        }
    }
    
    @IBAction func didTapBackUB(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapSaveUB(_ sender: UIButton) {
        AppUtil.onShowProgressView(self)
        let moodDate = CalendarUtil().convertStringToDate(dateFormat: "EEEE, dd MMMM, yyyy", date: dateTF.getValue())
        let strMood = CalendarUtil().convertDateToString(dateFormat: "yyyy-MM-dd", date: moodDate)
        FireUtil.instance.saveUserMoodDate(date: strMood) { [self] (result) in
            if result {
                AppUtil.onHideProgressView(self)
                AppUtil.showBanner(type: CRNotifications.success, title: .Success, content: "Successed")
                APPUSER.mood = strMood
                let moodArr: [Int] = UserDefaults.notificationType

                if moodArr.isEmpty {
                    AppUtil.showBanner(type: CRNotifications.info, title: .Warning, content: "Notifiy when Jessica is starting.")
                    return
                }

                let selectedDayIndex: Int = UserDefaults.notificationDate
                
                let moodDate = CalendarUtil().convertStringToDate(dateFormat: "yyyy-MM-dd", date: APPUSER.mood)
                let strMoodDate = CalendarUtil().convertDateToString(dateFormat: "yyyy-MM-dd", date: moodDate)
                let moodTime = "00:00:00"
                let strTotalDate = strMoodDate + " " + moodTime
                let totalDate = CalendarUtil().convertStringToDate(dateFormat: "yyyy-MM-dd hh:mm", date: strTotalDate)
                var diff = 0
                if selectedDayIndex == 0 {
                    diff = -3
                } else if selectedDayIndex == 1 {
                    diff = -2
                } else if selectedDayIndex == 2 {
                    diff = -1
                } else {
                    diff = 0
                }
                let notificationDate = CalendarUtil().getDateFromDate(diff: diff, date: totalDate)
                let center = UNUserNotificationCenter.current()
                center.removeAllPendingNotificationRequests()
                center.removeAllDeliveredNotifications()
                moodArr.forEach { (index) in
                    let tempDate = AppUtil.getMoodTypeStartDate(moodDate: notificationDate)[index]
                    for i in 0...13 {
                        let content = UNMutableNotificationContent()
                        let stepper = i * 28 * 86400
                        if index == 0 {
                            content.title = "Ovulation Phase"
                            content.body = makeTitleString(index: selectedDayIndex) + " " + "Ovulation phase"
                            content.sound = .default
                            content.userInfo = ["type": "Ovulation"]
                            let strTempDate = CalendarUtil().convertDateToString(dateFormat: "yyyy-MM-dd HH:mm:ss", date: tempDate.addingTimeInterval(TimeInterval(stepper)))
                            print("Ovulation===>\(strTempDate)")
                            var dateComponent = DateComponents()
                            dateComponent.year = Int(strTempDate.components(separatedBy: "-")[0])
                            dateComponent.month = Int(strTempDate.components(separatedBy: "-")[1])
                            let lastdateComponents = (strTempDate.components(separatedBy: "-")[2]).components(separatedBy: " ")
                            dateComponent.day = Int(lastdateComponents[0])
                            dateComponent.hour = Int(lastdateComponents[1].components(separatedBy: ":")[0])
                            dateComponent.minute = Int(lastdateComponents[1].components(separatedBy: ":")[1])
                            dateComponent.second = Int(lastdateComponents[1].components(separatedBy: ":")[2])
                            print(dateComponent)
                            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                            center.add(request)
                        } else if index == 1 {
                            content.title = "Menstural Phase"
                            content.body = makeTitleString(index: selectedDayIndex) + " " + "Menstural phase"
                            content.sound = .default
                            content.userInfo = ["type": "Menstural"]
                            let strTempDate = CalendarUtil().convertDateToString(dateFormat: "yyyy-MM-dd HH:mm:ss", date: tempDate.addingTimeInterval(TimeInterval(stepper)))
                            print(strTempDate)
                            var dateComponent = DateComponents()
                            dateComponent.year = Int(strTempDate.components(separatedBy: "-")[0])
                            dateComponent.month = Int(strTempDate.components(separatedBy: "-")[1])
                            let lastdateComponents = (strTempDate.components(separatedBy: "-")[2]).components(separatedBy: " ")
                            dateComponent.day = Int(lastdateComponents[0])
                            dateComponent.hour = Int(lastdateComponents[1].components(separatedBy: ":")[0])
                            dateComponent.minute = Int(lastdateComponents[1].components(separatedBy: ":")[1])
                            dateComponent.second = Int(lastdateComponents[1].components(separatedBy: ":")[2])
                            print(dateComponent)
                            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                            center.add(request)
                        } else if index == 2 {
                            content.title = "Luteal Phase"
                            content.body = makeTitleString(index: selectedDayIndex) + " " + "Luteal phase"
                            content.sound = .default
                            content.userInfo = ["type": "Luteal"]
                            let strTempDate = CalendarUtil().convertDateToString(dateFormat: "yyyy-MM-dd HH:mm:ss", date: tempDate.addingTimeInterval(TimeInterval(stepper)))
                            print(strTempDate)
                            var dateComponent = DateComponents()
                            dateComponent.year = Int(strTempDate.components(separatedBy: "-")[0])
                            dateComponent.month = Int(strTempDate.components(separatedBy: "-")[1])
                            let lastdateComponents = (strTempDate.components(separatedBy: "-")[2]).components(separatedBy: " ")
                            dateComponent.day = Int(lastdateComponents[0])
                            dateComponent.hour = Int(lastdateComponents[1].components(separatedBy: ":")[0])
                            dateComponent.minute = Int(lastdateComponents[1].components(separatedBy: ":")[1])
                            dateComponent.second = Int(lastdateComponents[1].components(separatedBy: ":")[2])
                            print(dateComponent)
                            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                            center.add(request)
                        } else if index == 3 {
                            content.title = "Follicular Phase"
                            content.body = makeTitleString(index: selectedDayIndex) + " " + "Follicular phase"
                            content.sound = .default
                            content.userInfo = ["type": "Follicular"]
                            let strTempDate = CalendarUtil().convertDateToString(dateFormat: "yyyy-MM-dd HH:mm:ss", date: tempDate.addingTimeInterval(TimeInterval(stepper)))
                            print(strTempDate)
                            var dateComponent = DateComponents()
                            dateComponent.year = Int(strTempDate.components(separatedBy: "-")[0])
                            dateComponent.month = Int(strTempDate.components(separatedBy: "-")[1])
                            let lastdateComponents = (strTempDate.components(separatedBy: "-")[2]).components(separatedBy: " ")
                            dateComponent.day = Int(lastdateComponents[0])
                            dateComponent.hour = Int(lastdateComponents[1].components(separatedBy: ":")[0])
                            dateComponent.minute = Int(lastdateComponents[1].components(separatedBy: ":")[1])
                            dateComponent.second = Int(lastdateComponents[1].components(separatedBy: ":")[2])
                            print(dateComponent)
                            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                            center.add(request)
                        }
                    }
                }
            } else {
                AppUtil.onHideProgressView(self)
                AppUtil.showBanner(type: CRNotifications.error, title: .Failed, content: "Something went wrong")
            }
        }
    }
}

//MARK: - Calendar Picker VC Delegate
extension EditDateVC: CalendarPickerVCDelegate {
    
    func didSelectCell(data: CalendarModel) {
        dateTF.setValue(value: data.date)
    }
}

