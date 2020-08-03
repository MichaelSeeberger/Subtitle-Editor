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
        
        subtitle = Subtitle(context: stack.mainContext)
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
    
    func testChangeDurationKeepingStartTimeDefault() {
        subtitle.changeDuration(newDuration: 20)
        XCTAssertEqual(subtitle.startTime, 120, accuracy: 0.0001)
        XCTAssertEqual(subtitle.duration, 20, accuracy: 0.0001)
        XCTAssertEqual(subtitle.endTime, 140, accuracy: 0.0001)
    }
    
    func testChangeDurationKeepingStartTime() {
        subtitle.changeDuration(newDuration: 20, keepStartTime: true)
        XCTAssertEqual(subtitle.startTime, 120, accuracy: 0.0001)
        XCTAssertEqual(subtitle.duration, 20, accuracy: 0.0001)
        XCTAssertEqual(subtitle.endTime, 140, accuracy: 0.0001)
    }
    
    func testChangeDurationKeepingEndTime() {
        subtitle.changeDuration(newDuration: 20, keepStartTime: false)
        XCTAssertEqual(subtitle.startTime, 115, accuracy: 0.0001)
        XCTAssertEqual(subtitle.duration, 20, accuracy: 0.0001)
        XCTAssertEqual(subtitle.endTime, 135, accuracy: 0.0001)
    }
    
    func testAddTimeToSubtitlesInRange() throws {
        do {
            try stack.resetStore()
        } catch {
            fatalError("Could not reset store")
        }
        
        for i in 1...6 {
            let newSubtitle = Subtitle(context: stack.mainContext)
            newSubtitle.startTime = Double(i)*20.0
            newSubtitle.duration = 15
            newSubtitle.counter = Int64(i)
        }
        if !stack.save() {
            fatalError("Could not save store")
        }
        
        let editingService = EditRangeService(context: stack.mainContext)
        try editingService.addTimeToSubtitlesInRange(startTime: 50.0, endTime: 90.0, add: 3.0)
        
        let fetchRequest = NSFetchRequest<Subtitle>(entityName: Subtitle.entity().name!)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "startTime", ascending: true)
        ]
        let subtitles = try stack.mainContext.fetch(fetchRequest)
        for i in 1...5 {
            if i < 3 || i > 4 {
                XCTAssertEqual(subtitles[i-1].startTime, Double(i)*20.0, accuracy: 0.0001)
                XCTAssertEqual(subtitles[i-1].duration, 15, accuracy: 0.0001)
            } else {
                XCTAssertEqual(subtitles[i-1].startTime, Double(i)*20.0 + 3.0, accuracy: 0.0001)
                XCTAssertEqual(subtitles[i-1].duration, 15, accuracy: 0.0001)
            }
        }
    }
    
    func testSubtractTimeFromSubtitlesInRange() throws {
        do {
            try stack.resetStore()
        } catch {
            fatalError("Could not reset store")
        }
        
        for i in 1...6 {
            let newSubtitle = Subtitle(context: stack.mainContext)
            newSubtitle.startTime = Double(i)*20.0
            newSubtitle.duration = 15
            newSubtitle.counter = Int64(i)
        }
        if !stack.save() {
            fatalError("Could not save store")
        }
        
        let editingService = EditRangeService(context: stack.mainContext)
        try editingService.addTimeToSubtitlesInRange(startTime: 50.0, endTime: 90.0, add: -3.0)
        
        let fetchRequest = NSFetchRequest<Subtitle>(entityName: Subtitle.entity().name!)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "startTime", ascending: true)
        ]
        let subtitles = try stack.mainContext.fetch(fetchRequest)
        for i in 1...5 {
            if i < 3 || i > 4 {
                XCTAssertEqual(subtitles[i-1].startTime, Double(i)*20.0, accuracy: 0.0001)
                XCTAssertEqual(subtitles[i-1].duration, 15, accuracy: 0.0001)
            } else {
                XCTAssertEqual(subtitles[i-1].startTime, Double(i)*20.0 - 3.0, accuracy: 0.0001)
                XCTAssertEqual(subtitles[i-1].duration, 15, accuracy: 0.0001)
            }
        }
    }
    
    func testAddTimeToAllSubtitles() throws {
        do {
            try stack.resetStore()
        } catch {
            fatalError("Could not reset store")
        }
        
        for i in 1...6 {
            let newSubtitle = Subtitle(context: stack.mainContext)
            newSubtitle.startTime = Double(i)*20.0
            newSubtitle.duration = 15
            newSubtitle.counter = Int64(i)
        }
        if !stack.save() {
            fatalError("Could not save store")
        }
        
        let editingService = EditRangeService(context: stack.mainContext)
        try editingService.addTimeToAllSubitles(3.0)
        
        let fetchRequest = NSFetchRequest<Subtitle>(entityName: Subtitle.entity().name!)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "startTime", ascending: true)
        ]
        let subtitles = try stack.mainContext.fetch(fetchRequest)
        for i in 1...5 {
            XCTAssertEqual(subtitles[i-1].startTime, Double(i)*20.0 + 3.0, accuracy: 0.0001)
            XCTAssertEqual(subtitles[i-1].duration, 15, accuracy: 0.0001)
        }
    }
    
    func testSubtractTimeFromAllSubtitles() throws {
        do {
            try stack.resetStore()
        } catch {
            fatalError("Could not reset store")
        }
        
        for i in 1...6 {
            let newSubtitle = Subtitle(context: stack.mainContext)
            newSubtitle.startTime = Double(i)*20.0
            newSubtitle.duration = 15
            newSubtitle.counter = Int64(i)
        }
        if !stack.save() {
            fatalError("Could not save store")
        }
        
        let editingService = EditRangeService(context: stack.mainContext)
        try editingService.addTimeToAllSubitles(-3.0)
        
        let fetchRequest = NSFetchRequest<Subtitle>(entityName: Subtitle.entity().name!)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "startTime", ascending: true)
        ]
        let subtitles = try stack.mainContext.fetch(fetchRequest)
        for i in 1...5 {
            XCTAssertEqual(subtitles[i-1].startTime, Double(i)*20.0 - 3.0, accuracy: 0.0001)
            XCTAssertEqual(subtitles[i-1].duration, 15, accuracy: 0.0001)
        }
    }
}
