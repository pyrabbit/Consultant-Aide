//
//  RoundedButton.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 2/11/17.
//  Copyright © 2017 Matthew Orahood. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
}
