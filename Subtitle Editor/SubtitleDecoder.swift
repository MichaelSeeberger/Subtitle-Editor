//
//  Parser.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 05.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import Foundation

typealias SubtitleGenerator = () -> Subtitle

enum SubtitleDecoderError: Error {
    case DataNotReadable
}

protocol SubtitleDecoder {
    func decodeSubtitleData(contents: Data, generator: SubtitleGenerator) throws
    func decodeSubtitleString(contents: String, generator: SubtitleGenerator) throws
}
