//
//  StyleViewController+CustomStyleForm.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 12/27/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import Foundation

extension StyleViewController: CustomStyleFormDelegate {
    func didCancel(view: CustomStyleFormView) {
        modalBackground?.removeFromSuperview()
        customStyleView.removeFromSuperview()
    }
    
    func didFinish(view: CustomStyleFormView) {
        modalBackground?.removeFromSuperview()
        customStyleView.removeFromSuperview()
        
        if let stylesFromDevice = StyleService.fetchAll() {
            styles = stylesFromDevice
        }
        
        tableView.reloadData()
    }
}
