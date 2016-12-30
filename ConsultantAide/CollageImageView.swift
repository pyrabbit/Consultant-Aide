//
//  CollagePreviewImageView.swift
//  ConsultantAide
//
//  Created by Matt Orahood on 8/7/16.
//  Copyright © 2016 Matt Orahood. All rights reserved.
//

import UIKit

class CollageImageView: UIImageView {
    
    private var snap: UISnapBehavior!
    private var animator: UIDynamicAnimator!
    private var containerView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame) 
        
        if let scale = UserDefaults.standard.value(forKey: "collageSize") as? CGFloat {
            contentScaleFactor = scale
        }
        
        // Allow user interaction
        isUserInteractionEnabled = true
        
        // Border around the collage preview
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        
        contentMode = UIViewContentMode.scaleAspectFill
        clipsToBounds = true
    }
    
    func movetoSavedPosition() {
        // Set default center position if applicable
        if let x = UserDefaults.standard.value(forKey: "defaultCollageXPosition") as? Float,
            let y = UserDefaults.standard.value(forKey: "defaultCollageYPosition") as? Float {
            
            let xPos = CGFloat(x)
            let yPos = CGFloat(y)
            
            if let container = containerView {
                if ((yPos + frame.height) > container.frame.maxY) {
                    frame.origin = CGPoint(x: 0, y: 0)
                    return
                }
            }
            
            frame.origin = CGPoint(x: xPos, y: yPos)
        }
    }
    
    func containWithin(view: UIView) {
        containerView = view
        animator = UIDynamicAnimator(referenceView: view)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let animator = self.animator {
            animator.removeAllBehaviors()
            
            for touch in touches {
                let location = touch.location(in: containerView)
                let snap = UISnapBehavior(item: self, snapTo: location)
                
                snap.damping = 1.0
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
            point = frame.origin
        }
        
        UserDefaults.standard.set(point.x, forKey: "defaultCollageXPosition")
        UserDefaults.standard.set(point.y, forKey: "defaultCollageYPosition")
    }
}
