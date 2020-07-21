//
//  CoreDataStack.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 17.07.20.
//  Copyright © 2020 Michael Seeberger.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import CoreData

class CoreDataStack {
    let persistentStoreCoordinator: NSPersistentStoreCoordinator
    let mainManagedObjectContext: NSManagedObjectContext
    
    static var managedObjectModel: NSManagedObjectModel = {
        guard let objectModelFile = Bundle.main.url(forResource: "Document", withExtension: "momd") else {
            fatalError("Could not find the data model")
        }
        guard let mom: NSManagedObjectModel = NSManagedObjectModel(contentsOf: objectModelFile) else {
            fatalError("Could not load the data model from file: \(objectModelFile)")
        }
        
        return mom
    }()
    
    required init(mainManagedObjectContext: NSManagedObjectContext? = nil) {
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: CoreDataStack.managedObjectModel)
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            fatalError("Could not create a persistent in memory store: \(error)")
        }
        
        let moc: NSManagedObjectContext!
        if mainManagedObjectContext == nil {
            moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        } else {
            moc = mainManagedObjectContext
        }
        moc.persistentStoreCoordinator = persistentStoreCoordinator
        self.mainManagedObjectContext = moc
    }
    
    func createBackgroundContext() -> NSManagedObjectContext {
        let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return backgroundContext
    }
    
    /**
     Save changes of context. If an error occurs, `false` is returned. On success, `true` is returned
     */
    func save(backgroundContext: NSManagedObjectContext? = nil) -> Bool {
        let context = backgroundContext ?? mainManagedObjectContext
        guard context.hasChanges else { return true }
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save changes \(error), \(error.userInfo)")
            return false
        }
        
        return true
    }
    
    /**
     * Replaces the current in memory store with a new one. If no persistent store exists, one will be created.
     */
    func resetStore() throws {
        if persistentStoreCoordinator.persistentStores.count > 0 {
            try persistentStoreCoordinator.remove(persistentStoreCoordinator.persistentStores[0])
        }
        
        try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        mainManagedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
    }
}
