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
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var noImageMessage: UILabel!
    @IBOutlet weak var effectView: UIVisualEffectView!
    @IBOutlet weak var photoSourceView: UIView!
    
    var captureIsForPrimaryImage = true
    var labels = [StyleView]()
    
    var snap: UISnapBehavior!
    var animator: UIDynamicAnimator!
    var collage: CollageImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        
        initializeLabels()

        effectView.isHidden = true
        photoSourceView.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if primaryImageView.image == nil {
            saveButton.isHidden = true
            noImageMessage.isHidden = false
        } else {
            noImageMessage.isHidden = true
            saveButton.isHidden = false
        }
        
        resetLabels()
    }
    
    func initializeLabels() {
        if let styles = UserDefaults.standard.stylesForKey(key: "selectedStyles") {
            for (style,sizes) in styles {
                let styleView = StyleView(style: style, price: nil, sizes: sizes)
                styleView.containWithin(view: containerView)
                
                if let fullWidthLabels = UserDefaults.standard.value(forKey: "fullWidthLabels") as? Bool {
                    if fullWidthLabels {
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
                
                labels.append(styleView)
                styleView.isHidden = true
                containerView.addSubview(styleView)
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
            print("resetting \(label)")
            label.reset()
        }
    }
    
    func removeCollage() {
        let alert = UIAlertController(title: "Collage Photo", message: "Are you sure you want to remove the collage photo?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { (action) -> Void in
            self.collage?.removeFromSuperview()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func setCollage(image: UIImage) {
        if let x = UserDefaults.standard.value(forKey: "defaultCollageXPosition") as? Int,
            let y = UserDefaults.standard.value(forKey: "defaultCollageYPosition") as? Int {
            
            let collageRect = CGRect(x: x, y: y, width: 125, height: 125)
            
            collage = CollageImageView(frame: collageRect)
            collage.image = image
            collage.isUserInteractionEnabled = true
            collage.containWithin(view: self.containerView)
            
            containerView.addSubview(collage)
            
            let longPressCollageGesture = UILongPressGestureRecognizer(target: self, action: #selector(EditorViewController.removeCollage))
            longPressCollageGesture.cancelsTouchesInView = true
            collage.addGestureRecognizer(longPressCollageGesture)
        }
    }
    
    @IBAction func unwindToEditor(segue: UIStoryboardSegue) {
        print("Hello world")
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
}
