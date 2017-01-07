//
//  UIStyleLabel.swift
//  ConsultantAide
//
//  Created by Matt Orahood on 9/27/16.
//  Copyright © 2016 Matt Orahood. All rights reserved.
//

import UIKit
import CoreData

final class StyleView: UIView {
    var primaryLabel: UILabel?
    var priceLabel: UILabel?
    var sizeContainer: UIView?
    var containerView: UIView?
    var animator: UIDynamicAnimator?
    var savedLabel: SavedLabel?
    
    var style: String = ""
    var price: Float = 0.0
    var sizes: [String]?
    var forKids = false
    
    private let primaryPadding: CGFloat = 20.0
    private let secondaryPadding: CGFloat = 5.0
    private var defaultFontSize:Float = 24.0
    private var defaultAccentFontSize:Float = 12.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(style: String, price: Float = 0.0, sizes: [String]?, forKids: Bool) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.forKids = forKids
        internalInitializer(style: style, price: price, sizes: sizes)
    }
    
    init(savedLabel: SavedLabel) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.forKids = savedLabel.forKids
        internalInitializer(style: savedLabel.name, price: savedLabel.price, sizes: savedLabel.sizes)
        
        self.savedLabel = savedLabel
    }
    
    func containWithin(view: UIView?) {
        guard let view = view else {
            print("Cannot containWithin nil optional")
            return
        }
        
        containerView = view
        animator = UIDynamicAnimator(referenceView: view)
    }
    
    func moveToSavedPosition() {
        guard let savedLabel = self.savedLabel else {
            print("Cannot moved to saved position, no saved object")
            return
        }
        
        if let container = containerView {
            if ((CGFloat(savedLabel.yPos) + frame.height) > container.frame.maxY) {
                frame.origin = CGPoint(x: 0, y: 0)
                return
            }
        }
        
        frame.origin = CGPoint(x: Int(savedLabel.xPos), y: Int(savedLabel.yPos))
    }
    
    private func internalInitializer(style: String, price: Float = 0.0, sizes: [String]?) {
        self.style = style
        self.price = price
        self.sizes = sizes
        
        // Create UILabel for primaryLabel
        if let primaryLabel = generateStyleLabel(style: style) {
            let styledLabel = applyPrimaryStyle(to: primaryLabel)
            self.primaryLabel = styledLabel
            addSubview(styledLabel)
        }
        
        // Create UIView for sizeContainer
        let sizeLabels = generateSizeLabels(sizes: sizes)
        let styledSizeLabels = applySecondaryStyle(to: sizeLabels)
        if let container = generateSizeContainer(sizes: styledSizeLabels) {
            self.sizeContainer = container
            addSubview(container)
        }
        
        // Create the UILabel for the price
        var mapDecider: Bool = true
        
        if let savedDecider = UserDefaults.standard.value(forKey: "mapPrice") as? Bool {
            mapDecider = savedDecider
        }
        
        if price > 0 && mapDecider {
            if let priceLabel = generatePriceLabel(price: price) {
                let styledLabel = applySecondaryStyle(to: priceLabel)
                self.priceLabel = styledLabel
                addSubview(styledLabel)
            }
        }
        
        sizeToFitStyleInformation()
        positionStyleInformation()
        isUserInteractionEnabled = true
    }
    
    private func generateStyleLabel(style: String?) -> UILabel? {
        guard let style = style else {
            return nil
        }
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = style
        
        if (forKids) {
            label.text?.append(" - Kids")
        }
        
        label.numberOfLines = 1
        label.textAlignment = .center
        label.layer.cornerRadius = 5.0
        label.clipsToBounds = true
        label.sizeToFit()
        
        return label
    }
    
    private func generateSizeContainer(sizes: [UILabel]?) -> UIView? {
        guard let labels = sizes else {
            return nil
        }
        
        if !(labels.isEmpty) {
            let container = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            var spacingBuffer: CGFloat = 0.0
            var tallestHeight: CGFloat = 0.0
            
            
            for label in labels {
                let rect = CGRect(x: spacingBuffer, y: 0, width: label.frame.width, height: label.frame.height)
                label.frame = rect
                container.addSubview(label)
                
                if label.frame.height > tallestHeight {
                    tallestHeight = label.frame.height
                }
                
                spacingBuffer += label.frame.width + 5
            }
            
            let rect = CGRect(x: 0, y: 0, width: spacingBuffer-5, height: tallestHeight)
            container.frame = rect
            
            return container
        } else {
            return nil
        }
    }
    
    private func generateSizeLabels(sizes: [String]?) -> [UILabel]? {
        guard let sizes = sizes else {
            return nil
        }
        
        var labels: [UILabel] = []
        
        if !(sizes.isEmpty) {
            for size in sizes {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                label.text = size
                label.numberOfLines = 1
                label.textAlignment = .center
                label.sizeToFit()
                label.layer.cornerRadius = 5
                label.clipsToBounds = true
                labels.append(label)
            }
            
            return labels
        } else {
            return nil
        }
    }
    
    private func childLabels(view: UIView?) -> [UILabel]? {
        guard let view = view else {
            print("The view is nil, cannot find subviews.")
            return nil
        }
        
        return view.subviews.filter { $0 is UILabel } as? [UILabel]
    }
    
    private func applySecondaryStyle(to labels: [UILabel]?) -> [UILabel]? {
        guard let labels = labels else {
            return nil
        }
        
        return labels.map { applySecondaryStyle(to: $0) }
    }
    
    private func applySecondaryStyle(to label: UILabel) -> UILabel {
        // Reset default font sizes if saved values exists
        if let size = UserDefaults.standard.value(forKey: "secondaryFontSize") as? Float {
            defaultAccentFontSize = size
        }
        
        // Set default font or saved font for primary label
        if let fontFamily = UserDefaults.standard.object(forKey: "defaultFont") as? String {
            let font = UIFont(name: fontFamily, size: CGFloat(defaultFontSize))
            primaryLabel?.font = font
        } else {
            let font = UIFont(name: "Gill Sans", size: CGFloat(defaultFontSize))
            primaryLabel?.font = font
        }
        
        // Set default values
        var font = UIFont(name: "Gill Sans", size: CGFloat(defaultAccentFontSize))
        var color = ColorPalette.Accent
        var fontColor: UIColor = .white
        
        // Override default values with custom secondary setting values
        if let fontFamily = UserDefaults.standard.object(forKey: "defaultFont") as? String {
            font = UIFont(name: fontFamily, size: CGFloat(defaultAccentFontSize))
        }
        
        if let secondary = UserDefaults.standard.colorForKey(key: "secondary") {
            color = secondary
        }
        
        if let secondaryFont = UserDefaults.standard.colorForKey(key: "secondaryFont") {
            fontColor = secondaryFont
        }
        
        // Apply the styles
        label.backgroundColor = color
        label.font = font
        label.textColor = fontColor
        label.sizeToFit()
        label.frame.size.width += secondaryPadding
        label.frame.size.height += secondaryPadding
        
        return label
    }
    
    private func generatePriceLabel(price: Float) -> UILabel? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = String(format: "$%.0f", price)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.sizeToFit()
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        
        return label
    }
    
    private func applyPrimaryStyle(to label: UILabel) -> UILabel {
        // Reset default font sizes if saved values exists
        if let size = UserDefaults.standard.value(forKey: "fontSize") as? Float {
            defaultFontSize = size
        }
        
        if let size = UserDefaults.standard.value(forKey: "secondaryFontSize") as? Float {
            defaultAccentFontSize = size
        }
        
        // Set default font or saved font for primary label
        if let fontFamily = UserDefaults.standard.object(forKey: "defaultFont") as? String {
            let font = UIFont(name: fontFamily, size: CGFloat(defaultFontSize))
            label.font = font
        } else {
            let font = UIFont(name: "Gill Sans", size: CGFloat(defaultFontSize))
            label.font = font
        }
        
        // Set default color or saved color for primary label background
        if let color = UserDefaults.standard.colorForKey(key: "primary") {
            label.backgroundColor = color
        } else {
            label.backgroundColor = ColorPalette.Primary
        }
        
        // Set default color or saved color for primary label font
        if let color = UserDefaults.standard.colorForKey(key: "primaryFont") {
            label.textColor = color
        } else {
            label.textColor = UIColor.white
        }
        
        label.sizeToFit()
        label.frame.size.width += primaryPadding
        label.frame.size.height += primaryPadding
        
        return label
    }
    
    private func sizeToFitStyleInformation() {
        guard let primaryLabel = self.primaryLabel else {
            print("Primary label is reuqired, cannot sizeToFitStyleInformation")
            return
        }
        
        var totalWidth: CGFloat = 0.0
        var totalHeight: CGFloat = 0.0
        
        totalWidth += primaryLabel.frame.width
        totalHeight += primaryLabel.frame.height
        
        if let price = priceLabel {
            totalWidth += price.frame.width/2
            totalHeight += price.frame.height/2
        }
        
        if let container = sizeContainer {
            totalHeight += (container.frame.height/2)
            
            if totalWidth < container.frame.width {
                totalWidth = container.frame.width
            }
        }
        
        frame = CGRect(x: 0.0, y: 0.0, width: totalWidth, height: totalHeight)
    }
    
    private func positionStyleInformation() {
        guard let primaryLabel = self.primaryLabel else {
            print("Primary label is required, cannot positionStyleInformation")
            return
        }
        
        if let container = sizeContainer {
            if frame.width <= container.frame.width {
                // Size container needs to be the centered object
                let y = frame.height - container.frame.height
                container.frame = CGRect(x: 0, y: y, width: container.frame.width, height: container.frame.height)
                
                primaryLabel.center = center
            } else {
                primaryLabel.frame = CGRect(x: 0, y: center.y-(primaryLabel.frame.height/2), width: primaryLabel.frame.width, height: primaryLabel.frame.height)
                container.center = CGPoint(x: primaryLabel.center.x, y: primaryLabel.frame.maxY)
            }
        }
        
        if let price = priceLabel {
            if sizeContainer == nil {
                primaryLabel.frame = CGRect(x: 0, y: price.frame.height/2, width: primaryLabel.frame.width, height: primaryLabel.frame.height)
            }
            
            price.center = CGPoint(x: primaryLabel.frame.maxX, y: primaryLabel.frame.minY)
        } else {
            primaryLabel.frame = CGRect(x: (frame.width/2)-(primaryLabel.frame.width/2), y: 0, width: primaryLabel.frame.width, height: primaryLabel.frame.height)
            if let container = sizeContainer {
                container.center = CGPoint(x: primaryLabel.center.x, y: primaryLabel.frame.maxY)
            }
        }
    }
}

extension StyleView: UICollisionBehaviorDelegate {
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let containerView = self.containerView else {
            print("No container view present, will not apply movement behavior")
            return
        }
        
        guard let animator = self.animator else {
            print("No animator found, will not apply movement behavior")
            return
        }
        
        animator.removeAllBehaviors()
        
        for touch in touches {
            let location = touch.location(in: containerView)
            
            let snap = UISnapBehavior(item: self, snapTo: location)
            snap.damping = 0.2
            animator.addBehavior(snap)
            
            let boundry = UICollisionBehavior(items: [self])
            boundry.collisionDelegate = self
            boundry.translatesReferenceBoundsIntoBoundary = true
            animator.addBehavior(boundry)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var point = CGPoint(x: 0, y: 0)

        for _ in touches {
            if let fullWidthLabels = UserDefaults.standard.value(forKey: "fullWidthLabels") as? Bool {
                if fullWidthLabels {
                    point = CGPoint(x: 0, y: frame.origin.y)
                } else {
                    point = frame.origin
                }
            } else {
                point = frame.origin
            }
            
        }

        savePosition(x: Int(point.x), y: Int(point.y))
    }

    func savePosition(x: Int, y: Int) {
        guard let label = savedLabel, savedLabel != nil else {
            print("No saved label object")
            return
        }

        let predicate = NSPredicate(format: "self = %@", label.objectID)
        let fetchRequest = NSFetchRequest<SavedLabel>(entityName: "SavedLabel")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = predicate

        do {
            let result = try context.fetch(fetchRequest)
            result.first?.xPos = Int16(x)
            result.first?.yPos = Int16(y)
            ad.saveContext()
        } catch {
            print("Failed to load SavedLabel from CoreData")
        }
    }
}
