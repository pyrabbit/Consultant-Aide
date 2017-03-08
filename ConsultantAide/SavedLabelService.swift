//
//  SavedLabelService.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 1/7/17.
//  Copyright © 2017 Matthew Orahood. All rights reserved.
//

import Foundation
import CoreData

class SavedLabelService {
    var delegate: SavedLabelServiceDelegate?
    
    func fetch() {
        DispatchQueue.main.async {
            let fetchRequest = NSFetchRequest<SavedLabel>(entityName: "SavedLabel")
            var fetchedLabels: [SavedLabel]
            
            do {
                let moc = ad.mainManagedObjectContext
                fetchedLabels = try moc.fetch(fetchRequest)
                self.delegate?.didFetch(savedLabels: fetchedLabels)
            } catch {
                print("Unable to fetch saved labels")
                self.delegate?.didFetch(savedLabels: nil)
            }
        }
    }

}

protocol SavedLabelServiceDelegate {
    func didFetch(savedLabels: [SavedLabel]?)
}
