//
//  FireUtil.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 13.11.2021.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase

class FireUtil {
    
    static let instance = FireUtil()
    
    let fireStoreRef = Firestore.firestore()
    
    func getLandingData(completion: @escaping ([String], [String], [String]) -> Void) {
        fireStoreRef.collection("config").document("landing").getDocument { (snapshot, error) in
            if error != nil {
                completion([], [], [])
            } else {
                if let data = snapshot?.data() {
                    let titleArr: [String] = data["title"] as! [String]
                    let detailArr: [String] = data["detail"] as! [String]
                    let statusArr: [String] = data["status"] as! [String]
                    completion(titleArr, detailArr, statusArr)
                } else {
                    completion([], [], [])
                }
                
            }
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let user = result?.user {
                APPUSER.userID = user.uid
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                completion(false)
            } else {
                if let user = result?.user {
                    APPUSER.userID = user.uid
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func loginWithGoogle(vc: UIViewController, completion: @escaping (Bool) -> Void) {
//        guard let clientID = FirebaseApp.app()?.options.clientID else {return}
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.signIn(with: config, presenting: vc) { (user, error) in
//            if error != nil {
//                completion(false)
//                return
//            }
//            guard let authentication = user?.authentication, let idToken = authentication.idToken else {return}
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
//            Auth.auth().signIn(with: credential) { (result, err) in
//                if err != nil {
//                    completion(false)
//                    return
//                } else {
//                    let user: GIDGoogleUser = GIDSignIn.sharedInstance.currentUser!
//                    APPUSER.email = user.profile?.email ?? ""
//                    APPUSER.name = user.profile?.name ?? ""
//                    APPUSER.userID = result!.user.uid
//                    completion(true)
//                }
//            }
//        }
    }
    
    func saveUserInfo(user: UserModel, completion: @escaping (Bool) -> Void) {
        fireStoreRef.collection("users").document(user.userID).setData(user.toFireStore()) { (error) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func getUserInfo(completion: @escaping (UserModel, Bool) -> Void) {
        fireStoreRef.collection("users").document(Auth.auth().currentUser!.uid).getDocument { (document, error) in
            if  error != nil {
                let userModel = UserModel()
                completion(userModel, false)
            } else {
                let data: [String: Any] = (document?.data())!
                let userModel = UserModel()
                userModel.initFromFireStore(snapShot: data)
                completion(userModel, true)
            }
        }
    }
    
    func saveUserMoodDate(date: String, completion: @escaping (Bool) -> Void) {
        fireStoreRef.collection("users").document(APPUSER.userID).updateData(["mood": date]) { (err) in
            if err != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func saveUserStatus(value: [String: Any], completion: @escaping((Bool) -> Void )) {
        let userID = Auth.auth().currentUser?.uid
        let curDate = CalendarUtil().convertDateToString(dateFormat: "yyyy-MM-dd hh:mm:ss", date: Date())
        let data: [String: Any] = [curDate: value]
        fireStoreRef.collection("status").document(userID!).setData(data, merge: true) { (error) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func getArticles(completion: @escaping([CarouselModel]) -> Void) {
        fireStoreRef.collection("articles").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error happened. \(err)")
            } else {
                var carousels: [CarouselModel] = [CarouselModel]()
                for item in snapshot!.documents {
                    let data: [String: Any] = item.data()
                    let carousel: CarouselModel = CarouselModel(data: data)
                    carousels.append(carousel)
                }
                completion(carousels)
            }
        }
    }
}
