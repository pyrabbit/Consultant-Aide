//
//  FontViewController.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 11/2/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import UIKit

class FontViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var fonts: [String] = UIFont.familyNames
    var selectedFont: String?
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fonts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FontCell", for: indexPath) as? FontTableViewCell {
            cell.primaryLabel.text = fonts[indexPath.row]
            
            if let font = UIFont.init(name: fonts[indexPath.row], size: 22.0) {
                cell.primaryLabel.font = font
            }
            
            return cell
        } else {
            return FontTableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FontTableViewCell {
            if let font = cell.primaryLabel.text {
                selectedFont = font
                performSegue(withIdentifier: "unwindFromFontPicker", sender: self)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        for (index,font) in fonts.enumerated() {
            if (font == "Bodoni Ornaments") {
                fonts.remove(at: index)
            }
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
}
