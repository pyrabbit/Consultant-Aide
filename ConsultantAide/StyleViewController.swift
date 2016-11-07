//
//  StylesViewController.swift
//  ConsultantAide
//
//  Created by Matt Orahood on 8/19/16.
//  Copyright © 2016 Matt Orahood. All rights reserved.
//
import UIKit
import CoreData

class StyleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deselectAllButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    /*
     // MARK: - Instance Variable Definitions
     */
    
    var styleResultsController: NSFetchedResultsController<Style>!
    var selectedPaths: [IndexPath:[IndexPath]] = [:]
    var selectedItems: [String:Set<String>] = [:]
    
    /*
     // MARK: - Initialization
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadStyles()
        self.tableView.layer.cornerRadius = 5
        self.tableView.layer.masksToBounds = true
    }
    
    /*
     // MARK: - TableView Configuration
     */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = styleResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = styleResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StyleCell", for: indexPath) as? StyleTableViewCell {
            configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            return cell
        } else {
            return StyleTableViewCell()
        }
    }
    
    func configureCell(cell: StyleTableViewCell, indexPath: NSIndexPath) {
        let style = styleResultsController.object(at: indexPath as IndexPath)
        if let name = style.name {
            cell.configureCell(primaryText: name)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let styleTableViewCell = cell as? StyleTableViewCell else { return }
        styleTableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        
        if cell.isSelected {
            cell.setSelected(true, animated: true)
        } else {
            cell.setSelected(false, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? StyleTableViewCell {
            selectedPaths.removeValue(forKey: indexPath)
            
            if let style = cell.primaryLabel.text {
                selectedItems.removeValue(forKey: style)
            }
            print("selected: \(selectedItems)")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? StyleTableViewCell {
            selectedPaths[indexPath] = []
            
            if let style = cell.primaryLabel.text {
                selectedItems[style] = []
            }
            print("selected: \(selectedItems)")
        }
    }
    
    func loadStyles() {
        let fetchRequest: NSFetchRequest<Style> = Style.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.styleResultsController = controller
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    @IBAction func deselectAll() {
        for (style,_) in selectedPaths {
            tableView.deselectRow(at: style, animated: false)
        }
        selectedPaths = [:]
        print(selectedPaths)
    }
    
    @IBAction func saveStyles() {
        UserDefaults.standard.setStyles(styles: selectedItems, forKey: "selectedStyles")
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelChanges() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
}

/*
 // MARK: - Collection Extension
 */

extension StyleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let indexPath = IndexPath(row: collectionView.tag, section: 0)
        let style = styleResultsController.object(at: indexPath)
        
        if let sizes = style.sizes {
            return sizes.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCollectionViewCell", for: indexPath) as? SizeCollectionViewCell {
            
            let selectedView = UIView()
            selectedView.backgroundColor = ColorPalette.Accent
            cell.selectedBackgroundView = selectedView
            cell.label.textColor = UIColor.white
            
            let path = IndexPath(row: collectionView.tag, section: 0)
            let style = styleResultsController.object(at: path)
            
            if let sizes = style.sizes {
                
                let validIndex = sizes.indices.contains(indexPath.item)
                
                if validIndex {
                    cell.configureCell(labelText: sizes[indexPath.item])
                } else {
                    print("OUT OF RANGE: ", style, sizes[indexPath.item])
                    cell.configureCell(labelText: "")
                }
            }
            
            let index = IndexPath(row: collectionView.tag, section: 0)
            
            if let selectedCells = selectedPaths[index] {
                for selectedCell in selectedCells {
                    collectionView.selectItem(at: selectedCell, animated: false, scrollPosition: .init(rawValue: 0))
                }
            }
            
            return cell
        } else {
            return SizeCollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = IndexPath(row: collectionView.tag, section: 0)
        if let cell = tableView.cellForRow(at: index) as? StyleTableViewCell {
            if (!cell.isSelected) {
                tableView.selectRow(at: index, animated: false, scrollPosition: .none)
            }
            
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            selectedPaths[index] = collectionView.indexPathsForSelectedItems
            
            if let style = cell.primaryLabel.text {
                if (selectedItems.index(forKey: style) == nil) { selectedItems[style] = Set<String>() }
                if let paths = collectionView.indexPathsForSelectedItems {
                    for path in paths {
                        if let sizeCell = collectionView.cellForItem(at: path) as? SizeCollectionViewCell {
                            if let size = sizeCell.label.text {
                                selectedItems[style]?.insert(size)
                            }
                        }
                    }
                }
            }
            
        }
        
        print("selected: \(selectedItems)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let index = IndexPath(row: collectionView.tag, section: 0)
        selectedPaths[index] = collectionView.indexPathsForSelectedItems
        
        if let cell = tableView.cellForRow(at: index) as? StyleTableViewCell {
            if let style = cell.primaryLabel.text {
                if let sizeCell = collectionView.cellForItem(at: indexPath) as? SizeCollectionViewCell {
                    if let size = sizeCell.label.text {
                        _ = selectedItems[style]?.remove(size)
                    }
                }
            }
        }
        
        print("selected: \(selectedItems)")
    }
    
}
