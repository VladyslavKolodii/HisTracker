//
//  NotificationVC.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 12.11.2021.
//

import UIKit
import UserNotifications
import CRNotifications

class NotificationVC: UIViewController {
    
    @IBOutlet weak var threeDayUB: UIButton!
    @IBOutlet weak var twoDayUB: UIButton!
    @IBOutlet weak var oneDayUB: UIButton!
    @IBOutlet weak var zeroDayUB: UIButton!
    @IBOutlet weak var timeTF: IconTextField!
    @IBOutlet weak var ovulationUB: UIButton!
    @IBOutlet weak var menstrualUB: UIButton!
    @IBOutlet weak var lutealUB: UIButton!
    @IBOutlet weak var follicularUB: UIButton!
    
    var dayUBArr: [UIButton] = [UIButton]()
    var moodUBArr: [UIButton] = [UIButton]()
    
    var timePicker: UIDatePicker = {
        let picker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216))
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        return picker
    }()
    
    let toolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelUB))
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapDoneUB))
        toolbar.setItems([cancel, flexible, done], animated: false)
        return toolbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dayUBArr.append(threeDayUB)
        dayUBArr.append(twoDayUB)
        dayUBArr.append(oneDayUB)
        dayUBArr.append(zeroDayUB)
        
        moodUBArr.append(ovulationUB)
        moodUBArr.append(menstrualUB)
        moodUBArr.append(lutealUB)
        moodUBArr.append(follicularUB)
        
        handleDayUBArr(selectedIndex: UserDefaults.notificationDate)
        handleMoodUBArr(selectedIndex: UserDefaults.notificationType)
        
        self.timeTF.edtTF.inputAccessoryView = toolbar
        self.timeTF.edtTF.inputView = timePicker
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func handleDayUBArr(selectedIndex: Int) {
        for i in 0..<dayUBArr.count {
            if selectedIndex == i {
                dayUBArr[i].isSelected = true
                dayUBArr[i].tintColor = UIColor(named: "mainBlue")
            } else {
                dayUBArr[i].isSelected = false
                dayUBArr[i].tintColor = UIColor(named: "mainText")
            }
        }
    }
    
    func handleMoodUBArr(selectedIndex: [Int]) {
        for i in 0..<moodUBArr.count {
            if selectedIndex.contains(i) {
                moodUBArr[i].isSelected = true
                moodUBArr[i].tintColor = UIColor(named: "mainBlue")
            }
        }
    }
    
    @IBAction func didtapBackUB(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didtapJessicaUB(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.tintColor = UIColor(named: "mainBlue")
        } else {
            sender.tintColor = UIColor(named: "mainText")
        }
    }
    
    @IBAction func didTapDayUB(_ sender: UIButton) {
        handleDayUBArr(selectedIndex: sender.tag)
    }
    
    @IBAction func didTapSaveUB(_ sender: UIButton) {
        if timeTF.getValue().isEmpty {
            AppUtil.showBanner(type: CRNotifications.info, title: .Warning, content: "Time is required.")
        }
        var moodArr: [Int] = [Int]()
        for i in 0..<moodUBArr.count {
            if moodUBArr[i].isSelected {
                moodArr.append(i)
            } else {
                if moodArr.contains(i) {
                    moodArr.removeFirst(i)
                } else {
                    continue
                }
            }
        }
        UserDefaults.notificationType = moodArr

        if moodArr.isEmpty || UserDefaults.notificationType.isEmpty {
            AppUtil.showBanner(type: CRNotifications.info, title: .Warning, content: "Notifiy when Jessica is starting.")
            return
        }

        var selectedDayIndex: Int = 0
        let selectedDayUB = dayUBArr.filter { (dayUb) -> Bool in
            return dayUb.isSelected
        }
        selectedDayIndex = selectedDayUB[0].tag
        UserDefaults.notificationDate = selectedDayIndex
        let moodDate = CalendarUtil().convertStringToDate(dateFormat: "yyyy-MM-dd", date: APPUSER.mood)
        let strMoodDate = CalendarUtil().convertDateToString(dateFormat: "yyyy-MM-dd", date: moodDate)
        let moodTime = CalendarUtil().convertDateToString(dateFormat: "hh:mm a", date: timePicker.date)
        let strTotalDate = strMoodDate + " " + moodTime
        let totalDate = CalendarUtil().convertStringToDate(dateFormat: "yyyy-MM-dd hh:mm a", date: strTotalDate)
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapCancelUB() {
        self.view.endEditing(true)
    }
    
    @objc func didTapDoneUB() {
        let timeStr = CalendarUtil().convertDateToString(dateFormat: "hh:mm a", date: timePicker.date)
        timeTF.setValue(value: timeStr)
        self.view.endEditing(true)
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
    
}
