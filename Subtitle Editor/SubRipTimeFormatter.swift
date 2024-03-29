//
//  TimeFormatter.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 19.07.20.
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

class SubRipTimeFormatter: Formatter {
    override func string(for obj: Any?) -> String? {
        guard let doubleValue = (obj as? Double) else {
            return nil
        }
        
        var timeAsInt = Int(1000*doubleValue)
        
        let hours = timeAsInt / 3600000
        timeAsInt %= 3600000
        
        let minutes = timeAsInt / 60000
        timeAsInt %= 60000
        
        let seconds = timeAsInt / 1000
        timeAsInt %= 1000
        let milliSeconds = timeAsInt
        
        return String(format: "%02d:%02d:%02d,%03d", hours, minutes, seconds, milliSeconds)
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription outError: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        let tokenizer = SubRipTokenizer()
        let parser = SubRipParser()
        do {
            let (stringResult, _) = try parser.parseTime(tokenizer: tokenizer, subtitlesString: string)
            obj?.pointee = stringResult as NSNumber
        } catch {
            outError?.pointee = "Could not read time \"\(string)\": \(error)" as NSString
            return false
        }
        
        return true
    }
    
    func isValid(_ string: String) -> Bool {
        let invalidCharachters = NSCharacterSet(charactersIn: "0123456789:,.").inverted
        
        if string.rangeOfCharacter(from: invalidCharachters) != nil {
            return false
        }
        
        let tokenizer = SubRipTokenizer()
        let parser = SubRipParser()
        do {
            let _ = try parser.parseTime(tokenizer: tokenizer, subtitlesString: string)
        } catch {
            return false
        }
        
        return true
    }
    
    override func isPartialStringValid(
        _ partialString: String,
        newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
            return isValid(partialString)
    }
}
