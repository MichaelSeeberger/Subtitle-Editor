//
//  SubRipDecoder.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 06.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import Foundation
import CoreData

struct SubRipDecoder: SubtitleDecoder {
    func decodeSubtitleData(contents: Data, generator: SubtitleGenerator) throws {
        guard let string = String(data: contents, encoding: .utf8) else {
            throw SubtitleDecoderError.DataNotReadable
        }
        
        try decodeSubtitleString(contents: string, generator: generator)
    }
    
    func decodeSubtitleString(contents: String, generator: SubtitleGenerator) throws {
        let tokens = SubRipTokenizer(string: contents).tokenize()
        var parser = SubRipParser(tokens: tokens)
        try parser.parseSubtitles(generator: generator)
    }
}
