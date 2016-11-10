//
//  EditorViewController.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 11/2/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var primaryImageView: UIImageView!
    @IBOutlet weak var noImageMessage: UILabel!
    @IBOutlet weak var effectView: UIVisualEffectView!
    @IBOutlet weak var photoSourceView: UIView!
    @IBOutlet weak var customStyleLabelView: UIView!
    @IBOutlet weak var styleField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var sizeField: UITextField!
    @IBOutlet weak var customLabelViewFinishButton: UIButton!
    @IBOutlet weak var assistantToolbar: UIToolbar!
    @IBOutlet weak var removeCollageButton: UIBarButtonItem!
    @IBOutlet weak var toggleRatioButton: UIButton!
    
    var captureIsForPrimaryImage = true
    var labels = [StyleView]()
    
    var snap: UISnapBehavior!
    var animator: UIDynamicAnimator!
    var collage: CollageImageView?
    var customStyleView: StyleView?
    var watermark: WatermarkLabel?
    var watermarkImage: WatermarkImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleField.delegate = self
        priceField.delegate = self
        sizeField.delegate = self
        
        automaticallyAdjustsScrollViewInsets = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        
        initializeLabels()
        setWatermark()
        
        effectView.isHidden = true
        photoSourceView.layer.cornerRadius = 5
        customStyleLabelView.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if primaryImageView.image == nil {
            assistantToolbar.isHidden = true
            noImageMessage.isHidden = false
            toggleRatioButton.isHidden = true
            hideLabels()
        } else {
            noImageMessage.isHidden = true
            assistantToolbar.isHidden = false
            toggleRatioButton.isHidden = false
        }
        
        if collage != nil {
            removeCollageButton.isEnabled = true
        } else {
            removeCollageButton.isEnabled = false
        }
        
        resetLabels()
        setWatermark()
        setWatermarkImage()
        
        if let fullWidthLabels = UserDefaults.standard.value(forKey: "fullWidthLabels") as? Bool {
            if fullWidthLabels {
                makeLabelsWide()
            }
        }
    }
    
    func setWatermarkImage() {
        guard watermarkImage == nil else {
            watermarkImage?.reset()
            toggleWatermarkImageVisibility()
            return
        }
        
        if let decider = UserDefaults.standard.value(forKey: "watermarkImage") as? Bool {
            
            if decider {
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let filePath = documentsURL.appendingPathComponent("watermark.png").path
                
                if FileManager.default.fileExists(atPath: filePath) {
                    if let img = UIImage(contentsOfFile: filePath) {
                        let rect = CGRect(x: 0, y: 0, width: 200, height: 100)
                        watermarkImage = WatermarkImage(frame: rect)
                        watermarkImage?.image = img
                        watermarkImage?.containWithin(view: containerView)
                        watermarkImage?.sizeToFit()
                        watermarkImage?.center = containerView.center
                        
                        
                        if let image = watermarkImage {
                            containerView.addSubview(image)
                            image.reset()
                            toggleWatermarkImageVisibility()
                        }
                    }
                }
            }
        }
    }
    
    func setWatermark() {
        guard watermark == nil else {
            watermark?.reset()
            toggleWatermarkVisibility()
            return
        }
        
        if let decider = UserDefaults.standard.value(forKey: "watermark") as? Bool,
            let text = UserDefaults.standard.value(forKey: "watermarkText") as? String {
            
            if decider {
                let rect = CGRect(x: 0, y: 0, width: 200, height: 100)
                watermark = WatermarkLabel(frame: rect)
                watermark?.text = text
                watermark?.containWithin(view: containerView)
                watermark?.sizeToFit()
                
                if let label = watermark {
                    containerView.addSubview(label)
                    label.reset()
                    toggleWatermarkVisibility()
                }
            }
        }
    }
    
    func toggleWatermarkVisibility() {
        if let decider = UserDefaults.standard.value(forKey: "watermark") as? Bool {
            if decider {
                watermark?.isHidden = false
            } else {
                watermark?.isHidden = true
                return
            }
        }
        
        if primaryImageView.image != nil {
            watermark?.isHidden = false
        } else {
            watermark?.isHidden = true
        }
    }
    
    func toggleWatermarkImageVisibility() {
        if let decider = UserDefaults.standard.value(forKey: "watermarkImage") as? Bool {
            if decider {
                watermarkImage?.isHidden = false
            } else {
                watermarkImage?.isHidden = true
                return
            }
        }
        
        if primaryImageView.image != nil {
            watermarkImage?.isHidden = false
        } else {
            watermarkImage?.isHidden = true
        }
    }
    
    @IBAction func unwindFromStylePicker(segue: UIStoryboardSegue) {
        for label in labels {
            label.removeFromSuperview()
        }
        
        labels.removeAll()
        
        initializeLabels()
        showLabels()
    }
    
       
    func makeLabelsWide() {
        for styleView in labels {
            styleView.frame.size.width = view.frame.size.width
            styleView.frame.origin.x = 0
            styleView.primaryLabel.frame.size.width = view.frame.size.width
            styleView.primaryLabel.layer.cornerRadius = 0
            
            if let priceLabel = styleView.priceLabel {
                priceLabel.frame.origin.x = styleView.frame.width - priceLabel.frame.width
            }
            
            if let sizeContainer = styleView.sizeContainer {
                sizeContainer.frame.origin.x = (styleView.frame.width / 2) - (sizeContainer.frame.width / 2)
            }
        }
    }
    
    func showLabels() {
        for label in labels {
            label.isHidden = false
        }
    }
    
    func hideLabels() {
        for label in labels {
            label.isHidden = true
        }
    }
    
    func resetLabels() {
        for label in labels {
            label.reset()
        }
        
        if collage != nil {
            setCollage(image: collage?.image)
        }
    }
    
    func setCollage(image: UIImage?) {
        guard image != nil else {
            print("exiting set collage")
            return
        }
        
        var size: CGFloat = 125
        
        if let newSize = UserDefaults.standard.value(forKey: "defaultCollageSize") as? CGFloat {
            size = newSize
        }
        
        if collage != nil {
            collage?.removeFromSuperview()
        }
        
        var collageRect = CGRect(x: containerView.center.x, y: containerView.center.y, width: size, height: size)
        
        if let x = UserDefaults.standard.value(forKey: "defaultCollageXPosition") as? CGFloat,
            let y = UserDefaults.standard.value(forKey: "defaultCollageYPosition") as? CGFloat {
            
            collageRect = CGRect(x: x, y: y, width: size, height: size)
        }
        
        collage = CollageImageView(frame: collageRect)
        collage?.image = image
        collage?.isUserInteractionEnabled = true
        collage?.containWithin(view: self.containerView)
        removeCollageButton.isEnabled = true
        
        if let collageView = collage {
            containerView.addSubview(collageView)
        }
    }
    
    @IBAction func removeCollage() {
        collage?.removeFromSuperview()
        collage = nil
        removeCollageButton.isEnabled = false
    }
    
    @IBAction func unwindToEditor(segue: UIStoryboardSegue) {
        resetLabels()
    }
    
    @IBAction func toggleRatio() {
        if scrollView.frame.width == scrollView.frame.height {
            makeEditorRectangular()
            UserDefaults.standard.set(false, forKey: "editorIsSquare")
        } else {
            makeEditorSquare()
            UserDefaults.standard.set(true, forKey: "editorIsSquare")
        }
    }
    
    func makeEditorRectangular() {
        containerView.translatesAutoresizingMaskIntoConstraints = true
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        
        UIView.animate(withDuration: 0.25, animations: {
            let rect = CGRect(x: 0, y: 40, width: self.view.frame.width, height: self.assistantToolbar.frame.minY - 40)
            self.containerView.frame = rect
            self.scrollView.frame = rect
            
            let point = self.editorCenter()
            self.containerView.center = point
            self.scrollView.center = point
        })
    }
    
    func makeEditorSquare() {
        containerView.translatesAutoresizingMaskIntoConstraints = true
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        UIView.animate(withDuration: 0.25, animations: {
            let rect = CGRect(x: 0, y: 40, width: self.view.frame.width, height: self.view.frame.width)
            self.containerView.frame = rect
            self.scrollView.frame = rect
            
            let point = self.editorCenter()
            self.containerView.center = point
            self.scrollView.center = point
        })
    }
    
    func editorCenter() -> CGPoint {
        let y = (self.assistantToolbar.frame.minY + 40) / 2
        let x = self.view.frame.width / 2
        return CGPoint(x: x, y: y)
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
}
