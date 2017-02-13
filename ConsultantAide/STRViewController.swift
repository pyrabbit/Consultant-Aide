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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func cancel(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func authorize(_ sender: Any) {
        strService.authorize()
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
}
