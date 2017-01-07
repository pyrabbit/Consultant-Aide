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
    
    var primaryImageView: UIImageView!
    var labelContainer: UIView!
    var labels = [StyleView]()
    var labelService: SavedLabelService?
    
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
    
    @IBAction func cancel(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        get { return true }
    }
    
}
