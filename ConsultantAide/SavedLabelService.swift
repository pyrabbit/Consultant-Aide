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
        let fetchRequest = NSFetchRequest<SavedLabel>(entityName: "SavedLabel")
        var fetchedLabels: [SavedLabel]
        
        do {
            fetchedLabels = try context.fetch(fetchRequest)
            delegate?.didFetch(savedLabels: fetchedLabels)
        } catch {
            print("Unable to fetch saved labels")
            delegate?.didFetch(savedLabels: nil)
        }
    
    }
}

protocol SavedLabelServiceDelegate {
    func didFetch(savedLabels: [SavedLabel]?)
}
