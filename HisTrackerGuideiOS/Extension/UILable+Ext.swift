//
//  UILable+Ext.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 12.11.2021.
//

import Foundation
import UIKit

extension UILabel {
    func setLetterSpacint(_ spacing: CGFloat, _ fontName: String, _ fontSize: CGFloat) {
        let attributedStr = NSMutableAttributedString(string: self.text ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: fontName, size: fontSize)!])
        attributedStr.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, attributedStr.length))
        self.attributedText = attributedStr
    }
}

