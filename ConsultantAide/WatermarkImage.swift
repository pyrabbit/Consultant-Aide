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

    }
    
    func reset() {
        setWatermarkStyle()
    }
    
    func containWithin(view: UIView) {
        containerView = view
        animator = UIDynamicAnimator(referenceView: view)
        isUserInteractionEnabled = true
    }
    
    func setWatermarkStyle() {
        if let x = UserDefaults.standard.object(forKey: "defaultWatermarkImageXCenter") as? Int,
            let y = UserDefaults.standard.object(forKey: "defaultWatermarkImageYCenter") as? Int {
            center = CGPoint(x: x, y: y)
        } else {
            center = CGPoint(x: 150, y: 150)
        }
        
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
        
        UserDefaults.standard.set(point.y, forKey: "defaultWatermarkImageYCenter")
        UserDefaults.standard.set(point.x, forKey: "defaultWatermarkImageXCenter")
    }

}
