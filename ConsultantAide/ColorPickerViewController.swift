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
    @IBOutlet weak var redValueLabel: UILabel!
    @IBOutlet weak var greenValueLabel: UILabel!
    @IBOutlet weak var blueValueLabel: UILabel!
    @IBOutlet weak var alphaValueLabel: UILabel!
    
    var selectedColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    
    @IBAction func sliderChanged() {
        selectedColor = UIColor(red: CGFloat(red.value),
                                green: CGFloat(green.value),
                                blue: CGFloat(blue.value),
                                alpha: CGFloat(alpha.value))
        
        preview.backgroundColor = selectedColor
        
        redValueLabel.text = String(Int(red.value * 255))
        greenValueLabel.text = String(Int(green.value * 255))
        blueValueLabel.text = String(Int(blue.value * 255))
        alphaValueLabel.text = String.init(format: "%.2f", alpha.value)
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
        
        redValueLabel.text = String(Int(red.value * 255))
        greenValueLabel.text = String(Int(green.value * 255))
        blueValueLabel.text = String(Int(blue.value * 255))
        alphaValueLabel.text = String.init(format: "%.2f", alpha.value)
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

}
