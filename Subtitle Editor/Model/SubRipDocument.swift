//
//  SubRipDocument.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 19.07.23.
//  Copyright © 2023 Michael Seeberger. All rights reserved.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var subRip = UTType(importedAs: "org.matroska.subrip")
}

struct ReadError: Error {
    let file: String
    
    var localizedDescription: String {
        "Could not read the file \(file)"
    }
}

class SubRipDocument: ReferenceFileDocument {
    typealias Snapshot = String
    
    static var readableContentTypes: [UTType] = [.subRip]
    
    private let coreDataStack: CoreDataStack = CoreDataStack()
    
    var context: NSManagedObjectContext {
        coreDataStack.mainContext
    }
    
    required init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw ReadError(file: configuration.file.filename ?? "")
        }
        
        try SubRipDecoder().decodeSubtitleData(contents: data) {
            Subtitle(context: coreDataStack.mainContext)
        }
        
        if !coreDataStack.save() {
            throw ReadError(file: configuration.file.filename ?? "")
        }
    }
    
    init() {
    }
    
    func snapshot(contentType: UTType) throws -> String {
        return try SubRipEncoder().subtitlesAsString(subtitles: orderedSubtitles())
    }
    
    func fileWrapper(snapshot: String, configuration: WriteConfiguration) throws -> FileWrapper {
        let documentText = try self.snapshot(contentType: .subRip)
        
        return FileWrapper(regularFileWithContents: documentText.data(using: .utf8) ?? Data())
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
    
    func lastSubtitle() -> Subtitle? {
        let request = Subtitle.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: false)]
        request.fetchLimit = 1
        guard let result = try? coreDataStack.mainContext.fetch(request) else {
            return nil
        }
        
        return result.first
    }
}
