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
    
    @IBAction func didTapBackUB(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapSaveUB(_ sender: UIButton) {
        AppUtil.onShowProgressView(self)
        let moodDate = CalendarUtil().convertStringToDate(dateFormat: "EEEE, dd MMMM, yyyy", date: dateTF.getValue())
        let strMood = CalendarUtil().convertDateToString(dateFormat: "yyyy-MM-dd", date: moodDate)
        FireUtil.instance.saveUserMoodDate(date: strMood) { (result) in
            if result {
                AppUtil.onHideProgressView(self)
                AppUtil.showBanner(type: CRNotifications.success, title: .Success, content: "Successed")
                APPUSER.mood = strMood
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

