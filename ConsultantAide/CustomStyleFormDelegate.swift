//
//  CustomStyleFormDelegate.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 12/27/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import Foundation

protocol CustomStyleFormDelegate {
    func didCancel(view: CustomStyleFormView)
    func didFinish(view: CustomStyleFormView)
}
