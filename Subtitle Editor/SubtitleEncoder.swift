//
//  SubtitleEncoder.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 06.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import Foundation

enum SubtitleEncoderError: Error {
    case DataNotConvertable
}

protocol SubtitleEncoder {
    func encodeSubtitles(subtitles: [Subtitle], using encoding: String.Encoding) throws -> Data
}
