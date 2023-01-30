//
//  CarouselModel.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 11.11.2021.
//

import Foundation
import UIKit

class CarouselModel {
        
    var image: UIImage = UIImage(named: "sample_woman_11")!
    var title: String = "The impact of menstrual symptoms on everyday life"
    var name: String = "By Jone Doe"
    var isRead: Bool = false
    var imageUrl: String = ""
    var description: String = ""
    var tag: [String] = [String]()
    var day: String = "Day 1"
    var type: String = "Her body"
    
    init(image: UIImage, isRead: Bool) {
        self.image = image
        self.isRead = isRead
    }
    
    init(data: [String: Any]) {
        imageUrl = data["imageUrl"] as! String
        description = data["description"] as! String
        title = data["title"] as! String
        tag = data["tag"] as! [String]
        type = data["type"] as! String
    }
}
