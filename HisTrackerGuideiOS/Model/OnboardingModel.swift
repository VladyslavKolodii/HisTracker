//
//  OnboardingModel.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 10.11.2021.
//

import Foundation
import UIKit

struct OnboardingModel {
    var title: String
    var subTitle: String
    var image: UIImage
    
    init(title: String, subTitle: String, image: UIImage) {
        self.title = title
        self.subTitle = subTitle
        self.image = image
    }
    
}
