//
//  SubtitleIdentifiable.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 20.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import Foundation
import CoreData

extension Subtitle: Identifiable {
    public typealias ID = NSManagedObjectID
    public var id: NSManagedObjectID {
        self.objectID
    }
}
