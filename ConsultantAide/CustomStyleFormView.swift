//
//  CustomStyleFormView.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 12/27/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import Foundation
import UIKit

class CustomStyleFormView: UIView {

    @IBOutlet weak var styleTextInput: UITextField!
    @IBOutlet weak var priceTextInput: UITextField!
    @IBOutlet weak var sizeTextInput: UITextField!
    @IBOutlet weak var finishedButton: UIButton!
    @IBOutlet weak var forKidsSwitch: UISwitch!
    
    var delegate: CustomStyleFormDelegate?
    var customName: String?
    var customPrice: Float = 0.0
    var customSizes: [String]?

    @IBAction func cancel(_ sender: Any) {
        delegate?.didCancel(view: self)
        resetForm()
    }
    
    @IBAction func finished(_ sender: Any) {
        guard let name = customName else {
            return
        }
        
        StyleService.saveCustomStyle(name: name, price: customPrice, sizes: customSizes, forKids: forKidsSwitch.isOn)
        resetForm()
        delegate?.didFinish(view: self)
    }
    
    @IBAction func userDidEdit(_ sender: Any) {
        guard let name = styleTextInput.text, name.characters.count > 0 else {
            finishedButton.isHidden = true
            return
        }
        
        var price: Float = 0.0
        
        if let text = priceTextInput.text {
            if text.isEmpty {
                price = 0.0
            } else {
                if let value = Float(text) {
                    price = value
                }
            }
        }
        
        var sizes = [String]()
        
        if let text = sizeTextInput.text {
            if text.isEmpty {
                sizes = []
            } else {
                sizes = text.components(separatedBy: ",")
                
                for (index,size) in sizes.enumerated() {
                    sizes[index] = size.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
        }
        
        customName = name
        customPrice = price
        customSizes = sizes

        finishedButton.isHidden = false
    }
    
    private func resetForm() {
        styleTextInput.text = nil
        priceTextInput.text = nil
        sizeTextInput.text = nil
        customName = nil
        customPrice = 0.0
        customSizes = nil
        forKidsSwitch.isOn = false
    }
    
}
