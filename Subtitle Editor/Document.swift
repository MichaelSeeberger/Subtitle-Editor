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
    let coreDataStack = CoreDataStack()

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
        enum ReadError: Error {
            case readError
        }
        
        let contents = try String(contentsOf: url, usedEncoding: &encoding)
        let decoder = SubRipDecoder()
        let backgroundContext = coreDataStack.createBackgroundContext()
        try decoder.decodeSubtitleString(contents: contents, generator: { Subtitle(context: backgroundContext) })
        if !coreDataStack.save(backgroundContext: backgroundContext) {
            throw ReadError.readError
        }
    }
    
    private func orderedSubtitles() -> [Subtitle] {
        //TODO: Implement
        return []
    }
}

