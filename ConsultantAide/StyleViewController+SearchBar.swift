//
//  StyleViewController+SearchBar.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 12/22/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import Foundation
import UIKit

extension StyleViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            
            isSearching = false
            tableView.reloadData()
            
        } else {
            
            isSearching = true
            
            guard let downcased = searchBar.text?.lowercased() else {
                return
            }
            
            filteredStyles = styles.filter({ $0.name.lowercased().range(of: downcased) != nil })
            tableView.reloadData()
            
        }
    }
    
}
