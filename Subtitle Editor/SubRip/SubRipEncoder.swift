//
//  SubRipEncoder.swift
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

struct SubRipEncoder: SubtitleEncoder {
    let timeFormatter = SubRipTimeFormatter()
    
    func encodeSubtitles(subtitles: [Subtitle], using encoding: String.Encoding) throws -> Data {
        var documentString = String()
        var counter = 1
        for subtitle in subtitles {
            documentString += "\(counter)\r\n"
            
            guard let startTime = timeFormatter.string(for: subtitle.startTime) else {
                throw SubtitleEncoderError.DataNotConvertable
            }
            guard let endTime = timeFormatter.string(for: subtitle.endTime) else {
                throw SubtitleEncoderError.DataNotConvertable
            }
            
            documentString += "\(startTime) --> \(endTime)\r\n"
            
            documentString += (subtitle.content ?? "").replacingOccurrences(of: "\n", with: "\r\n") + "\r\n\r\n"
            
            counter += 1
        }
        
        guard let data = documentString.data(using: encoding) else {
            throw SubtitleEncoderError.DataNotConvertable
        }
        
        return data
    }
}
