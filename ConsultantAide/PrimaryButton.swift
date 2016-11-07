//
//  RoundedButton.swift
//  ConsultantAide
//
//  Created by Matt Orahood on 9/7/16.
//  Copyright © 2016 Matt Orahood. All rights reserved.
//
import UIKit

@IBDesignable
class PrimaryButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        self.setTitleColor(ColorPalette.Primary, for: .normal)
    }
}
