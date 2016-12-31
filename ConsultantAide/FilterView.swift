//
//  FilterView.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 12/30/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import UIKit

class FilterView: UIView {
    @IBOutlet weak var tableView: UITableView!
    var filters = Set<String>()
    var brands = [String]()
    var delegate: FilterViewDelegate?
    
    @IBAction func finished(_ sender: Any) {
        delegate?.didSelectFilters(view: self, filters: filters)
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.didCancelFilter(view: self)
    }
}

protocol FilterViewDelegate {
    func didCancelFilter(view: FilterView)
    func didSelectFilters(view: FilterView, filters: Set<String>)
}

class FilterViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(_: selected, animated: animated)
        
        if (selected) {
            self.label.textColor = UIColor.white
        } else {
            self.label.textColor = ColorPalette.Primary
        }
    }
}

extension FilterView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brands.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterViewCell", for: indexPath) as? FilterViewCell else {
            return
        }
        
        let brand = brands[indexPath.row]
        
        if filters.contains(brand) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            cell.contentView.backgroundColor = ColorPalette.Primary
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FilterViewCell", for: indexPath) as? FilterViewCell {
            let brand = brands[indexPath.row]
            cell.label.text = brand
            
            return cell
        }
        
        return FilterViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FilterViewCell else {
            return
        }
        
        let brand = brands[indexPath.row]
        filters.insert(brand)

        cell.contentView.backgroundColor = ColorPalette.Primary
    }
    

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let brand = brands[indexPath.row]
        filters.remove(brand)
    }
    
}
