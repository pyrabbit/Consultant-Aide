//
//  LabelEditorViewController.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 12/10/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import UIKit

class LabelEditorViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var removeItemsBtn: UIButton!
    @IBOutlet var collageSourceView: CollageSourceView!
    
    var primaryImageView: UIImageView!
    var labelContainer: UIView!
    var labels = [StyleView]()
    var labelService: SavedLabelService?
    var collage: CollageImageView?
    var modalBackground: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelService = SavedLabelService()
        labelService?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let yPos = (containerView.frame.height/2)-(primaryImageView.frame.height/2)
        let rect = CGRect(x: 0, y: yPos, width: primaryImageView.frame.width, height: primaryImageView.frame.height)
        primaryImageView.frame = rect
        labelContainer = UIView(frame: rect)
        
        containerView.addSubview(primaryImageView)
        containerView.addSubview(labelContainer)
        
        labelService?.fetch()
        
        if labels.isEmpty {
            removeItemsBtn.isEnabled = false
        }
        
        if (labelContainer.subviews.count > 0) {
            removeItemsBtn.isEnabled = true
        }
        
        // Make the labels wide if necessary
        if let fullWidthLabels = UserDefaults.standard.value(forKey: "fullWidthLabels") as? Bool {
            if fullWidthLabels {
                makeLabelsWide()
            }
        }
        
        setCollage(image: collage?.image)
    }

    @IBAction func addCollage(_ sender: Any) {
        addBackgroundModal()
        
        let xPos = view.center.x - (collageSourceView.frame.width/2)
        
        let rect = CGRect(x: xPos, y: view.bounds.maxY + collageSourceView.frame.height,
                          width: collageSourceView.frame.width,
                          height: collageSourceView.frame.height)
        
        collageSourceView.frame = rect
        collageSourceView.layer.cornerRadius = 5
        collageSourceView.layer.masksToBounds = true
        collageSourceView.delegate = self
        
        view.addSubview(collageSourceView)
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: [], animations: {
            
            self.collageSourceView.center = self.view.center
        })
    }
    
    func makeLabelsWide() {
        for styleView in labels {
            guard let primaryLabel = styleView.primaryLabel else {
                continue
            }

            styleView.frame.size.width = view.frame.size.width
            styleView.frame.origin.x = 0
            primaryLabel.frame.size.width = view.frame.size.width
            primaryLabel.layer.cornerRadius = 0

            if let priceLabel = styleView.priceLabel {
                priceLabel.frame.origin.x = styleView.frame.width - priceLabel.frame.width
            }

            if let sizeContainer = styleView.sizeContainer {
                sizeContainer.frame.origin.x = (styleView.frame.width / 2) - (sizeContainer.frame.width / 2)
            }
        }
    }
    
    func setPrimaryImageView(frame: CGRect, image: UIImage?) {
        primaryImageView = UIImageView(frame: frame)
        primaryImageView.image = image
        primaryImageView.contentMode = .scaleAspectFit
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

        var collageRect = CGRect(x: labelContainer.center.x, y: labelContainer.center.y, width: size, height: size)

        if let x = UserDefaults.standard.value(forKey: "defaultCollageXPosition") as? CGFloat,
            let y = UserDefaults.standard.value(forKey: "defaultCollageYPosition") as? CGFloat {

            collageRect = CGRect(x: x, y: y, width: size, height: size)
        }

        collage = CollageImageView(frame: collageRect)
        collage?.image = image
        collage?.isUserInteractionEnabled = true
        collage?.containWithin(view: self.labelContainer)
        collage?.movetoSavedPosition()

        if let collageView = collage {
            labelContainer.addSubview(collageView)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    private func addBackgroundModal() {
        modalBackground = UIView(frame: view.bounds)
        modalBackground?.backgroundColor = .black
        modalBackground?.alpha = 0.8
        
        if let bg = modalBackground {
            view.addSubview(bg)
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        get { return true }
    }
    
}
