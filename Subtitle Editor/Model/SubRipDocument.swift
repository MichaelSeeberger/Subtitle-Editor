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
import Combine

extension UTType {
    static var subRip = UTType(importedAs: "org.matroska.subrip")
}

struct ReadError: Error {
    let file: String
    
    var localizedDescription: String {
        String(localized: "Could not read the file \(file)")
    }
}

class SubRipDocument: ReferenceFileDocument {
    typealias Snapshot = String
    
    static var readableContentTypes: [UTType] = [.subRip]
    
    @Published private(set) var subtitlesById: [UUID: Subtitle] = [:]
    @Published var orderedSubtitles: [Subtitle] = []
    
    private var subtitlesUpdateCancellable: AnyCancellable? = nil
    
    required init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw ReadError(file: configuration.file.filename ?? "")
        }
        
        self.subtitlesUpdateCancellable = $subtitlesById.sink(receiveValue: { subtitles in
            self.updateOrderedSubtitles(subtitles)
        })
        
        let readSubtitles = try SubRipDecoder().decodeSubtitleData(contents: data)
        self.subtitlesById = readSubtitles.reduce(into: [UUID: Subtitle]()) { partialResult, subtitle in
            partialResult[subtitle.id] = subtitle
        }
    }
    
    init() {
        self.subtitlesUpdateCancellable = $subtitlesById.sink(receiveValue: { subtitles in
            self.updateOrderedSubtitles(subtitles)
        })
    }
    
    func snapshot(contentType: UTType) throws -> String {
        return try SubRipEncoder().subtitlesAsString(subtitles: orderedSubtitles)
    }
    
    func fileWrapper(snapshot: String, configuration: WriteConfiguration) throws -> FileWrapper {
        let documentText = try self.snapshot(contentType: .subRip)
        
        return FileWrapper(regularFileWithContents: documentText.data(using: .utf8) ?? Data())
    }
    
    func lastSubtitle() -> Subtitle? {
        return orderedSubtitles.last
    }
    
    func updateSubtitle(with id: UUID, content: String? = nil, startTime: Double? = nil, duration: Double? = nil) {
        guard let oldSubtitle = subtitlesById[id] else {
            NSLog("Error: the subtitle with id \(id) does not exist.")
            return
        }
        
        let newSubtitle = Subtitle(id: id,
                                   content: content ?? oldSubtitle.content,
                                   startTime: startTime ?? oldSubtitle.startTime,
                                   duration: duration ?? oldSubtitle.duration)
        subtitlesById[newSubtitle.id] = newSubtitle
    }
    
    func newSubtitle(id: UUID? = nil, content: String? = nil, startTime: Double? = nil, duration: Double = 5) -> Subtitle? {
        if id != nil && subtitlesById[id!] != nil {
            NSLog("Error: Can't add new subtitle with id \(id!). The id is already in use!")
            return nil
        }
        
        let newSubtitle = Subtitle(id: id, content: content ?? "", startTime: startTime ?? 0, duration: duration)
        subtitlesById[newSubtitle.id] = newSubtitle
        
        return newSubtitle
    }
    
    func delete(subtitle: Subtitle) {
        subtitlesById.removeValue(forKey: subtitle.id)
    }
    
    private func updateOrderedSubtitles(_ newSubtitles: [UUID: Subtitle]) {
        orderedSubtitles = newSubtitles.values.sorted { lhs, rhs in
            lhs.startTime < rhs.startTime
        }
    }
}
