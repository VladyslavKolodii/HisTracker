//
//  UIViewController+Ext.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 9.11.2021.
//

import Foundation
import UIKit

enum AppStoryboard: String {
    case Landing, Auth, Main
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewControllerCalss: T.Type) -> T {
        let storyboardID = (viewControllerCalss as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
    
    func intialViewControler() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    class var storyboardID: String {
        return "\(self)"
    }
    
    static func instantiatFromAppStoryboard(appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerCalss: self)
    }
}

extension UIViewController {
    func popToTargetVC<T: UIViewController>(target: T.Type) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: T.self) {
                self.navigationController?.popToViewController(controller, animated: true)
            }
            break
        }
    }
}
