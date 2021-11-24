//
//  CalendarMoodCell.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 13.11.2021.
//

import UIKit

class CalendarMoodCell: UICollectionViewCell {
    
    
    @IBOutlet weak var backDecoUV: UIView!
    @IBOutlet weak var lightBlueUV: UIView!
    @IBOutlet weak var mainBlueUB: UIView!
    @IBOutlet weak var dayLB: UILabel!
    
    var model: MoodCalendarModel!
    var indexNum: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCell(model: model, index: indexNum)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dayLB.text = ""
        backDecoUV.backgroundColor = .white
        backDecoUV.layer.cornerRadius = 0.0
        mainBlueUB.isHidden = true
        lightBlueUV.isHidden = true
    }
    
    func configureCell(model: MoodCalendarModel, index: Int) {
        dayLB.text = model.calendarModel.title
        
        switch model.moodType {
        case .NONE:
            backDecoUV.backgroundColor = .white
            if model.calendarModel.isSelected {
                dayLB.textColor = .white
            } else {
                if model.calendarModel.isInCurrentMonth {
                    dayLB.textColor = UIColor(named: "mainBlack")
                } else {
                    dayLB.textColor = UIColor(named: "mainText_50")
                }
            }
            break
        case .MENSTURATION:
            if model.calendarModel.isSelected {
                dayLB.textColor = .white
            } else {
                if model.calendarModel.isInCurrentMonth {
                    dayLB.textColor = UIColor(named: "mainRed")
                } else {
                    dayLB.textColor = UIColor(named: "redGradientStart")
                }
            }
            backDecoUV.backgroundColor = UIColor(named: "redGradientStep")
            break
        case .OVULATION:
            if model.calendarModel.isSelected {
                dayLB.textColor = .white
            } else {
                if model.calendarModel.isInCurrentMonth {
                    dayLB.textColor = UIColor(named: "mainYellow")
                } else {
                    dayLB.textColor = UIColor(named: "yellowGradientStart")
                }
            }
            backDecoUV.backgroundColor = UIColor(named: "yellowGradientStep")
            break
        }

        switch model.startEnd {
        case .START:
            backDecoUV.layer.cornerRadius = backDecoUV.frame.height / 2
            if index % 7 == 6 {
                backDecoUV.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            } else {
                backDecoUV.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            }
            break
        case .END:
            backDecoUV.layer.cornerRadius = backDecoUV.frame.height / 2
            if index % 7 == 0 {
                backDecoUV.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            } else {
                backDecoUV.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            }
            break
        case .NORMAL:
            if index % 7 == 6 {
                backDecoUV.layer.cornerRadius = backDecoUV.frame.height / 2
                backDecoUV.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            }            
            if index % 7 == 0 {
                backDecoUV.layer.cornerRadius = backDecoUV.frame.height / 2
                backDecoUV.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            }
            break
        }

        lightBlueUV.layer.cornerRadius = lightBlueUV.frame.height / 2.0
        mainBlueUB.layer.cornerRadius = mainBlueUB.frame.height / 2.0

        
        
        if model.calendarModel.isSelected {
            lightBlueUV.isHidden = false
            mainBlueUB.isHidden = false
            dayLB.textColor = .white
        } else {
            lightBlueUV.isHidden = true
            mainBlueUB.isHidden = true
        }
        layoutIfNeeded()
    }

}
