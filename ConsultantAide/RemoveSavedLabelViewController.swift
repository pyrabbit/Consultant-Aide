//
//  RemoveSavedLabelViewController.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 1/7/17.
//  Copyright © 2017 Matthew Orahood. All rights reserved.
//

import UIKit

class RemoveSavedLabelViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var labelService = SavedLabelService()
    var labels = [SavedLabel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        labelService.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        labelService.fetch()
    }
    
    @IBAction func back(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

    override var prefersStatusBarHidden: Bool {
        get { return true }
    }
    
}

extension RemoveSavedLabelViewController: SavedLabelServiceDelegate {
    func didFetch(savedLabels: [SavedLabel]?) {
        guard let data = savedLabels else {
            return
        }
        
        labels = data
        tableView.reloadData()
    }
}

extension RemoveSavedLabelViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RemoveStyleCell", for: indexPath) as? RemoveSavedLabelCell else {
            return RemoveSavedLabelCell()
        }
        
        cell.label.text = labels[indexPath.row].name
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency   
        let savedPrice = labels[indexPath.row].price
        if let  price = formatter.string(from: NSNumber(value: savedPrice)) {
            cell.price.text = "MAP \(price)"
        } else {
            cell.price.text = "N/A"
        }
        
        let sizes = labels[indexPath.row].sizes
        cell.sizes.text = sizes?.joined(separator: ", ")
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let savedLabel = labels[indexPath.row]
            let moc = ad.mainManagedObjectContext
            moc.delete(savedLabel)
            ad.saveMainContext()
            
            labels.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
}

class RemoveSavedLabelCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var sizes: UILabel!
}
