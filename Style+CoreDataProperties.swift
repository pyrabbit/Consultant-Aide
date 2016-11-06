//
//  Style+CoreDataProperties.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 11/6/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import Foundation
import CoreData


extension Style {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Style> {
        return NSFetchRequest<Style>(entityName: "Style");
    }

    @NSManaged public var sizes: [String]?
    @NSManaged public var name: String?
    @NSManaged public var brand: String?

}
