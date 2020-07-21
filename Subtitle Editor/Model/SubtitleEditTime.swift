//
//  SubtitleEditTime.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 20.07.20.
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

/**
 Provides an easy way to access the end time (read only).
 */
extension Subtitle {
    /**
     Get the end time of the subtitle.
     
     This (computed) property is read only. To change the end time, use `changeEndTime(newEndTime: Double, keepDuration: Bool)`.
     */
    var endTime: Double {
        self.startTime + self.duration
    }
}

/**
 This provides convenience methods to change the subtitles times.
 
 - Note: Do not edit the times manually, but instead use these methods!
 */
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
