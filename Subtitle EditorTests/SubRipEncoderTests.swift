//
//  SubRipEncoderTests.swift
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
import CoreData
@testable import Subtitle_Editor

class SubRipEncoderTests: XCTestCase {
    let stack = CoreDataStack()
    var expectedString: String!
    
    var subtitles: [Subtitle] {
        guard let subtitleEntityName = Subtitle.entity().name else {
            fatalError()
        }
        let request = NSFetchRequest<Subtitle>(entityName: subtitleEntityName)
        request.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true)]
        do {
            return try stack.mainManagedObjectContext.fetch(request)
        } catch {
            fatalError()
        }
    }
    
    override func setUpWithError() throws {
        try stack.resetStore()
        
        for i in 1...2 {
            let subtitle = Subtitle(context: stack.mainManagedObjectContext)
            subtitle.counter = Int64(i)
            subtitle.content = "Subtitle \(i)"
            subtitle.startTime = Double(i*25)
            subtitle.duration = 15.0
        }
        
        expectedString = "1\r\n00:00:25,000 --> 00:00:40,000\r\nSubtitle 1\r\n\r\n2\r\n00:00:50,000 --> 00:01:05,000\r\nSubtitle 2\r\n\r\n"
    }

    func testEncode() throws {
        let encoder = SubRipEncoder()
        let data = try encoder.encodeSubtitles(subtitles: subtitles, using: .utf8)
        guard let string = String(data: data, encoding: .utf8) else {
            XCTFail()
            return
        }
        XCTAssertEqual(expectedString, string)
    }
}
