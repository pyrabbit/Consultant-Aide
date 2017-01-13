//
//  StyleViewController+FilterView.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 12/31/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import Foundation

extension StyleViewController: FilterViewDelegate {
    func didSelectFilters(view: FilterView, filters: Set<String>) {
        if let stylesFromDevice = StyleService.fetchAll() {
            styles = stylesFromDevice
        }
        
        styles = styles.filter { filters.contains($0.brand) }
        tableView.reloadData()
        
        let filtersArray = Array(filters)
        UserDefaults.standard.set(filtersArray, forKey: "styleFilters")
        
        modalBackground?.removeFromSuperview()
        filterView.removeFromSuperview()
    }
    
    func didCancelFilter(view: FilterView) {
        modalBackground?.removeFromSuperview()
        filterView.removeFromSuperview()
    }
}
