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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var customStyleView: CustomStyleFormView!
    @IBOutlet var filterView: FilterView!
    @IBOutlet weak var addToEditorBtn: UIBarButtonItem!
    
    var styles = [Style]()
    var filteredStyles = [Style]()
    var isSearching = false
    var modalBackground: UIView?
    var selectedStyle: SavedLabel?
    
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        view.addGestureRecognizer(tap)
    }   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let stylesFromDevice = StyleService.fetchAll() {
            styles = stylesFromDevice
        }
        
        filterView.brands = Set(styles.flatMap { $0.brand }).sorted()
        
        if let filters = UserDefaults.standard.value(forKey: "styleFilters") as? [String] {
            filterView.savedFilters = filters
            filterView.filters = Set(filters)
            
            if filters.count > 0 {
                print("Filtering styles")
                styles = styles.filter { filters.contains($0.brand) }
            }
        }
    }

    @IBAction func addStyle(_ sender: Any) {
        addBackgroundModal()
        
        let xPos = view.center.x - (customStyleView.frame.width/2)
        
        let rect = CGRect(x: xPos, y: view.bounds.maxY + customStyleView.frame.height,
                          width: customStyleView.frame.width,
                          height: customStyleView.frame.height)
        
        customStyleView.frame = rect
        customStyleView.layer.cornerRadius = 5
        customStyleView.layer.masksToBounds = true
        customStyleView.delegate = self
        
        view.addSubview(customStyleView)
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: [], animations: {
            let rect = CGRect(x: xPos, y: 20,
                              width: self.customStyleView.frame.width,
                              height: self.customStyleView.frame.height)
            
            self.customStyleView.frame = rect
        })
    }
    

    @IBAction func selectStyleFitlers(_ sender: Any) {
        addBackgroundModal()
        
        let xPos = view.center.x - (filterView.frame.width/2)
        
        let rect = CGRect(x: xPos, y: view.bounds.maxY + filterView.frame.height,
                          width: filterView.frame.width,
                          height: filterView.frame.height)
        
        filterView.frame = rect
        filterView.layer.cornerRadius = 5
        filterView.layer.masksToBounds = true
        filterView.delegate = self
        
        view.addSubview(filterView)
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: [], animations: {
            let rect = CGRect(x: xPos, y: 20,
                              width: self.filterView.frame.width,
                              height: self.filterView.frame.height)
            
            self.filterView.frame = rect
        })
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToEditor(_ sender: Any) {
        guard let path = tableView.indexPathForSelectedRow else {
            return
        }
        
        guard let styleCell = tableView.cellForRow(at: path) as? StyleTableViewCell else {
            return
        }
        
        guard let sizeCollection = styleCell.collectionView else {
            return
        }
        
        guard let sizePaths = sizeCollection.indexPathsForSelectedItems else {
            return
        }
        
        var sizes = [String]()
        
        for path in sizePaths {
            guard let cell = sizeCollection.cellForItem(at: path) as? SizeCollectionViewCell else {
                continue
            }
            
            guard let sizeText = cell.label.text else {
                continue
            }
            
            sizes.append(sizeText)
        }
        
        let style = SavedLabel(context: context)
        
        style.name = styleCell.style.name
        style.brand = styleCell.style.brand
        style.price = styleCell.style.price
        style.sizes = sizes
        style.forKids = styleCell.style.forKids
        
        ad.saveContext()
        selectedStyle = style
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    private func addBackgroundModal() {
        modalBackground = UIView(frame: view.bounds)
        modalBackground?.backgroundColor = .black
        modalBackground?.alpha = 0.8
        
        if let bg = modalBackground {
            view.addSubview(bg)
        }
        
    }
    
    func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
}
