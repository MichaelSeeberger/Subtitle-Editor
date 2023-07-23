//
//  Subtitle.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 20.07.23.
//  Copyright © 2023 Michael Seeberger. All rights reserved.
//

import Foundation

struct Subtitle: Identifiable, Hashable {
    let id: UUID
    let content: String
    let startTime: Double
    let duration: Double
    let formattedContent: NSAttributedString
    
    init(id: UUID? = nil, content: String, startTime: Double, duration: Double) {
        self.id = id ?? UUID()
        self.content = content
        self.formattedContent = Self.format(string: content)
        self.startTime = startTime
        self.duration = duration
    }
    
    private static func format(string: String) -> NSAttributedString {
        let parser = SubRipParser()
        do {
            let (_, formatted, _) = try parser.parseBody(tokenizer: SubRipTokenizer(), subtitlesString: string)
            return formatted
        } catch {
            NSLog("Could not parse body of \(string)")
            return NSAttributedString(string: string)
        }
    }
}
