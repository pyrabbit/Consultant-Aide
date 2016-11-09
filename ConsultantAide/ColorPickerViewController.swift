//
//  ColorPickerViewController.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 11/2/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {

    @IBOutlet weak var red: UISlider!
    @IBOutlet weak var green: UISlider!
    @IBOutlet weak var blue: UISlider!
    @IBOutlet weak var alpha: UISlider!
    @IBOutlet weak var preview: UIView!
    
    var selectedColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    
    @IBAction func sliderChanged() {
        selectedColor = UIColor(red: CGFloat(red.value),
                                green: CGFloat(green.value),
                                blue: CGFloat(blue.value),
                                alpha: CGFloat(alpha.value))
        
        preview.backgroundColor = selectedColor
    }
    
    @IBAction func saveColor(sender: UIButton) {
        performSegue(withIdentifier: "unwindFromColorPicker", sender: self)
    }
    
    @IBAction func cancel(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preview.backgroundColor = selectedColor
        
        var r: CGFloat = 0,
            g: CGFloat = 0,
            b: CGFloat = 0,
            a: CGFloat = 0
        
        selectedColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        red.value = Float(r)
        green.value = Float(g)
        blue.value = Float(b)
        alpha.value = Float(a)
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

}
