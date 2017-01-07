//
//  SavedLabel+CoreDataProperties.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 11/9/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import Foundation
import CoreData


extension SavedLabel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedLabel> {
        return NSFetchRequest<SavedLabel>(entityName: "SavedLabel");
    }

    @NSManaged public var sizes: [String]?
    @NSManaged public var price: Float
    @NSManaged public var name: String
    @NSManaged public var brand: String?
    @NSManaged public var xPos: Int16
    @NSManaged public var yPos: Int16
    @NSManaged public var forKids: Bool
}
