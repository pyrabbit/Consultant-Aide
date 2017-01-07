//
//  PhotoEditorViewController.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 12/10/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import UIKit

class PhotoEditorViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var squareButton: UIButton!
    @IBOutlet weak var portraitButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var scrollView: UIScrollView!
    var primaryImageView: UIImageView!
    var selectedImage: UIImage?
    var modifiedImage: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let rect = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        
        scrollView = UIScrollView(frame: rect)
        primaryImageView = UIImageView(frame: rect)
        primaryImageView.image = selectedImage
        primaryImageView.contentMode = .scaleAspectFit
        scrollView.addSubview(primaryImageView)
        scrollView.isUserInteractionEnabled = true
        scrollView.delegate = self
        scrollView.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        
        
        containerView.addSubview(scrollView)
        containerView.isHidden = true
     
        let decider = UserDefaults.standard.bool(forKey: "defaultImageSizeIsPortrait")
        
        if (decider) {
            portraitButton.isEnabled = false
            squareButton.isEnabled = true
            
            let rect = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
            scrollView.frame = rect
            primaryImageView.frame = rect
        } else {
            squareButton.isEnabled = false
            portraitButton.isEnabled = true
            
            let yPos = (containerView.frame.height/2)-(view.bounds.width/2)
            let rect = CGRect(x: 0, y: yPos, width: view.bounds.width, height: view.bounds.width)
            scrollView.frame = rect
            primaryImageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width)
        }
        
        if let scale = UserDefaults.standard.value(forKey: "defaultScrollViewScale") as? CGFloat {
            scrollView.setZoomScale(scale, animated: true)
        }
        
        containerView.isHidden = false
    }

    @IBAction func cancel(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func makeEditorRectangular() {
        portraitButton.isEnabled = false
        squareButton.isEnabled = true
        UserDefaults.standard.set(true, forKey: "defaultImageSizeIsPortrait")
        
        UIView.animate(withDuration: 0.25, animations: {
            let rect = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
            self.scrollView.frame = rect
        })
    }
    
    @IBAction func makeEditorSquare() {
        squareButton.isEnabled = false
        portraitButton.isEnabled = true
        UserDefaults.standard.set(false, forKey: "defaultImageSizeIsPortrait")
        
        UIView.animate(withDuration: 0.25, animations: {
            let yPos = (self.containerView.frame.height/2)-(self.view.bounds.width/2)
            let rect = CGRect(x: 0, y: yPos, width: self.view.bounds.width, height: self.view.bounds.width)
            self.scrollView.frame = rect
        })

    }
    
    @IBAction func nextStep(_ sender: Any) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return
        }
        
        guard let ciImageConversion = CIImage(image: image) else {
            return
        }
        
        let context = CIContext(options: nil)
        
        guard let newCGImage = context.createCGImage(ciImageConversion, from: ciImageConversion.extent) else {
            return
        }
        
        let scale = image.scale
        let cropRect = CGRect(x: scrollView.frame.origin.x * scale,
                              y: (scrollView.frame.origin.y * scale)+40,
                              width: scrollView.frame.width * scale,
                              height: scrollView.frame.height * scale)
        
        guard let croppedImage = newCGImage.cropping(to: cropRect) else {
            return
        }
        
        modifiedImage = UIImage(cgImage: croppedImage)
        
        UIGraphicsEndImageContext()
        
        performSegue(withIdentifier: "segueToLabelEditor",  sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let vc = segue.destination as! LabelEditorViewController
        vc.setPrimaryImageView(frame: scrollView.frame, image: modifiedImage)
    }
    
    private func setDefaultSize() {
        let decider = UserDefaults.standard.bool(forKey: "defaultImageSizeIsPortrait")
        
        if (decider) {
            makeEditorRectangular()
        } else {
            makeEditorSquare()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        get { return true }
    }
}

extension PhotoEditorViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return primaryImageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        UserDefaults.standard.set(scale, forKey: "defaultScrollViewScale")
    }
}
