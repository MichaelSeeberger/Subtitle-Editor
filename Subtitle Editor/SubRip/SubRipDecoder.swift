//
//  SubRipDecoder.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 06.07.20.
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

struct SubRipDecoder: SubtitleDecoder {
    func decodeSubtitleData(contents: Data, generator: SubtitleGenerator) throws {
        guard let string = String(data: contents, encoding: .utf8) else {
            throw SubtitleDecoderError.DataNotReadable
        }
        
        try decodeSubtitleString(contents: string, generator: generator)
    }
    
    func decodeSubtitleString(contents: String, generator: SubtitleGenerator) throws {
        let parser = SubRipParser()
        try parser.parse(string: contents, subtitleGenerator: generator)
    }
}
