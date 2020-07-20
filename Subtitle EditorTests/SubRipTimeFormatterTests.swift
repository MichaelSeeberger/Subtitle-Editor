//
//  SubRipTimeFormatterTests.swift
//  Subtitle EditorTests
//
//  Created by Michael Seeberger on 19.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
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
