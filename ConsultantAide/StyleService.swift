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
        guard let url = URL(string: "https://consultant-aide.firebaseio.com/api-v2-1.json") else {
            return
        }
        
        fetchDataFromServer(url: url, completion: { data, success in
            if !(success) {
                updateFromDevice()
                return
            }
            
            updateDeviceWithData(data: data)
        })
    }
    
    static func fetchAll() -> [Style]? {
        let fetchRequest: NSFetchRequest<Style> = Style.fetchRequest()
        let brandSort = NSSortDescriptor(key: "brand", ascending: true)
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [brandSort,nameSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try controller.performFetch()
            return controller.fetchedObjects
        } catch {
            let error = error as NSError
            print("\(error)")
            return nil
        }
    }
    
    static func saveCustomStyle(name: String, price: Float = 0.0, sizes: [String]?, forKids: Bool) {
        let style = Style(context: context)
        style.brand = "Custom"
        style.name = name
        style.price = price
        style.sizes = sizes
        style.forKids = forKids
        style.styleId = UUID().uuidString
        ad.saveContext()
    }
    
    
    private static func fetchDataFromServer(url: URL, completion: @escaping (Dictionary<String, AnyObject>?, Bool) -> ()) {
        var serializedData: Dictionary<String, AnyObject>?
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("Error reaching server, check if app should load from device")
                completion(nil, false)
                return
            }
            
            guard let data = data else {
                print("There was no data in the request.")
                completion(nil, false)
                return
            }
            
            serializedData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, AnyObject>
            completion(serializedData, true)
        }.resume()
    }

    private static func updateFromDevice() {
        let fetchRequest: NSFetchRequest<Style> = Style.fetchRequest()
        let nameSort = NSSortDescriptor(key: "styleId", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.parent = context
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try controller.performFetch()
            
            if let items = controller.fetchedObjects {
                if items.count < 1 {
                    print("There was nothing in the CoreData database so we are going to load from device.")
                    
                    guard let path = Bundle.main.path(forResource: "api-v2.1-import", ofType: "json") else {
                        print("Could not load api-v2.1-import.json")
                        return
                    }

                    do {
                        let data = try NSData(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

                        guard let brandData = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? Dictionary<String, AnyObject> else {
                            print("Could not read api-v2.1-import.json into an json data object.")
                            return
                        }
                        
                        updateDeviceWithData(data: brandData)
                        
                    } catch {
                        print("Could not read api-v2.1-import.json into initialized Data object.")
                    }

                } else {
                    print("There is more than one CoreData record so we will skip updating from device for now.")
                }
            }
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    private static func findOrCreateBy(styleId: String, completion: @escaping (Style?, NSManagedObjectContext) -> ()) {
        let fetchRequest: NSFetchRequest<Style> = Style.fetchRequest()
        let styleIdPredicate = NSPredicate(format: "styleId like %@", styleId)
        let brandSort = NSSortDescriptor(key: "styleId", ascending: true)
        fetchRequest.sortDescriptors = [brandSort]
        
        fetchRequest.predicate = styleIdPredicate
        fetchRequest.fetchLimit = 1
        
        ad.persistentContainer.performBackgroundTask { context in
            let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            do {
                try controller.performFetch()
                
                if let results = controller.fetchedObjects {
                    if !(results.isEmpty) {
                        print("Found \(styleId)")
                        completion(results.first, context)
                    } else {
                        print("Creating \(styleId)")
                        let newStyleObject = Style(context: context)
                        newStyleObject.styleId = styleId
                        completion(newStyleObject, context)
                    }
                }
            } catch {
                let error = error as NSError
                print("\(error)")
            }
            
            completion(nil, context)
        }

    }
    
    private static func updateDeviceWithData(data: Dictionary<String, AnyObject>?) {
        guard let sourceData = data else {
            return
        }
        
        for (styleId, styleData) in sourceData {
            guard let data = styleData as? Dictionary<String, AnyObject> else {
                continue
            }
            
            updateDeviceWithData(data: data)
            
            findOrCreateBy(styleId: styleId, completion: { retrieved, context in
                guard let style = retrieved else {
                    return
                }
                
                if let brand = data["brand"] as? String {
                    style.brand = brand
                }
                
                if let name = data["name"] as? String {
                    style.name = name
                }
                
                if let sizes = data["sizes"] as? [String] {
                    style.sizes = sizes
                }
                
                if let price = data["price"] as? Float {
                    style.price = price
                }
                
                if let decider = data["forKids"] as? Bool {
                    style.forKids = decider
                }
                
                do {
                    try context.save()
                } catch {
                    print("Could not save style object!!!")
                }
                
            })
        }
    }
    
}
