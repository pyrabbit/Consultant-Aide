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
        
        // Set default center position if applicable
        if let x = UserDefaults.standard.value(forKey: "defaultCollageXPosition") as? Float,
            let y = UserDefaults.standard.value(forKey: "defaultCollageYPosition") as? Float {
            
            let xPos = CGFloat(x)
            let yPos = CGFloat(y)
            
            center = CGPoint(x: xPos, y: yPos)
        }
        
        // Allow user interaction
        isUserInteractionEnabled = true
        
        // Border around the collage preview
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        
        contentMode = UIViewContentMode.scaleAspectFill
        clipsToBounds = true
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
        for touch in touches {
            let location = touch.location(in: containerView)
            UserDefaults.standard.set(location.x, forKey: "defaultCollageXPosition")
            UserDefaults.standard.set(location.y, forKey: "defaultCollageYPosition")
        }
    }
    
    //    private var _tempScale : CGFloat = 1.0
    //    private let _maxScale : CGFloat = 4.0
    //    private let _minScale : CGFloat = 1.0
    
    //    func wasPinched(recognizer: UIPinchGestureRecognizer) {
    //        switch recognizer.state {
    //        case .began, .changed:
    //
    //            let currentLayerScale : CGFloat = self.layer.value(forKeyPath: "transform.scale") as! CGFloat
    //            var scale : CGFloat = 1 - (_tempScale - recognizer.scale)
    //            scale = min(_maxScale / currentLayerScale, scale)
    //            scale = max(_minScale / currentLayerScale, scale)
    //
    //            self.transform = self.transform.scaledBy(x: scale, y: scale)
    //            _tempScale = recognizer.scale
    //
    //
    //        case .ended:
    //            _tempScale = 1.0
    //        default:
    //            break
    //        }
    //    }
}
