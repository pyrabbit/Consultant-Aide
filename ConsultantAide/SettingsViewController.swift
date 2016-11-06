//
//  SettingsViewController.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 11/2/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBAction func returnToEditor(sender: UIButton) {
        performSegue(withIdentifier: "unwindToEditor", sender: self)
    }
     
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

}
