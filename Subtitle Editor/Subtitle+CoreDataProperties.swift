//
//  Subtitle+CoreDataProperties.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 05.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//
//

import Foundation
import CoreData


extension Subtitle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subtitle> {
        return NSFetchRequest<Subtitle>(entityName: "Subtitle")
    }

    @NSManaged public var content: String?
    @NSManaged public var startTime: NSDecimalNumber?
    @NSManaged public var duration: NSDecimalNumber?

}
