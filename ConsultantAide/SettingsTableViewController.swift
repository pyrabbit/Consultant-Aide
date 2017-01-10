//
//  SettingsTableViewController.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 11/2/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var primaryColor: UIView!
    @IBOutlet weak var primaryFontColor: UIView!
    @IBOutlet weak var secondaryColor: UIView!
    @IBOutlet weak var secondaryFontColor: UIView!
    @IBOutlet weak var defaultFont: UILabel!
    @IBOutlet weak var defaultFontSize: UISlider!
    @IBOutlet weak var defaultSecondaryFontSize: UISlider!
    @IBOutlet weak var defaultCollageSize: UISlider!
    @IBOutlet weak var fullWidthLabels: UISwitch!
    @IBOutlet weak var mapPrice: UISwitch!
    @IBOutlet weak var watermarkColor: UIView!
    @IBOutlet weak var watermarkFontColor: UIView!
    @IBOutlet weak var watermarkImage: UIImageView!
    @IBOutlet weak var watermarkTransparency: UISlider!
    @IBOutlet weak var watermarkToggle: UISwitch!
    @IBOutlet weak var watermarkTextLabel: UILabel!
    @IBOutlet weak var watermarkImageToggle: UISwitch!
    @IBOutlet weak var watermarkFontSize: UISlider!
    
    var colorFor = ""
    var color: UIColor?

    @IBAction func setPrimaryFontSize() {
        UserDefaults.standard.set(defaultFontSize.value, forKey: "fontSize")
    }
    
    @IBAction func setSecondaryFontSize() {
        UserDefaults.standard.set(defaultSecondaryFontSize.value, forKey: "secondaryFontSize")
    }
    
    @IBAction func toggleFullWidthLabels() {
        UserDefaults.standard.set(fullWidthLabels.isOn, forKey: "fullWidthLabels")
    }
    
    @IBAction func toggleMapPrice() {
        UserDefaults.standard.set(mapPrice.isOn, forKey: "mapPrice")
    }
    
    @IBAction func setWatermarkTransparency() {
        UserDefaults.standard.set(watermarkTransparency.value, forKey: "watermarkTransparency")
    }
    
    @IBAction func toggleWatermark() {
        UserDefaults.standard.set(watermarkToggle.isOn, forKey: "watermark")
    }

    @IBAction func toggleWatermarkImage() {
        UserDefaults.standard.set(watermarkImageToggle.isOn, forKey: "watermarkImage")
    }
    
    @IBAction func setDefaultCollageSize() {
        UserDefaults.standard.set(defaultCollageSize.value, forKey: "defaultCollageSize")
    }
    
    @IBAction func setWatermarkFontSize() {
        UserDefaults.standard.set(watermarkFontSize.value, forKey: "watermarkFontSize")
    }
    
    @IBAction func unwindFromColorPicker(segue: UIStoryboardSegue) {
        if let selectedColor = (segue.source as? ColorPickerViewController)?.selectedColor {
            switch colorFor {
            case "primary":
                primaryColor.backgroundColor = selectedColor
                UserDefaults.standard.setColor(color: selectedColor, forKey: "primary")
            case "primaryFont":
                primaryFontColor.backgroundColor = selectedColor
                UserDefaults.standard.setColor(color: selectedColor, forKey: "primaryFont")
            case "secondary":
                secondaryColor.backgroundColor = selectedColor
                UserDefaults.standard.setColor(color: selectedColor, forKey: "secondary")
            case "secondaryFontColor":
                secondaryFontColor.backgroundColor = selectedColor
                UserDefaults.standard.setColor(color: selectedColor, forKey: "secondaryFont")
            case "watermarkColor":
                watermarkColor.backgroundColor = selectedColor
                UserDefaults.standard.setColor(color: selectedColor, forKey: "watermarkColor")
            case "watermarkFontColor":
                watermarkFontColor.backgroundColor = selectedColor
                UserDefaults.standard.setColor(color: selectedColor, forKey: "watermarkFontColor")
            default:
                print("Color is for unknown")
            }
        }
    }
    
    @IBAction func unwindFromFontPicker(segue: UIStoryboardSegue) {
        if let selectedFont = (segue.source as? FontViewController)?.selectedFont {
            defaultFont.text = selectedFont
            UserDefaults.standard.set(selectedFont, forKey: "defaultFont")
        }
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            colorFor = "primary"
            color = primaryColor.backgroundColor
            performSegue(withIdentifier: "segueToColorPicker", sender: self)
        case 1:
            colorFor = "primaryFont"
            color = primaryFontColor.backgroundColor
            performSegue(withIdentifier: "segueToColorPicker", sender: self)
        case 2:
            colorFor = "secondary"
            color = secondaryColor.backgroundColor
            performSegue(withIdentifier: "segueToColorPicker", sender: self)
        case 3:
            colorFor = "secondaryFontColor"
            color = secondaryFontColor.backgroundColor
            performSegue(withIdentifier: "segueToColorPicker", sender: self)
        case 4:
            performSegue(withIdentifier: "segueToFontPicker", sender: self)
        case 11:
            showWatermarkAlert()
        case 13:
            colorFor = "watermarkColor"
            color = watermarkColor.backgroundColor
            performSegue(withIdentifier: "segueToColorPicker", sender: self)
        case 14:
            colorFor = "watermarkFontColor"
            color = watermarkFontColor.backgroundColor
            performSegue(withIdentifier: "segueToColorPicker", sender: self)
        case 16:
            presentPhotoLibraryController()
        default:
            print("Some other path was selected.")
        }

    }
    
    func showWatermarkAlert() {
        let alert = UIAlertController(title: "Watermark", message: "Enter any additional information to be displayed on the photo.", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { (textfield) -> Void in
            if let watermark = UserDefaults.standard.value(forKey: "watermarkText") {
                textfield.text = watermark as? String
            } else {
                textfield.text = ""
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            
            guard let text = textField.text else {
                alert.dismiss(animated: true, completion: nil)
                return
            }
            
            UserDefaults.standard.set(text, forKey: "watermarkText")
            self.watermarkTextLabel.text = text
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let savedColor = UserDefaults.standard.colorForKey(key: "primary") {
            primaryColor.backgroundColor = savedColor
        }
        
        if let savedColor = UserDefaults.standard.colorForKey(key: "primaryFont") {
            primaryFontColor.backgroundColor = savedColor
        }
        
        if let savedColor = UserDefaults.standard.colorForKey(key: "secondary") {
            secondaryColor.backgroundColor = savedColor
        }
        
        if let savedColor = UserDefaults.standard.colorForKey(key: "secondaryFont") {
            secondaryFontColor.backgroundColor = savedColor
        }
        
        if let font = UserDefaults.standard.value(forKey: "defaultFont") as? String {
            defaultFont.text = font
        }
        
        if let size = UserDefaults.standard.value(forKey: "fontSize") as? Float {
            defaultFontSize.value = size
        }
        
        if let size = UserDefaults.standard.value(forKey: "secondaryFontSize") as? Float {
            defaultSecondaryFontSize.value = size
        }
        
        if let size = UserDefaults.standard.value(forKey: "defaultCollageSize") as? Float {
            defaultCollageSize.value = size
        }
        
        if let decider = UserDefaults.standard.value(forKey: "fullWidthLabels") as? Bool {
            fullWidthLabels.isOn = decider
        }
        
        if let decider = UserDefaults.standard.value(forKey: "mapPrice") as? Bool {
            mapPrice.isOn = decider
        }
        
        if let decider = UserDefaults.standard.value(forKey: "watermark") as? Bool {
            watermarkToggle.isOn = decider
        }
        
        if let text = UserDefaults.standard.value(forKey: "watermarkText") as? String {
            watermarkTextLabel.text = text
        }
        
        if let size = UserDefaults.standard.value(forKey: "watermarkFontSize") as? Float {
            watermarkFontSize.value = size
        }
        
        if let savedColor = UserDefaults.standard.colorForKey(key: "watermarkColor") {
            watermarkColor.backgroundColor = savedColor
        }
        
        if let savedColor = UserDefaults.standard.colorForKey(key: "watermarkFontColor") {
            watermarkFontColor.backgroundColor = savedColor
        }
        
        if let decider = UserDefaults.standard.value(forKey: "watermarkImage") as? Bool {
            watermarkImageToggle.isOn = decider
        }
        
        if let size = UserDefaults.standard.value(forKey: "watermarkTransparency") as? Float {
            watermarkTransparency.value = size
        }
        
        
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("watermark.png").path
        
        if FileManager.default.fileExists(atPath: filePath) {
            if let watermark = UIImage(contentsOfFile: filePath) {
                watermarkImage.image = watermark
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "segueToColorPicker" {
            if let selectedColor = color {
                let vc = segue.destination as? ColorPickerViewController
                vc?.selectedColor = selectedColor
            }
        }
    }
    
}
