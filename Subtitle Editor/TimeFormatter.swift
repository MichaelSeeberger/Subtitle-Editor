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
        guard var doubleValue = (obj as? Double) else {
            return nil
        }
        
        let timeAsInt = Int(1000*doubleValue)
        
        let hours = Int(doubleValue) % 3600
        doubleValue -= Double(hours)
        
        let minutes = Int(doubleValue) % 60
        doubleValue -= Double(minutes)
        
        let seconds = Int(doubleValue)
        doubleValue -= Double(seconds)
        let milliSeconds = Int(doubleValue * 1000)
        
        return String(format: "%2d:%2d:%2d,%d", hours, minutes, seconds, milliSeconds)
    }
}
