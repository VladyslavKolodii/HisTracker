//
//  IconTextField.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 10.11.2021.
//

import UIKit

@IBDesignable class IconTextField: UIView {
    
    @IBOutlet var contentUV: UIView!
    @IBOutlet weak var containerUV: UIView!
    @IBOutlet weak var icLeading: UIImageView!
    @IBOutlet weak var icTrailing: UIImageView!
    @IBOutlet weak var edtTF: UITextField!
    
    @IBInspectable var iconLeading: UIImage = UIImage() {
        didSet {
            icLeading.image = iconLeading
        }
    }
    
    @IBInspectable var iconTrailing: UIImage? {
        didSet {
            if let icon = iconTrailing {
                icTrailing.image = icon
            } else {
                icTrailing.isHidden = true
            }
        }
    }
    
    @IBInspectable var placeholder: String = "" {
        didSet {
            self.edtTF.placeholder = placeholder
        }
    }
    
    @IBInspectable var isSecure: Bool = false {
        didSet {
            self.edtTF.isSecureTextEntry = isSecure
        }
    }
    
    @IBInspectable var editable: Bool = true {
        didSet {
            self.edtTF.isEnabled = editable
        }
    }
    
    @IBInspectable var keyboardType: UIKeyboardType = .default {
        didSet {
            self.edtTF.keyboardType = keyboardType
        }
    }
    
    @IBInspectable var alignment: NSTextAlignment = .left {
        didSet {
            self.edtTF.textAlignment = alignment
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUPXIB()
        setUP()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUPXIB()
        setUP()
    }
    
    func setUPXIB() {
        Bundle.main.loadNibNamed("IconTextField", owner: self, options: nil)
        addSubview(contentUV)
        contentUV.frame = self.bounds
        contentUV.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setUP() {
        self.containerUV.layer.cornerRadius = 12.0
        self.containerUV.layer.borderWidth = 1.0
        self.containerUV.layer.borderColor = UIColor(named: "borderColor")?.cgColor
    }
    
    func getValue() -> String {
        return self.edtTF.text!
    }
    
    func setValue(value: String) {
        self.edtTF.text = value
    }
    
}
