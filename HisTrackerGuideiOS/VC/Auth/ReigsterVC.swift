//
//  ReigsterVC.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 10.11.2021.
//

import UIKit
import CRNotifications

class ReigsterVC: UIViewController {
    
    @IBOutlet weak var nameTF: IconTextField!
    @IBOutlet weak var emailTF: IconTextField!
    @IBOutlet weak var passwordTF: IconTextField!
    @IBOutlet weak var confirmTF: IconTextField!
    @IBOutlet weak var signUpUB: UIView!
    @IBOutlet weak var googleUB: UIView!
    @IBOutlet weak var facebookUB: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTF.keyboardType = .default
        emailTF.keyboardType = .emailAddress
        passwordTF.keyboardType = .default
        confirmTF.keyboardType = .default

        signUpUB.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSignUpUB)))
        googleUB.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapGoogleUB)))
        facebookUB.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFacebookUB)))
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueNames.goSpouse.rawValue {
            let vc = segue.destination as! SpouseVC
            vc.user = sender as? UserModel
        }
    }
        
    @IBAction func didTapBackUB() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapSignUpUB() {
        if nameTF.getValue().isEmpty {
            AppUtil.showBanner(type: CRNotifications.info, title: .Warning, content: "Name is Empty")
            return
        }
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
        if passwordTF.getValue() != confirmTF.getValue() {
            AppUtil.showBanner(type: CRNotifications.info, title: .Warning, content: "Check password again")
            return
        }
        UserDefaults.userName = nameTF.getValue()
        APPUSER.name = nameTF.getValue()
        APPUSER.email = emailTF.getValue()
        AppUtil.onShowProgressView(self)
        FireUtil.instance.registerUser(email: APPUSER.email, password: passwordTF.getValue()) { [self] (result) in
            if result {
                AppUtil.onHideProgressView(self)
                AppUtil.showBanner(type: CRNotifications.success, title: .Success, content: "Successed.")
                goSpouserScreen()
            } else {
                AppUtil.onHideProgressView(self)
                AppUtil.showBanner(type: CRNotifications.error, title: .Failed, content: "Something went wrong")
            }
        }
        
    }
    
    @objc func didTapGoogleUB() {
        FireUtil.instance.loginWithGoogle(vc: self) { [self] (result) in
            if result {
                if UserDefaults.isCompleteSpouse {
                    UserDefaults.isLoggedIn = true
                    goMainScreen()
                } else {
                    goSpouserScreen()
                }
            } else {
                AppUtil.showBanner(type: CRNotifications.error, title: .Failed, content: "Something went wrong")
            }
        }
    }
    
    @objc func didTapFacebookUB() {
        goSpouserScreen()
    }
    
    func goSpouserScreen() {
        self.performSegue(withIdentifier: SegueNames.goSpouse.rawValue, sender: APPUSER)
    }
    
    func goMainScreen() {
        self.performSegue(withIdentifier: SegueNames.goMainFromRegister.rawValue, sender: nil)
    }

}
