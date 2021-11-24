//
//  SpouseVC.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 10.11.2021.
//

import UIKit
import CRNotifications

class SpouseVC: UIViewController {

    @IBOutlet weak var nameTF: IconTextField!
    @IBOutlet weak var calendarTF: IconTextField!
    @IBOutlet weak var dateTF: IconTextField!
    @IBOutlet weak var continueUB: UIView!
    
    var user: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTF.keyboardType = .default
        dateTF.keyboardType = .numberPad
        dateTF.setValue(value: "28")
        
        calendarTF.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCalenderTF)))
        continueUB.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapContinueUB)))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func didTapStartDateUB(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapBackUB(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapCalenderTF() {
        let vc = CalendarPickerVC.instantiatFromAppStoryboard(appStoryboard: .Auth)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func didTapContinueUB() {
        if nameTF.getValue().isEmpty {
            AppUtil.showBanner(type: CRNotifications.info, title: .Warning, content: "Name is Empty")
            return
        }
        if calendarTF.getValue().isEmpty {
            AppUtil.showBanner(type: CRNotifications.info, title: .Warning, content: "Mood date is Empty")
            return
        }
        if dateTF.getValue().isEmpty {
            AppUtil.showBanner(type: CRNotifications.info, title: .Warning, content: "Mood period is Empty")
            return
        }
        APPUSER.wifename = nameTF.getValue()
        let moodDate = CalendarUtil().convertStringToDate(dateFormat: "EEEE, dd MMMM, yyyy", date: calendarTF.getValue())
        APPUSER.mood = CalendarUtil().convertDateToString(dateFormat: "yyyy-MM-dd", date: moodDate)
        APPUSER.period = Int(dateTF.getValue())!
        onRegister()
    }
    
    func onRegister() {
        AppUtil.onShowProgressView(self)
        FireUtil.instance.saveUserInfo(user: APPUSER) { (success) in
            if success {
                AppUtil.onHideProgressView(self)
                UserDefaults.isCompleteSpouse = true
                AppUtil.showBanner(type: CRNotifications.success, title: .Success, content: "Successed.")
//                self.popToTargetVC(target: LoginVC.self)
                UserDefaults.isLoggedIn = true
                self.performSegue(withIdentifier: SegueNames.goMainRegisterCompletion.rawValue, sender: nil)
            } else {
                AppUtil.onHideProgressView(self)
                AppUtil.showBanner(type: CRNotifications.error, title: .Failed, content: "Something went wrong")
            }
        }
    }
}

//MARK: - Calendar Picker VC Delegate
extension SpouseVC: CalendarPickerVCDelegate {
    
    func didSelectCell(data: CalendarModel) {
        calendarTF.setValue(value: data.date)
    }
}
