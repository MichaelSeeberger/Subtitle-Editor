//
//  SubtitleEditTime.swift
//  Subtitle EditorTests
//
//  Created by Michael Seeberger on 21.07.20.
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

import XCTest
import Foundation
@testable import Subtitle_Editor

final class SubtitleEditTimeTests: XCTestCase {
    private let stack = CoreDataStack()
    private var subtitle: Subtitle!
    
    override func setUp() {
        do {
            try stack.resetStore()
        } catch {
            fatalError("Error setting up SubtitleEditTimeTests: \(error)")
        }
        
        subtitle = Subtitle(context: stack.mainManagedObjectContext)
        subtitle.startTime = 120
        subtitle.duration = 15
    }
    
    func testSubtitlesEndTime() {
        XCTAssertEqual(subtitle.endTime, 135, accuracy: 0.0001)
    }
    
    func testChangeStartTimeKeepingDuration() {
        subtitle.changeStartTime(newStartTime: 130, keepDuration: true)
        XCTAssertEqual(subtitle.startTime, 130, accuracy: 0.0001)
        XCTAssertEqual(subtitle.duration, 15, accuracy: 0.0001)
        XCTAssertEqual(subtitle.endTime, 145, accuracy: 0.0001)
    }
    
    func testChangeStartTimeKeepDurationByDefault() {
        subtitle.changeStartTime(newStartTime: 130)
        XCTAssertEqual(subtitle.startTime, 130, accuracy: 0.0001)
        XCTAssertEqual(subtitle.duration, 15, accuracy: 0.0001)
        XCTAssertEqual(subtitle.endTime, 145, accuracy: 0.0001)
    }
    
    func testChangeStartTimeChangingDuration() {
        subtitle.changeStartTime(newStartTime: 130, keepDuration: false)
        XCTAssertEqual(subtitle.startTime, 130, accuracy: 0.0001)
        XCTAssertEqual(subtitle.duration, 5, accuracy: 0.0001)
        XCTAssertEqual(subtitle.endTime, 135, accuracy: 0.0001)
    }
    
    func testChangeStartTimeChangingDurationDoesNothingWhenDurationIsNegative() {
        subtitle.changeStartTime(newStartTime: 140, keepDuration: false)
        XCTAssertEqual(subtitle.startTime, 120, accuracy: 0.0001)
        XCTAssertEqual(subtitle.duration, 15, accuracy: 0.0001)
        XCTAssertEqual(subtitle.endTime, 135, accuracy: 0.0001)
    }
    
    func testChangeEndTimeKeepingDuration() {
        subtitle.changeEndTime(newEndTime: 130, keepDuration: true)
        XCTAssertEqual(subtitle.startTime, 115, accuracy: 0.0001)
        XCTAssertEqual(subtitle.duration, 15, accuracy: 0.0001)
        XCTAssertEqual(subtitle.endTime, 130, accuracy: 0.0001)
    }
    
    func testChangeEndTimeKeepDurationByDefault() {
        subtitle.changeEndTime(newEndTime: 130)
        XCTAssertEqual(subtitle.startTime, 115, accuracy: 0.0001)
        XCTAssertEqual(subtitle.duration, 15, accuracy: 0.0001)
        XCTAssertEqual(subtitle.endTime, 130, accuracy: 0.0001)
    }
    
    func testChangeEndTimeChangingDuration() {
        subtitle.changeEndTime(newEndTime: 130, keepDuration: false)
        XCTAssertEqual(subtitle.startTime, 120, accuracy: 0.0001)
        XCTAssertEqual(subtitle.duration, 10, accuracy: 0.0001)
        XCTAssertEqual(subtitle.endTime, 130, accuracy: 0.0001)
    }
    
    func testChangeEndTimeChangingDurationDoesNothingWhenDurationIsNegative() {
        subtitle.changeEndTime(newEndTime: 110, keepDuration: false)
        XCTAssertEqual(subtitle.startTime, 120, accuracy: 0.0001)
        XCTAssertEqual(subtitle.duration, 15, accuracy: 0.0001)
        XCTAssertEqual(subtitle.endTime, 135, accuracy: 0.0001)
    }
}
