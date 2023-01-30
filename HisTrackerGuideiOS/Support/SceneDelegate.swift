//
//  SceneDelegate.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 9.11.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        FireUtil.instance.getLandingData { [self] (titleArr, detailArr, statusArr) in
            FIRECONFIGSTATUS = statusArr
            if UserDefaults.isPassedLanding {
                if UserDefaults.isLoggedIn {
                    let vc = MainNavVC.instantiatFromAppStoryboard(appStoryboard: .Main)
                    window?.rootViewController = vc
                    window?.makeKeyAndVisible()
                } else {
                    let vc = AuthNavVC.instantiatFromAppStoryboard(appStoryboard: .Auth)
                    window?.rootViewController = vc
                    window?.makeKeyAndVisible()
                }
            } else {
                if titleArr.count != 0 {
                    LANDINGMODELS = [
                        OnboardingModel(title: titleArr[0], subTitle: detailArr[0], image: UIImage.onboarding1),
                        OnboardingModel(title: titleArr[1], subTitle: detailArr[1], image: UIImage.onboarding2),
                        OnboardingModel(title: titleArr[2], subTitle: detailArr[2], image: UIImage.onboarding3),
                    ]
                    
                } else {
                    LANDINGMODELS = [
                        OnboardingModel(title: "", subTitle: "", image: UIImage.onboarding1),
                        OnboardingModel(title: "", subTitle: "", image: UIImage.onboarding2),
                        OnboardingModel(title: "", subTitle: "", image: UIImage.onboarding3),
                    ]
                }
                let vc = LandingVC.instantiatFromAppStoryboard(appStoryboard: .Landing)
                window?.rootViewController = UINavigationController(rootViewController: vc)
                window?.makeKeyAndVisible()
            }
        }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
}

