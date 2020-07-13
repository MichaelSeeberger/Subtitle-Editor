//
//  Document.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 05.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    var encoding: String.Encoding = .utf8
    var managedObjectContext: NSManagedObjectContext
    var persistentContainer: NSPersistentContainer

    override init() {
        persistentContainer = NSPersistentContainer(name: "Document")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        managedObjectContext = persistentContainer.viewContext
        
        super.init()
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
        self.addWindowController(windowController)
    }

    override func data(ofType typeName: String) throws -> Data {
        return try SubRipEncoder().encodeSubtitles(subtitles: orderedSubtitles(), using: .utf8)
    }
    
    override func read(from url: URL, ofType typeName: String) throws {
        let contents = try String(contentsOf: url, usedEncoding: &encoding)
        let decoder = SubRipDecoder()
        try decoder.decodeSubtitleString(contents: contents, generator: newEmptySubtitle)
    }
    
    private func newEmptySubtitle() -> Subtitle {
        return Subtitle(context: managedObjectContext)
    }
    
    private func orderedSubtitles() -> [Subtitle] {
        //TODO: Implement
        return []
    }
}

