//
//  PhotoEditorViewController.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 12/10/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import UIKit

class PhotoEditorViewController: UIViewController {
    
    var scrollView: UIScrollView!
    var primaryImageView: UIImageView!
    var selectedImage: UIImage?
    var modifiedImage: UIImage?
    
    @IBOutlet weak var squareButton: UIButton!
    @IBOutlet weak var portraitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let size = view.bounds.width
        let rect = CGRect(x: 0, y: 20, width: size, height: size)
        
        scrollView = UIScrollView(frame: rect)
        primaryImageView = UIImageView(frame: rect)
        primaryImageView.image = selectedImage
        primaryImageView.contentMode = .scaleAspectFit
        scrollView.addSubview(primaryImageView)
        scrollView.isUserInteractionEnabled = true
        scrollView.delegate = self
        scrollView.backgroundColor = .lightGray
        automaticallyAdjustsScrollViewInsets = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0

        if let scale = UserDefaults.standard.value(forKey: "defaultScrollViewScale") as? CGFloat {
            scrollView.setZoomScale(scale, animated: true)
        }
        
        setDefaultSize()
        view.addSubview(scrollView)
    }

    @IBAction func cancel(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func makeEditorRectangular() {
        portraitButton.isEnabled = false
        squareButton.isEnabled = true
        UserDefaults.standard.set(true, forKey: "defaultImageSizeIsPortrait")
        
        UIView.animate(withDuration: 0.25,
                       animations: {
                        let rect = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.scrollView.frame.height + (self.scrollView.frame.height*0.35))
                        self.scrollView.frame = rect
        })
    }
    
    @IBAction func makeEditorSquare() {
        squareButton.isEnabled = false
        portraitButton.isEnabled = true
        UserDefaults.standard.set(false, forKey: "defaultImageSizeIsPortrait")
        
        UIView.animate(withDuration: 0.25,
                       animations: {
                        let rect = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.width)
                        self.scrollView.frame = rect
        })
    }
    
    @IBAction func finishedEditing(_ sender: Any) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            let scale = image.scale
            
            if let ciImageConversion = CIImage(image: image) {
                let context = CIContext(options: nil)
                
                if let newCGImage = context.createCGImage(ciImageConversion, from: ciImageConversion.extent) {
                    
                    let cropRect = CGRect(x: scrollView.frame.origin.x * scale,
                                          y: scrollView.frame.origin.y * scale,
                                          width: scrollView.frame.width * scale,
                                          height: scrollView.frame.height * scale)
                    
                    if let croppedImage = newCGImage.cropping(to: cropRect) {
                        self.modifiedImage = UIImage(cgImage: croppedImage)
                    }
                }
            }
        }
        
        UIGraphicsEndImageContext()
        performSegue(withIdentifier: "segueToLabelEditor", sender: nil)
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
