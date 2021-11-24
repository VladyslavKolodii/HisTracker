//
//  CalendarCell.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 11.11.2021.
//

import UIKit

class CalendarCell: UICollectionViewCell {

    @IBOutlet weak var firstDecoUV: UIView!
    @IBOutlet weak var secondDecoUV: UIView!
    @IBOutlet weak var dateLB: UILabel!
    
    var item: CalendarModel! {
        didSet {
            dateLB.text = item.title
            if !item.isInCurrentMonth {
                dateLB.textColor = UIColor(named: "mainText_50")
            } else {
                if item.isSelected {
                    dateLB.textColor = .white
                } else {
                    dateLB.textColor = UIColor(named: "mainBlack")
                }
            }
            firstDecoUV.isHidden = !item.isSelected
            secondDecoUV.isHidden = !item.isSelected
        }
    }
}
