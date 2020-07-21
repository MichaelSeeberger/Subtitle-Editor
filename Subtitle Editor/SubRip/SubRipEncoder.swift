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
    func formattedTime(_ aTime: Double) -> String {
        let partialSeconds = Int(aTime * 1000) % 1000
        var time = Int(aTime)
        let seconds = time % 60
        time -= seconds
        time /= 60
        let minutes: Int = time % 60
        time -= minutes
        time /= 60
        
        return "\(String(format: "%02d", time)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds)),\(String(format: "%03d", partialSeconds))"
    }
    
    func subtitleAsString(subtitle: Subtitle) -> String {
        var string = String()
        string.append(contentsOf: formattedTime(subtitle.startTime))
        return ""
    }
    
    func encodeSubtitles(subtitles: [Subtitle], using encoding: String.Encoding) throws -> Data {
        var documentString = String()
        for subtitle in subtitles {
            documentString.append(contentsOf: subtitleAsString(subtitle: subtitle))
        }
        
        guard let data = documentString.data(using: encoding) else {
            throw SubtitleEncoderError.DataNotConvertable
        }
        
        return data
    }
}
