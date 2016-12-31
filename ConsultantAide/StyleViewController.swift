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
    
    var styles = [Style]()
    var filteredStyles = [Style]()
    var isSearching = false
    var modalBackground: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let stylesFromDevice = StyleService.fetchAll() {
            styles = stylesFromDevice
        }
        
        filterView.brands = Set(styles.flatMap { $0.brand }).sorted()
        
        if let filters = UserDefaults.standard.value(forKey: "styleFilters") as? [String] {
            styles = styles.filter { filters.contains($0.brand) }
            tableView.reloadData()
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
    
    private func addBackgroundModal() {
        modalBackground = UIView(frame: view.bounds)
        modalBackground?.backgroundColor = .black
        modalBackground?.alpha = 0.8
        
        if let bg = modalBackground {
            view.addSubview(bg)
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
}
