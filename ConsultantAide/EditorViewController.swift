//
//  EditorViewController.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 11/2/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {
    
    var labels = [StyleView]()
    
    var snap: UISnapBehavior!
    var animator: UIDynamicAnimator!
    var labelService: SavedLabelService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    func setWatermarkImage() {
//        guard watermarkImage == nil else {
//            watermarkImage?.reset()
//            toggleWatermarkImageVisibility()
//            return
//        }
//        
//        if let decider = UserDefaults.standard.value(forKey: "watermarkImage") as? Bool {
//            
//            if decider {
//                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//                let filePath = documentsURL.appendingPathComponent("watermark.png").path
//                
//                if FileManager.default.fileExists(atPath: filePath) {
//                    if let img = UIImage(contentsOfFile: filePath) {
//                        let rect = CGRect(x: 0, y: 0, width: 200, height: 100)
//                        watermarkImage = WatermarkImage(frame: rect)
//                        watermarkImage?.image = img
//                        watermarkImage?.containWithin(view: containerView)
//                        watermarkImage?.sizeToFit()
//                        watermarkImage?.center = containerView.center
//                        
//                        
//                        if let image = watermarkImage {
//                            containerView.addSubview(image)
//                            image.reset()
//                            toggleWatermarkImageVisibility()
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    func setWatermark() {
//        guard watermark == nil else {
//            watermark?.reset()
//            toggleWatermarkVisibility()
//            return
//        }
//        
//        if let decider = UserDefaults.standard.value(forKey: "watermark") as? Bool,
//            let text = UserDefaults.standard.value(forKey: "watermarkText") as? String {
//            
//            if decider {
//                let rect = CGRect(x: 0, y: 0, width: 200, height: 100)
//                watermark = WatermarkLabel(frame: rect)
//                watermark?.text = text
//                watermark?.containWithin(view: containerView)
//                watermark?.sizeToFit()
//                watermark?.moveToSavedPosition()
//                
//                if let label = watermark {
//                    containerView.addSubview(label)
//                    label.reset()
//                    toggleWatermarkVisibility()
//                }
//            }
//        }
//    }
//    
//    func toggleWatermarkVisibility() {
//        if let decider = UserDefaults.standard.value(forKey: "watermark") as? Bool {
//            if decider {
//                watermark?.isHidden = false
//            } else {
//                watermark?.isHidden = true
//                return
//            }
//        }
//        
//        if primaryImageView.image != nil {
//            watermark?.isHidden = false
//        } else {
//            watermark?.isHidden = true
//        }
//    }
//    
//    func toggleWatermarkImageVisibility() {
//        if let decider = UserDefaults.standard.value(forKey: "watermarkImage") as? Bool {
//            if decider {
//                watermarkImage?.isHidden = false
//            } else {
//                watermarkImage?.isHidden = true
//                return
//            }
//        }
//        
//        if primaryImageView.image != nil {
//            watermarkImage?.isHidden = false
//        } else {
//            watermarkImage?.isHidden = true
//        }
//    }
//    
//    @IBAction func unwindFromStylePicker(segue: UIStoryboardSegue) {
//        for label in labels {
//            label.removeFromSuperview()
//        }
//        
//        labels.removeAll()
//        
//        initializeLabels()
//        showLabels()
//    }
//    
       
//    func makeLabelsWide() {
//        for styleView in labels {
//            guard let primaryLabel = styleView.primaryLabel else {
//                continue
//            }
//            
//            styleView.frame.size.width = view.frame.size.width
//            styleView.frame.origin.x = 0
//            primaryLabel.frame.size.width = view.frame.size.width
//            primaryLabel.layer.cornerRadius = 0
//            
//            if let priceLabel = styleView.priceLabel {
//                priceLabel.frame.origin.x = styleView.frame.width - priceLabel.frame.width
//            }
//            
//            if let sizeContainer = styleView.sizeContainer {
//                sizeContainer.frame.origin.x = (styleView.frame.width / 2) - (sizeContainer.frame.width / 2)
//            }
//        }
//    }
//
//    
//    func setCollage(image: UIImage?) {
//        guard image != nil else {
//            print("exiting set collage")
//            return
//        }
//        
//        var size: CGFloat = 125
//        
//        if let newSize = UserDefaults.standard.value(forKey: "defaultCollageSize") as? CGFloat {
//            size = newSize
//        }
//        
//        if collage != nil {
//            collage?.removeFromSuperview()
//        }
//        
//        var collageRect = CGRect(x: containerView.center.x, y: containerView.center.y, width: size, height: size)
//        
//        if let x = UserDefaults.standard.value(forKey: "defaultCollageXPosition") as? CGFloat,
//            let y = UserDefaults.standard.value(forKey: "defaultCollageYPosition") as? CGFloat {
//            
//            collageRect = CGRect(x: x, y: y, width: size, height: size)
//        }
//        
//        collage = CollageImageView(frame: collageRect)
//        collage?.image = image
//        collage?.isUserInteractionEnabled = true
//        collage?.containWithin(view: self.containerView)
//        collage?.movetoSavedPosition()
//        removeCollageButton.isEnabled = true
//        
//        if let collageView = collage {
//            containerView.addSubview(collageView)
//        }
//    }
//    
//    @IBAction func removeCollage() {
//        collage?.removeFromSuperview()
//        collage = nil
//        removeCollageButton.isEnabled = false
//    }
//
//    func resetEverything() {
//        // Reset the labels
//        for (index, label) in labels.enumerated() {
//            labels.remove(at: index)
//            label.removeFromSuperview()
//            var resetLabel: StyleView
//            if let savedLabel = label.savedLabel {
//                resetLabel = StyleView(savedLabel: savedLabel)
//            } else {
//                resetLabel = StyleView(style: label.style, price: label.price, sizes: label.sizes)
//            }
//            
//            labels.append(resetLabel)
//        }
//        
//        // Make the labels wide if necessary
//        if let fullWidthLabels = UserDefaults.standard.value(forKey: "fullWidthLabels") as? Bool {
//            if fullWidthLabels {
//                print("Making labels wide after reset")
//                makeLabelsWide()
//            }
//        }
//        
//        // Add reset labels to container view
//        for label in labels {
//            label.containWithin(view: containerView)
//            label.moveToSavedPosition()
//            containerView.addSubview(label)
//        }
//        
//        // Reset watermark text
//        if let label = watermark {
//            let rect = CGRect(x: label.frame.origin.x,
//                              y: label.frame.origin.y,
//                              width: label.frame.width,
//                              height: label.frame.height)
//            let resetWatermark = WatermarkLabel(frame: rect)
//            watermark?.removeFromSuperview()
//            watermark = resetWatermark
//            watermark?.containWithin(view: containerView)
//            watermark?.moveToSavedPosition()
//            containerView.addSubview(resetWatermark)
//        }
//        
//        // Reset watermark image
//        if let image = watermarkImage {
//            let rect = CGRect(x: image.frame.origin.x,
//                              y: image.frame.origin.y,
//                              width: image.frame.width,
//                              height: image.frame.height)
//            let resetWatermarkImage = WatermarkImage(frame: rect)
//            resetWatermarkImage.image = image.image
//            image.removeFromSuperview()
//            watermarkImage = resetWatermarkImage
//            watermarkImage?.containWithin(view: containerView)
//            watermarkImage?.moveToSavedPosition()
//            containerView.addSubview(resetWatermarkImage)
//        }
//        
//        // Reset collage
//        if let image = collage {
//            let rect = CGRect(x: image.frame.origin.x,
//                              y: image.frame.origin.y,
//                              width: image.frame.width,
//                              height: image.frame.height)
//            let resetCollage = CollageImageView(frame: rect)
//            resetCollage.image = image.image
//            collage = resetCollage
//            collage?.containWithin(view: containerView)
//            collage?.movetoSavedPosition()
//            containerView.addSubview(resetCollage)
//        }
//    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
}
