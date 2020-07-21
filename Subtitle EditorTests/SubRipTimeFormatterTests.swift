//
//  SubRipTimeFormatterTests.swift
//  Subtitle EditorTests
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

import XCTest
import Foundation
@testable import Subtitle_Editor

final class SubRipTimeFormatterTests: XCTestCase {
    let timeFormatter = SubRipTimeFormatter()
    
    func testStringFrom() {
        let result: String = timeFormatter.string(for: Double(7509.053))!
        XCTAssertEqual("02:05:09,053", result)
    }
    
    func testDoubleFromString() {
        var result: Double? = nil
        let resultPointer = AutoreleasingUnsafeMutablePointer<AnyObject?>(&result)
        let success = timeFormatter.getObjectValue(resultPointer, for: "02:05:09,053", errorDescription: nil)
        XCTAssertTrue(success)
        XCTAssertEqual(7509.053, resultPointer.pointee as! Double, accuracy: 0.0001)
    }
}
