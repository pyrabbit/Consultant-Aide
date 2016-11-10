//
//  WatermarkLabel.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 11/9/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import UIKit

class WatermarkLabel: UILabel {
    
    var containerView: UIView!
    private var snap: UISnapBehavior!
    private var animator: UIDynamicAnimator!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setWatermarkStyle()
        
        layer.cornerRadius = 5
        clipsToBounds = true
        textAlignment = .center
    }
    
    func containWithin(view: UIView) {
        containerView = view
        animator = UIDynamicAnimator(referenceView: view)
        isUserInteractionEnabled = true
    }
    
    func reset() {
        setWatermarkStyle()
    }
    
    func setWatermarkStyle() {
        if let color = UserDefaults.standard.colorForKey(key: "secondary") {
            layer.backgroundColor = color.cgColor
        } else {
            layer.backgroundColor = ColorPalette.Accent.cgColor
        }
        
        if let color = UserDefaults.standard.colorForKey(key: "secondaryFont") {
            textColor = color
        } else {
            textColor = .white
        }
        
        var fontSize: CGFloat = 18.0
        
        if let size = UserDefaults.standard.value(forKey: "watermarkFontSize") as? Float {
            fontSize = CGFloat(size)
        }
        
        if let fontFamily = UserDefaults.standard.object(forKey: "defaultFont") as? String {
            let newFont = UIFont(name: fontFamily, size: fontSize)
            font = newFont
        } else {
            let newFont = UIFont(name: "Gill Sans", size: fontSize)
            font = newFont
        }
        
        if let x = UserDefaults.standard.object(forKey: "defaultWatermarkTextXCenter") as? Int,
            let y = UserDefaults.standard.object(forKey: "defaultWatermarkTextYCenter") as? Int {
            center = CGPoint(x: x, y: y)
        } else {
            center = CGPoint(x: 150, y: 150)
        }
        
        if let transparency = UserDefaults.standard.object(forKey: "watermarkTransparency") as? Float {
            alpha = CGFloat(transparency)
        }
        
        if let savedText = UserDefaults.standard.value(forKey: "watermarkText") as? String {
            text = savedText
            sizeToFit()
            frame.size.height += 5
            frame.size.width += 5
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let animator = self.animator {
            animator.removeAllBehaviors()
            
            for touch in touches {
                let location = touch.location(in: containerView)
                let snap = UISnapBehavior(item: self, snapTo: location)
                             snap.damping = 0.2
                animator.addBehavior(snap)
                
                let boundry = UICollisionBehavior(items: [self])
                boundry.translatesReferenceBoundsIntoBoundary = true
                animator.addBehavior(boundry)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var point = CGPoint(x: 0, y: 0)
        
        for _ in touches {
            point = center
        }
        
        UserDefaults.standard.set(point.y, forKey: "defaultWatermarkTextYCenter")
        UserDefaults.standard.set(point.x, forKey: "defaultWatermarkTextXCenter")
    }
}
