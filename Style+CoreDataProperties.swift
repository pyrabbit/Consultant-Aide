//
//  Style+CoreDataProperties.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 11/9/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import Foundation
import CoreData


extension Style {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Style> {
        return NSFetchRequest<Style>(entityName: "Style");
    }

    @NSManaged public var brand: String?
    @NSManaged public var name: String?
    @NSManaged public var sizes: [String]?
    @NSManaged public var price: Float

}
