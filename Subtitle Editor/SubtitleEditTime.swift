//
//  SubtitleEditTime.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 20.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import Foundation

extension Subtitle {
    var endTime: Double {
        self.startTime + self.duration
    }
}

extension Subtitle {
    /**
     Change the start time of the subtitle.
     
     If `keepDuration` is `false`, then the duration is adjusted so that the end time remains the same. When set to `true` (default), the duration remains as is and the end time is adjusted.
     
     If the `keepDuration` is `false` and the new start time is greater then the end time, nothing is changed.
     
     - Parameters:
        - newStartTime: The new start time
        - keepDuration: Adjusts the duration, so that the end time will remain the same when set to `true`.
     */
    func changeStartTime(newStartTime: Double, keepDuration: Bool = true) {
        if keepDuration == false {
            if newStartTime > self.endTime {
                return
            }
            
            self.duration = self.endTime - newStartTime
        }
        
        self.startTime = newStartTime
    }
    
    /**
     Change the duration of the subtitle.
     
     If `keepStartTime` is `false`, then the start time is adjusted so that the end time remains the same. When set to `true` (default), the start time remains as is and the end time is adjusted.
     
     The function does nothing if `newDuration` is a negative number.
     
     - Parameters:
        - newDuration: The new duration for the subtitle.
        - keepStartTime: Adjusts the start time, so that the end time will remain the same when set to `false`. Otherwise, the start time remains and the end time is adjusted.
     */
    func changeDuration(newDuration: Double, keepStartTime: Bool = true) {
        if newDuration < 0.0 {
            return
        }
        
        if keepStartTime == false {
            self.startTime = self.endTime - newDuration
        }
        
        self.duration = newDuration
    }
    
    /**
    Change the end time of the subtitle.
    
    If `keepDuration` is `false`, then the duration is adjusted so that the start time remains the same. When set to `true` (default), the duration remains as is and the start time is adjusted.
     
    In the case that `keepDuration` is `false`, no changes are made if the new end time is smaller than the start time.
    
    - Parameters:
       - newEndTime: The new end time
       - keepDuration: Adjusts the duration, so that the end time will remain the same when set to `true`.
    */
    func changeEndTime(newEndTime: Double, keepDuration: Bool = true) {
        if keepDuration == true {
            self.startTime = newEndTime - self.duration
        } else if self.startTime < newEndTime {
            self.duration = newEndTime - self.startTime
        }
    }
}
