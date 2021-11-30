//
//  LoginVC.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 10.11.2021.
//

import UIKit
import CRNotifications

class LoginVC: UIViewController {

    @IBOutlet weak var emailTF: IconTextField!
    @IBOutlet weak var passwordTF: IconTextField!
    @IBOutlet weak var signInUB: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.keyboardType = .emailAddress
        passwordTF.keyboardType = .default

        signInUB.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSignInUB)))
    }
    

    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueNames.goSposeFromLogin.rawValue {
            let vc = segue.destination as! SpouseVC
            vc.user = sender as? UserModel
        }
    }
    
    @IBAction func didTapForgotUB(_ sender: UIButton) {
        
    }
    
    func onLogin() {
        AppUtil.onShowProgressView(self)
        FireUtil.instance.loginUser(email: emailTF.getValue(), password: passwordTF.getValue()) { [self] (result) in
            if result {
                AppUtil.onHideProgressView(self)
                AppUtil.showBanner(type: CRNotifications.success, title: .Success, content: "Successed.")
                if UserDefaults.isCompleteSpouse {
                    UserDefaults.isLoggedIn = true
                    goMainScreen()
                } else {
                    APPUSER.email = emailTF.getValue()
                    APPUSER.name = UserDefaults.userName
                    goSpouseScreen()
                }
                
            } else {
                AppUtil.onHideProgressView(self)
                AppUtil.showBanner(type: CRNotifications.error, title: .Failed, content: "Something went wrong")
            }
        }
    }
    
    @objc func didTapSignInUB() {
        if emailTF.getValue().isEmpty {
            AppUtil.showBanner(type: CRNotifications.info, title: .Warning, content: "Email is empty")
            return
        }
        if !emailTF.getValue().isValidEmail() {
            AppUtil.showBanner(type: CRNotifications.info, title: .Warning, content: "Email is not valid type")
            return
        }
        if passwordTF.getValue().isEmpty {
            AppUtil.showBanner(type: CRNotifications.info, title: .Warning, content: "Password is empty")
            return
        }
        if passwordTF.getValue().count < 6 {
            AppUtil.showBanner(type: CRNotifications.info, title: .Warning, content: "Password length must be greater than 6")
            return
        }
        onLogin()
    }
    
    func goMainScreen() {
        self.performSegue(withIdentifier: SegueNames.goMainFromLogin.rawValue, sender: nil)
    }
    
    func goSpouseScreen() {
        self.performSegue(withIdentifier: SegueNames.goSposeFromLogin.rawValue, sender: APPUSER)
    }
}
