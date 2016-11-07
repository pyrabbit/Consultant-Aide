//
//  LabelContainerView.swift
//  ConsultantAide
//
//  Created by Matt Orahood on 10/1/16.
//  Copyright © 2016 Matt Orahood. All rights reserved.
//
import UIKit

class LabelContainerView: UIView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if subview.frame.contains(point) {
                return true
            }
        }
        return false
    }
    
}
