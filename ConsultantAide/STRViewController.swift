//
//  STRViewController.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 2/7/17.
//  Copyright © 2017 Matthew Orahood. All rights reserved.
//

import UIKit

class STRViewController: UIViewController {
    let strService = STRService()
    
    @IBOutlet weak var autoUploadSwitch: UISwitch!
    @IBOutlet weak var authorizeButton: UIButton!
    @IBOutlet weak var authorizeLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let decider = UserDefaults.standard.value(forKey: "strAutoUploadIsEnabled") as? Bool {
            autoUploadSwitch.isOn = decider
        }
        
        toggleAuthorizeVisibility()
    }
    
    func toggleAuthorizeVisibility() {
        strService.testAuthentication(completion: { success in
            if (success) {
                self.authorizeButton.isHidden = true
                self.authorizeLabel.isHidden = true
            } else {
                self.authorizeButton.isHidden = false
                self.authorizeLabel.isHidden = false
            }
        })
    }

    @IBAction func cancel(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func authorize(_ sender: Any) {
        authorizeButton.isHidden = true
        authorizeLabel.isHidden = true
        strService.authorize()
    }
    
    @IBAction func toggleAutoUpload(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "strAutoUploadIsEnabled")
    }

    @IBAction func visitSTRWebsite(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://shoptheroe.com")!)
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
}
