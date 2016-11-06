//
//  UIStyleLabel.swift
//  ConsultantAide
//
//  Created by Matt Orahood on 9/27/16.
//  Copyright © 2016 Matt Orahood. All rights reserved.
//
import UIKit

class StyleView: UIView {
    
    var primaryLabel: UILabel!
    var priceLabel: UILabel?
    var sizeContainer: UIView?
    
    var price: String!
    var style: String!
    var sizes: Set<String>!
    
    var defaultFontSize:CGFloat = 32.0
    var defaultAccentFontSize:CGFloat = 22.0
    
    private var snap: UISnapBehavior!
    private var animator: UIDynamicAnimator!
    private var containerView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(style: String, price: String?, sizes: Set<String>?) {
        
        if let x = UserDefaults.standard.value(forKey: "defaultLabelXPosition") as? Int,
            let y = UserDefaults.standard.value(forKey: "defaultLabelYPosition") as? Int {
            
            super.init(frame: CGRect(x: x, y: y, width: 0, height: 0))
        } else {
            super.init(frame: CGRect(x: 20, y: 60, width: 0, height: 0))
        }
        
        self.style = style
        self.price = price
        self.sizes = sizes
        
        initializeSubviews(style: style, price: price, sizes: sizes)
        isUserInteractionEnabled = true
    }
    
    func initializeSubviews(style: String, price: String?, sizes: Set<String>?) {
        // Initialize Font Scale
        if let size = UserDefaults.standard.value(forKey: "defaultFontSize") as? CGFloat {
            defaultFontSize = size
        }
        
        if let size = UserDefaults.standard.value(forKey: "defaultAccentFontSize") as? CGFloat {
            defaultAccentFontSize = size
        }
        
        // Create the UILabel for the style
        initializeStyle(superview: self, style: style)
        
        // Create the UILabel for the price
        if let price = price {
            initializePrice(superview: self, price: price)
        }
        
        // Create the UIView for the sizeCollection
        if let sizes = sizes {
            initializeSizes(superview: self, sizes: sizes)
        }
        
        // Resize self to match size of content
        var priceHeight:CGFloat = 0.0
        var priceWidth:CGFloat = 0.0
        if let label = priceLabel {
            priceHeight = label.frame.size.height
            priceWidth = label.frame.size.width
        }
        
        var sizeHeight:CGFloat = 0.0
        var sizeWidth:CGFloat = 0.0
        if let container = sizeContainer {
            sizeHeight = container.frame.size.height
            sizeWidth = container.frame.size.width
        }
        
        var totalWidth:CGFloat = 0.0
        let labelWithPriceWidth = primaryLabel.frame.size.width + (priceWidth/2)
        if (sizeWidth > (primaryLabel.frame.size.width + (priceWidth/2))) {
            totalWidth = sizeWidth
        } else {
            totalWidth = labelWithPriceWidth
        }
        
        let totalHeight:CGFloat = (priceHeight/2) + (sizeHeight/2) + primaryLabel.frame.size.height
        
        frame.size.width = totalWidth
        frame.size.height = totalHeight
        
        if let label = priceLabel {
            let heightBuffer = label.frame.size.height / 2
            primaryLabel.center.y += heightBuffer
            label.center.y += heightBuffer
            
            if let container = sizeContainer {
                container.center.y += heightBuffer
            }
        }
        
        if (sizeWidth > (primaryLabel.frame.size.width + (priceWidth/2))) {
            if let container = sizeContainer {
                let widthBuffer = frame.size.width / 2
                let newFrame = CGRect(x: 0,
                                      y: frame.size.height - container.frame.size.height,
                                      width: container.frame.size.width,
                                      height: container.frame.size.height)
                
                container.frame = newFrame
                primaryLabel.center.x = widthBuffer
                
                if let label = priceLabel {
                    label.center.x = primaryLabel.frame.maxX
                }
            }
        }
        
        if let x = UserDefaults.standard.value(forKey: "defaultLabelXPosition") as? Float,
            let y = UserDefaults.standard.value(forKey: "defaultLabelYPosition") as? Float {
            
            let xPos = CGFloat(x)
            let yPos = CGFloat(y)
            
            center = CGPoint(x: xPos, y: yPos)
        }
    }
    
    func initializeStyle(superview: UIView, style: String) {
        primaryLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        primaryLabel.text = style
        primaryLabel.numberOfLines = 1
        primaryLabel.textAlignment = .center
        
        if let fontFamily = UserDefaults.standard.object(forKey: "defaultLabelFont") as? String {
            let font = UIFont(name: fontFamily, size: defaultFontSize)
            primaryLabel.font = font
        }
        
        if let color = UserDefaults.standard.colorForKey(key: "defaultLabelBackground") {
            primaryLabel.backgroundColor = color
        } else {
            primaryLabel.backgroundColor = ColorPalette.Primary
        }
        
        if let color = UserDefaults.standard.colorForKey(key: "defaultLabelForeground") {
            primaryLabel.textColor = color
        } else {
            primaryLabel.textColor = UIColor.white
        }
        
        primaryLabel.layer.cornerRadius = 5.0
        primaryLabel.clipsToBounds = true
        
        // Size the primary label to fit its size and add some additional padding
        primaryLabel.sizeToFit()
        primaryLabel.frame.size.width += 20
        primaryLabel.frame.size.height += 20
        
        superview.addSubview(primaryLabel)
    }
    
    func initializeSizes(superview: UIView, sizes: Set<String>) {
        if !sizes.isEmpty {
            sizeContainer = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            
            if let sizeContainer = self.sizeContainer {
                
                var rightBoundary: CGFloat = 0
                
                for size in sizes {
                    let label = UILabel(frame: CGRect(x: rightBoundary, y: 0, width: 0, height: 0))
                    label.text = size
                    label.numberOfLines = 1
                    label.textAlignment = .center
                    
                    if let fontFamily = UserDefaults.standard.object(forKey: "defaultLabelFont") as? String {
                        let font = UIFont(name: fontFamily, size: defaultAccentFontSize)
                        label.font = font
                    }
                    
                    if let color = UserDefaults.standard.colorForKey(key: "defaultLabelAccentBackground") {
                        label.backgroundColor = color
                    } else {
                        label.backgroundColor = ColorPalette.Accent
                    }
                    
                    if let color = UserDefaults.standard.colorForKey(key: "defaultLabelAccentForeground") {
                        label.textColor = color
                    } else {
                        label.textColor = UIColor.white
                    }
                    
                    label.sizeToFit()
                    label.layer.cornerRadius = 5
                    label.clipsToBounds = true
                    label.frame.size.width += 10
                    label.frame.size.height += 10
                    
                    rightBoundary = rightBoundary + label.frame.size.width + 2
                    sizeContainer.addSubview(label)
                }
                
                sizeContainer.sizeToFit()
                
                // sizeToFit() wont work on this view so we have to do it manually
                // change the center position to the bottom middle of the primaryLabel
                if let lastSize = sizeContainer.subviews.last {
                    let newWidth = rightBoundary
                    let newHeight = lastSize.frame.height
                    
                    sizeContainer.frame = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
                    
                    let xPosition = primaryLabel.frame.width / 2
                    let yPosition = primaryLabel.frame.height
                    let newPosition = CGPoint(x: xPosition, y: yPosition)
                    
                    sizeContainer.center = newPosition
                }
                
                superview.addSubview(sizeContainer)
            }
        }
    }
    
    func initializePrice(superview: UIView, price: String) {
        priceLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        if let priceLabel = self.priceLabel {
            priceLabel.text = price
            priceLabel.numberOfLines = 1
            priceLabel.textAlignment = .center
            
            if let fontFamily = UserDefaults.standard.object(forKey: "defaultLabelFont") as? String {
                let font = UIFont(name: fontFamily, size: defaultAccentFontSize)
                priceLabel.font = font
            }
            
            if let color = UserDefaults.standard.colorForKey(key: "defaultLabelAccentBackground") {
                priceLabel.backgroundColor = color
            } else {
                priceLabel.backgroundColor = ColorPalette.Accent
            }
            
            if let color = UserDefaults.standard.colorForKey(key: "defaultLabelAccentForeground") {
                priceLabel.textColor = color
            } else {
                priceLabel.textColor = UIColor.white
            }
            
            priceLabel.sizeToFit()
            priceLabel.layer.cornerRadius = 5
            priceLabel.clipsToBounds = true
            priceLabel.frame.size.width += 10
            priceLabel.frame.size.height += 10
            
            // Move price label to top right of view
            let xPosition = primaryLabel.frame.size.width
            let yPosition:CGFloat = 0.0
            let newPosition = CGPoint(x: xPosition, y: yPosition)
            
            priceLabel.center = newPosition
            
            superview.addSubview(priceLabel)
        }
        
    }
    
    func containWithin(view: UIView) {
        containerView = view
        animator = UIDynamicAnimator(referenceView: view)
    }
    
    func reset() {
        primaryLabel.removeFromSuperview()
        priceLabel?.removeFromSuperview()
        sizeContainer?.removeFromSuperview()
        
        initializeSubviews(style: self.style, price: self.price, sizes: self.sizes)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let animator = self.animator {
            animator.removeAllBehaviors()
            
            for touch in touches {
                let location = touch.location(in: containerView)
                let snap = UISnapBehavior(item: self, snapTo: location)
                
                if let fullWidthLabels = UserDefaults.standard.value(forKey: "fullWidthLabels") as? Bool {
                    if fullWidthLabels {
                        self.transform = CGAffineTransform(rotationAngle: 0)
                    }
                }
                
                snap.damping = 0.2
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
            UserDefaults.standard.set(location.x, forKey: "defaultLabelXPosition")
            UserDefaults.standard.set(location.y, forKey: "defaultLabelYPosition")
        }
    }
    
}
