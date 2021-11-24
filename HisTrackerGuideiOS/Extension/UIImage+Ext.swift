//
//  UIImage+Ext.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 10.11.2021.
//

import Foundation
import UIKit

enum ImageAsset: String {
    case onboarding1, onboarding2, onboarding3
}

extension UIImage {
    
    class var onboarding1: Self {
        return self.init(named: ImageAsset.onboarding1.rawValue)!
    }
    
    class var onboarding2: Self {
        return self.init(named: ImageAsset.onboarding2.rawValue)!
    }
    
    class var onboarding3: Self {
        return self.init(named: ImageAsset.onboarding3.rawValue)!
    }
}
