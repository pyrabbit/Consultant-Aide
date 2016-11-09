//
//  EditorViewController+CustomLabelView.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 11/8/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import UIKit

extension EditorViewController: UITextFieldDelegate {
    
    @IBAction func cancel() {
        animateCustomLabelViewOut()
    }
    
    @IBAction func finishedWithCustomLabel() {
        guard let customLabel = customStyleView else {
            return
        }
        
        labels.append(customLabel)
        customLabel.containWithin(view: containerView)
        containerView.addSubview(customLabel)
        
        if let fullWidthLabels = UserDefaults.standard.value(forKey: "fullWidthLabels") as? Bool {
            if fullWidthLabels {
                makeLabelsWide()
            }
        }
        
        animateCustomLabelViewOut()
    }
    
    @IBAction func changeStyle() {
        guard let style = styleField.text else {
            customLabelViewFinishButton.isHidden = true
            return
        }
        
        var price: String?
        
        if let text = priceField.text {
            if text.isEmpty {
                price = nil
            } else {
                price = text
            }
        }
        
        var sizes: Set<String>?
        
        if let text = sizeField.text {
            if text.isEmpty {
                sizes = nil
            } else {
                sizes = [text]
            }
        }
        
        customStyleView = StyleView(style: style, price: price, sizes: sizes)
        customLabelViewFinishButton.isHidden = false
    }
    
    @IBAction func animateCustomLabelViewIn() {
        view.addSubview(customStyleLabelView)
        customStyleLabelView.center = view.center
        
        customStyleLabelView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        customStyleLabelView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.effectView.isHidden = false
            self.customStyleLabelView.alpha = 1
            self.photoSourceView.transform = CGAffineTransform.identity
        }
    }
    
    internal func animateCustomLabelViewOut() {
        UIView.animate(withDuration: 0.1, animations: {
            self.customStyleLabelView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.customStyleLabelView.alpha = 0.0
            self.effectView.isHidden = true
        }, completion: { (success:Bool) in
            self.customStyleLabelView.removeFromSuperview()
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        styleField.resignFirstResponder()
        priceField.resignFirstResponder()
        sizeField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
