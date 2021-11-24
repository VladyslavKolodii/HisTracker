//
//  CarouselModel.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 11.11.2021.
//

import Foundation
import UIKit

class CarouselModel {
        
    var image: UIImage
    var title: String = "The impact of menstrual symptoms on everyday life"
    var name: String = "By Jone Doe"
    var isRead: Bool
    
    init(image: UIImage, isRead: Bool) {
        self.image = image
        self.isRead = isRead
    }
}
