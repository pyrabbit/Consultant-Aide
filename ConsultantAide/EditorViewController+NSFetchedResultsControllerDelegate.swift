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
            let styleView = StyleView(savedLabel: label)
            styleView.containWithin(view: containerView)
            styleView.moveToSavedPosition()
            
            labels.append(styleView)
            containerView.addSubview(styleView)
        }
    }

}
