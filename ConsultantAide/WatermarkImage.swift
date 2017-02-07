//
//  WatermarkImage.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 11/9/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import UIKit

class WatermarkImage: UIImageView {
    var containerView: UIView!
    private var snap: UISnapBehavior!
    private var animator: UIDynamicAnimator!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setWatermarkStyle()
    }
    
    func containWithin(view: UIView) {
        containerView = view
        animator = UIDynamicAnimator(referenceView: view)
        isUserInteractionEnabled = true
    }
    
    func setWatermarkStyle() {
        if let transparency = UserDefaults.standard.object(forKey: "watermarkTransparency") as? Float {
            alpha = CGFloat(transparency)
        }
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("watermark.png").path
        
        if FileManager.default.fileExists(atPath: filePath) {
            if let watermark = UIImage(contentsOfFile: filePath) {
                image = watermark
            }
        }
        
        
        backgroundColor = .clear
        isOpaque = false
        sizeToFit()
    }
    
    func moveToSavedPosition() {
        guard let x = UserDefaults.standard.object(forKey: "defaultWatermarkImageX") as? Int else {
            return
        }
        
        guard let y = UserDefaults.standard.object(forKey: "defaultWatermarkImageY") as? Int else {
            return
        }
        
        if let container = containerView {
            if ((CGFloat(y) + frame.height) >= container.frame.height) {
                frame.origin = CGPoint(x: 0, y: 0)
                return
            }
        }
        frame.origin = CGPoint(x: x, y: y)
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
                
                let noRotationBehavior = UIDynamicItemBehavior(items: [self])
                noRotationBehavior.allowsRotation = false
                animator.addBehavior(noRotationBehavior)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var point = CGPoint(x: 0, y: 0)
        
        for _ in touches {
            point = frame.origin
        }
        
        UserDefaults.standard.set(point.x, forKey: "defaultWatermarkImageX")
        UserDefaults.standard.set(point.y, forKey: "defaultWatermarkImageY")
    }

}
