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

    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
}
