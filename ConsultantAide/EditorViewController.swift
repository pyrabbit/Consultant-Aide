//
//  EditorViewController.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 11/2/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {

    @IBOutlet weak var container: UIView!
    
    @IBAction func unwindToEditor(segue: UIStoryboardSegue) {
        print("Unwinding back to editor")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("container size: \(container.frame.size)")
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

}
