//
//  PredictionCell.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 12.11.2021.
//

import UIKit

class PredictionCell: UITableViewCell {

    @IBOutlet weak var decoUV: UIView!
    @IBOutlet weak var stackUV: UIStackView!
    
    var moodType: MoodType!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stackUV.arrangedSubviews.forEach { (view) in
            view.removeFromSuperview()
        }
        decoUV.layer.sublayers?.forEach({ (layer) in
            layer.removeFromSuperlayer()
        })
        moodType = .none
        contentView.subviews.forEach { (view) in
            if view.isKind(of: UILabel.self) {
                view.removeFromSuperview()
            }
        }
    }
    
    func configurCell(model: PredictionModel) {
        moodType = model.moodType
        model.dates.forEach { (date) in
            let day = Calendar.current.component(.day, from: date)
            let containerUV = UIView()
            containerUV.backgroundColor = .clear
            containerUV.translatesAutoresizingMaskIntoConstraints = false
            
            let line = UIView()
            line.backgroundColor = day == CalendarUtil().daysInMonth(date: date) ? .clear : UIColor(named: "mainText")
            line.translatesAutoresizingMaskIntoConstraints = false
            
            let line1 = UIView()
            line1.backgroundColor = day == 1 ? .clear : UIColor(named: "mainText")
            line1.translatesAutoresizingMaskIntoConstraints = false
            
            let colorCircle = UIView()
            colorCircle.translatesAutoresizingMaskIntoConstraints = false
            colorCircle.layer.cornerRadius = 8.0
            
            let whiteCircle = UIView()
            whiteCircle.translatesAutoresizingMaskIntoConstraints = false
            whiteCircle.layer.cornerRadius = 4.0
            whiteCircle.backgroundColor = .white
            
            let dateLB = UILabel()
            dateLB.translatesAutoresizingMaskIntoConstraints = false
            dateLB.font = UIFont(name: "Montserrat-Medium", size: 14.0)
            
            containerUV.addSubview(dateLB)
            containerUV.addSubview(colorCircle)
            containerUV.addSubview(line)
            containerUV.addSubview(line1)
            containerUV.addSubview(whiteCircle)
            
            colorCircle.leadingAnchor.constraint(equalTo: containerUV.leadingAnchor, constant: 32.0).isActive = true
            colorCircle.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
            colorCircle.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
            
            whiteCircle.centerYAnchor.constraint(equalTo: colorCircle.centerYAnchor).isActive = true
            whiteCircle.centerXAnchor.constraint(equalTo: colorCircle.centerXAnchor).isActive = true
            whiteCircle.widthAnchor.constraint(equalToConstant: 8.0).isActive = true
            whiteCircle.heightAnchor.constraint(equalToConstant: 8.0).isActive = true
            
            line1.widthAnchor.constraint(equalToConstant: 1.0).isActive = true
            line1.heightAnchor.constraint(equalToConstant: 12.0).isActive = true
            line1.bottomAnchor.constraint(equalTo: colorCircle.topAnchor).isActive = true
            line1.centerXAnchor.constraint(equalTo: colorCircle.centerXAnchor).isActive = true
            line1.topAnchor.constraint(equalTo: containerUV.topAnchor).isActive = true
            
            line.widthAnchor.constraint(equalToConstant: 1.0).isActive = true
            line.heightAnchor.constraint(equalToConstant: 12.0).isActive = true
            line.topAnchor.constraint(equalTo: colorCircle.bottomAnchor).isActive = true
            line.centerXAnchor.constraint(equalTo: colorCircle.centerXAnchor).isActive = true
            line.bottomAnchor.constraint(equalTo: containerUV.bottomAnchor).isActive = true
            
            dateLB.centerYAnchor.constraint(equalTo: colorCircle.centerYAnchor).isActive = true
            dateLB.leftAnchor.constraint(equalTo: colorCircle.rightAnchor, constant: 12).isActive = true
            dateLB.text = CalendarUtil().convertDateToString(dateFormat: "d MMM, yyyy", date: date)
            
            if moodType == MoodType.NONE {
                colorCircle.backgroundColor = UIColor(named: "mainSky")
                dateLB.textColor = UIColor(named: "mainText")
            } else if moodType == MoodType.MENSTURATION {
                colorCircle.backgroundColor = UIColor(named: "mainRed")
                dateLB.textColor = UIColor(named: "mainBlack")
            } else {
                colorCircle.backgroundColor = UIColor(named: "mainYellow")
                dateLB.textColor = UIColor(named: "mainBlack")
            }
            stackUV.addArrangedSubview(containerUV)
        }
        
        var gradientColor: [CGColor] = [CGColor]()
        var fontColor: UIColor = .white
        var letterSpcaing: CGFloat = 0.0
        switch moodType {
        case .MENSTURATION:
            gradientColor.append(UIColor(named: "redGradientStep")!.cgColor)
            gradientColor.append(UIColor(named: "redGradientStart")!.cgColor)
            gradientColor.append(UIColor(named: "redGradientStep")!.cgColor)
            fontColor = UIColor(named: "mainRed")!
            letterSpcaing = 4.0
        case .OVULATION:
            gradientColor.append(UIColor(named: "yellowGradientStep")!.cgColor)
            gradientColor.append(UIColor(named: "yellowGradientStart")!.cgColor)
            gradientColor.append(UIColor(named: "yellowGradientStep")!.cgColor)
            fontColor = UIColor(named: "mainYellow")!
            letterSpcaing = 5.0
        case .NONE:
            gradientColor.append(UIColor.white.cgColor)
            gradientColor.append(UIColor.white.cgColor)
            gradientColor.append(UIColor.white.cgColor)
        default:
            gradientColor.append(UIColor.white.cgColor)
            gradientColor.append(UIColor.white.cgColor)
            gradientColor.append(UIColor.white.cgColor)
        }
        let gradientUV = UIView(frame: CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height))
        let gradient = CAGradientLayer()
        gradient.frame = gradientUV.bounds
        gradient.colors = gradientColor
        self.decoUV.layer.insertSublayer(gradient, at: 0)
        
        let descLB = UILabel(frame: CGRect(x: contentView.frame.width - contentView.frame.height - 50, y: 0, width: contentView.frame.height, height: 50))
        descLB.textAlignment = .center
        if model.dates.count < 5 {
            descLB.text = ""
        } else {
            descLB.text = moodType.description
            descLB.setLetterSpacint(letterSpcaing, "Montserrat-Bold", 16)
        }
        descLB.textColor = fontColor
        contentView.addSubview(descLB)
        
        descLB.setAnchorPoint(anchorPoint: CGPoint(x: 1.0, y: 0.0))
        descLB.transform = descLB.transform.rotated(by: -(.pi / 2))
    }
    
}

