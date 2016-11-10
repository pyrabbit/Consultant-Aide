//
//  EditorViewController+NSFetchedResultsControllerDelegate.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 11/9/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import UIKit
import CoreData

extension EditorViewController: NSFetchedResultsControllerDelegate {
    func initializeLabels() {
        let fetchRequest = NSFetchRequest<SavedLabel>(entityName: "SavedLabel")
        var fetchedLabels: [SavedLabel]
        
        do {
            fetchedLabels = try context.fetch(fetchRequest)
        } catch {
            print("Unable to fetch saved labels")
            return
        }
        
        for label in fetchedLabels {
            guard let name = label.name else {
                print("Saved label name was null")
                return
            }
            
            let styleView = StyleView(style: name, price: label.price, sizes: label.sizes)
            styleView.containWithin(view: containerView)
            labels.append(styleView)
            containerView.addSubview(styleView)
        }
    }

}
