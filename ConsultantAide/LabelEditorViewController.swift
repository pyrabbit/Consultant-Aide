//
//  LabelEditorViewController.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 12/10/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import UIKit

class LabelEditorViewController: UIViewController {

    var primaryImageView: UIImageView?
    var containerView: UIView!
    var labels = [StyleView]()
    var customStyleView: StyleView?
    
    @IBOutlet weak var effectView: UIVisualEffectView!
    @IBOutlet weak var styleField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var sizeField: UITextField!
    @IBOutlet weak var customStyleLabelView: UIView!
    @IBOutlet weak var customLabelViewFinishButton: UIButton!
    
    func setPrimaryImageView(frame: CGRect, image: UIImage?) {
        if let existingImageView = primaryImageView {
            existingImageView.removeFromSuperview()
        }
        
        if containerView != nil {
            containerView.removeFromSuperview()
        }
        
        primaryImageView = UIImageView(frame: frame)
        primaryImageView?.image = image
        primaryImageView?.contentMode = .scaleAspectFit
        
        if let newView = primaryImageView {
            view.addSubview(newView)
            containerView = UIView(frame: newView.frame)
            containerView.backgroundColor = .clear
            view.addSubview(containerView)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        get { return true }
    }
}
