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
        
        if var filters = UserDefaults.standard.value(forKey: "styleFilters") as? [String] {
            if !(filters.contains("Custom")) {
                filters.append("Custom")
                UserDefaults.standard.set(filters, forKey: "styleFilters")
            }
            
            if !(filterView.brands.contains("Custom")) {
                filterView.brands.append("Custom")
                filterView.brands = filterView.brands.sorted()
                filterView.tableView.reloadData()
            }
            
            tableView.reloadData()
        }
        
        tableView.reloadData()
    }
}
