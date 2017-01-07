//
//  CollageSourceView.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 1/7/17.
//  Copyright © 2017 Matthew Orahood. All rights reserved.
//

import UIKit

class CollageSourceView: UIView {

    var delegate: CollageSourceViewDelegate?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func cancel(_ sender: Any) {
        delegate?.didCancel(view: self)
    }
}

protocol CollageSourceViewDelegate {
    func didCancel(view: CollageSourceView)
}
