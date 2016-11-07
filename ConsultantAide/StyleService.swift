//
//  StylesService.swift
//  ConsultantAide
//
//  Created by Matt Orahood on 9/16/16.
//  Copyright © 2016 Matt Orahood. All rights reserved.
//
import UIKit
import Foundation
import CoreData

class StyleService {
    
    static func updateFromServer() {
        let baseURL = "https://consultant-aide.firebaseio.com/brands.json"
        let url = URL(string: baseURL)!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                if let error = error {
                    print(error)
                }
                return
            }
            
            guard let data = data else {
                print("There was no data in the request.")
                return
            }
            
            if let brandData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, AnyObject> {
                
                let didRemoveStylesFromDevice = removedStylesFromDevice()
                
                if didRemoveStylesFromDevice {
                    updateStyles(brandData)
                }
            }
            }.resume()
    }
    
    private static func updateStyles(_ data: Dictionary<String, AnyObject>) {
        for (brand, items) in data  {
            for item in items as! [Dictionary<String, AnyObject>] {
                let style = Style(context: context)
                style.brand = brand
                
                if let name = item["name"] as? String {
                    print("Updating from server: ", brand, name)
                    style.name = name
                }
                
                if let sizes = item["sizes"] as? [String] {
                    style.sizes = sizes
                }
            }
            
            ad.saveContext()
        }
    }
    
    private static func removedStylesFromDevice() -> Bool {
        let fetchRequest: NSFetchRequest<Style> = Style.fetchRequest()
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
}
