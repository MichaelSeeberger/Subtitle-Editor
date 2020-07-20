//
//  TimeFormatter.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 19.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
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
            obj?.pointee = stringResult as   NSNumber
        } catch {
            outError?.pointee = "Could not read time \"\(string)\": \(error)" as NSString
            return false
        }
        
        return true
    }
}
