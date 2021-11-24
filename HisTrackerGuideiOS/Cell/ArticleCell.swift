//
//  ArticleCell.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 11.11.2021.
//

import UIKit

class ArticleCell: UICollectionViewCell {
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var decoUV: UIView!
    @IBOutlet weak var markUV: UIView!
    @IBOutlet weak var markStatusUV: UIView!
    @IBOutlet weak var checkUIMG: UIImageView!
    
    var model: CarouselModel! {
        didSet {
            userImg.image = model.image
            checkUIMG.isHidden = !model.isRead
            if model.isRead {
                markUV.backgroundColor = UIColor(named: "mainBlue")
                markStatusUV.layer.borderWidth = 0.0
                markStatusUV.backgroundColor = UIColor(named: "darkBlue")
            } else {
                markUV.backgroundColor = UIColor(named: "mainBlue_20")
                markStatusUV.layer.borderWidth = 1.0
                markStatusUV.layer.borderColor = UIColor(named: "darkBlue")?.cgColor
                markStatusUV.backgroundColor = .clear
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let gradientUV = UIView(frame: CGRect(x: 0, y: 0, width: self.decoUV.frame.width, height: self.decoUV.frame.height))
        let gradient = CAGradientLayer()
        gradient.frame = gradientUV.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor(named: "blackGradientStart")!.cgColor]
        self.decoUV.layer.insertSublayer(gradient, at: 0)
    }

}
