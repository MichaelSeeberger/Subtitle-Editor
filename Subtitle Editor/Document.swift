//
//  Document.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 05.07.20.
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

import Cocoa
import SwiftUI
import CoreData

class Document: NSDocument {
    var encoding: String.Encoding = .utf8
    let coreDataStack = CoreDataStack()
    
    override var undoManager: UndoManager? {
        get {
            coreDataStack.mainContext.undoManager
        }
        set {
            coreDataStack.mainContext.undoManager = newValue
        }
    }
    
    override class var autosavesInPlace: Bool {
        return false
    }
    
    override var isDocumentEdited: Bool {
        self.coreDataStack.mainContext.hasChanges
    }

    override func makeWindowControllers() {
        let contentView = Content().environment(\.managedObjectContext, self.coreDataStack.mainContext)

        // Create the window and set the content view.
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.contentView = NSHostingView(rootView: contentView)
        let windowController = NSWindowController(window: window)
        self.addWindowController(windowController)
        
        let didChangeKeys: [Notification.Name: Any?] = [
            .NSManagedObjectContextDidSave: coreDataStack.mainContext,
            .NSManagedObjectContextObjectsDidChange: coreDataStack.mainContext,
            .NSUndoManagerDidRedoChange: coreDataStack.mainContext.undoManager,
            .NSUndoManagerDidUndoChange: coreDataStack.mainContext.undoManager
        ]
        
        for (name, object) in didChangeKeys {
            NotificationCenter.default.addObserver(forName: name,
                                                   object: object,
                                                   queue: nil,
                                                   using: {_ in
                                                    self.windowControllers.first?.setDocumentEdited(self.isDocumentEdited)
            })
        }
    }
    
    override func save(_ sender: Any?) {
        super.save(sender)
        do {
            try coreDataStack.mainContext.save()
        } catch {
            NSLog("Could not save context. \(error): \((error as NSError).localizedDescription)")
        }
    }

    override func data(ofType typeName: String) throws -> Data {
        return try SubRipEncoder().encodeSubtitles(subtitles: orderedSubtitles(), using: .utf8)
    }
    
    override func read(from url: URL, ofType typeName: String) throws {
        enum ReadError: Error {
            case readError
        }
        
        let contents = try String(contentsOf: url, usedEncoding: &encoding)
        let decoder = SubRipDecoder()
        try decoder.decodeSubtitleString(contents: contents, generator: { Subtitle(context: coreDataStack.mainContext) })
        if !coreDataStack.save() {
            throw ReadError.readError
        }
    }
    
    private func orderedSubtitles() -> [Subtitle] {
        guard let entityName = Subtitle.entity().name else {
            fatalError("Could not get entity name")
        }
        
        let request = NSFetchRequest<Subtitle>(entityName: entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true)]
        let result: [Subtitle]!
        do {
            result = try coreDataStack.mainContext.fetch(request)
        } catch {
            fatalError("Could not get subtitles: \(error)")
        }
        
        return result
    }
}

