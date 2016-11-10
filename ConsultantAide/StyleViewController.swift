//
//  StylesViewController.swift
//  ConsultantAide
//
//  Created by Matt Orahood on 8/19/16.
//  Copyright © 2016 Matt Orahood. All rights reserved.
//
import UIKit
import CoreData

class StyleViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deselectAllButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    /*
     // MARK: - Instance Variable Definitions
     */
    
    var styleResultsController: NSFetchedResultsController<Style>!
    var selectedPaths: [IndexPath:[IndexPath]] = [:]
    var selectedItems: [String:Set<String>] = [:]
    var selectedStyles: [Style: Set<String>] = [:]
    
    
    /*
     // MARK: - Initialization
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadStyles()
        self.tableView.layer.cornerRadius = 5
        self.tableView.layer.masksToBounds = true
    }
    
    
    @IBAction func deselectAll() {
        for (style,_) in selectedPaths {
            tableView.deselectRow(at: style, animated: false)
        }
        
        selectedPaths = [:]
        selectedStyles = [:]
        
        print("deselected paths: \(selectedPaths)")
        print("deselected styles: \(selectedStyles)")
    }
    
    @IBAction func saveStyles() {
        if removeAllSavedLabels() {
            for (style,sizes) in selectedStyles {
                let savedLabel = SavedLabel(context: context)
                savedLabel.brand = style.brand
                savedLabel.name = style.name
                savedLabel.price = style.price
                savedLabel.sizes = Array(sizes)
            }
            
            ad.saveContext()
        }

        performSegue(withIdentifier: "unwindFromStylePicker", sender: self)
    }
    
    private func removeAllSavedLabels() -> Bool {
        let fetchRequest: NSFetchRequest<SavedLabel> = SavedLabel.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try controller.performFetch()
            
            if let items = controller.fetchedObjects {
                for item in items {
                    context.delete(item)
                }
            }
            
            ad.saveContext()
            
            return true
        } catch {
            let error = error as NSError
            print("\(error)")
            
            return false
        }
    }
    
    @IBAction func cancelChanges() {
        performSegue(withIdentifier: "unwindFromStylePicker", sender: self)
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
}
