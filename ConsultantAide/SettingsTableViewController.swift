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
    @IBOutlet weak var defaultCollageSize: UISlider!
    @IBOutlet weak var defaultSecondaryFontSize: UISlider!
    @IBOutlet weak var fullWidthLabels: UISwitch!
    @IBOutlet weak var mapPrice: UISwitch!
    
    var colorFor = ""
    var color: UIColor?

    @IBAction func setPrimaryFontSize() {
        UserDefaults.standard.set(defaultFontSize.value, forKey: "fontSize")
    }
    
    @IBAction func setSecondaryFontSize() {
        UserDefaults.standard.set(defaultSecondaryFontSize.value, forKey: "secondaryFontSize")
    }
    
    @IBAction func setCollageSize() {
        UserDefaults.standard.set(defaultCollageSize.value, forKey: "collageSize")
    }
    
    @IBAction func toggleFullWidthLabels() {
        UserDefaults.standard.set(fullWidthLabels.isOn, forKey: "fullWidthLabels")
    }
    
    @IBAction func toggleMapPrice() {
        UserDefaults.standard.set(mapPrice.isOn, forKey: "mapPrice")
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
            colorFor = "secondaryFont"
            color = secondaryFontColor.backgroundColor
            performSegue(withIdentifier: "segueToColorPicker", sender: self)
        case 4:
            performSegue(withIdentifier: "segueToFontPicker", sender: self)
        default:
            print("Some other path was selected.")
        }
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
        
        if let size = UserDefaults.standard.value(forKey: "collageSize") as? Float {
            defaultSecondaryFontSize.value = size
        }
        
        if let decider = UserDefaults.standard.value(forKey: "fullWidthLabels") as? Bool {
            fullWidthLabels.isOn = decider
        }
        
        if let decider = UserDefaults.standard.value(forKey: "mapPrice") as? Bool {
            mapPrice.isOn = decider
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
