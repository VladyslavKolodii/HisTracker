//
//  NotificationVC.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 12.11.2021.
//

import UIKit

class NotificationVC: UIViewController {
    
    @IBOutlet weak var threeDayUB: UIButton!
    @IBOutlet weak var twoDayUB: UIButton!
    @IBOutlet weak var oneDayUB: UIButton!
    @IBOutlet weak var zeroDayUB: UIButton!
    @IBOutlet weak var timeTF: IconTextField!
    
    var dayUBArr: [UIButton] = [UIButton]()
    
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
        
        handleDayUBArr(selectedIndex: 0)
        
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
        
    }
    
    @objc func didTapCancelUB() {
        self.view.endEditing(true)
    }
    
    @objc func didTapDoneUB() {
        let timeStr = CalendarUtil().convertDateToString(dateFormat: "hh:mm a", date: timePicker.date)
        timeTF.setValue(value: timeStr)
        self.view.endEditing(true)
    }
    
}
