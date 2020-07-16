//
//  SubRipTokenizerTest.swift
//  Subtitle EditorTests
//
//  Created by Michael Seeberger on 09.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import Foundation

import XCTest
import Foundation
@testable import Subtitle_Editor

final class SubRipTokenizerTests: XCTestCase {
    lazy var testHelpers = TestHelpers()
    
    func testTokenizeTimeLine() {
        let text = "00:00:00,000 --> 00:00:05,000\n"
        let tokenizer = SubRipTokenizer()
        var counter = 1
        var (nextToken, content) = tokenizer.nextToken(tokenList: tokenizer.timeLineTokens, content: text)
        while nextToken != .EOF {
            counter += 1
            (nextToken, content) = tokenizer.nextToken(tokenList: tokenizer.timeLineTokens, content: content)
            if counter > 16 {
                XCTFail()
            }
        }
        XCTAssertEqual(counter, 15)
    }
    
    func testTokenizeTimeLineWithTooLongArrow() {
        let text = "00:00:00,000 -------> 00:00:05,000\n"
        let tokenizer = SubRipTokenizer()
        var counter = 1
        var (nextToken, content) = tokenizer.nextToken(tokenList: tokenizer.timeLineTokens, content: text)
        while nextToken != .EOF {
            counter += 1
            (nextToken, content) = tokenizer.nextToken(tokenList: tokenizer.timeLineTokens, content: content)
            if counter > 16 {
                XCTFail()
            }
        }
        XCTAssertEqual(counter, 15)
    }
    
    func testTokenizeTimeLineWithTooShortArrow() {
        let text = "00:00:00,000 -> 00:00:05,000\n"
        let tokenizer = SubRipTokenizer()
        var counter = 1
        var (nextToken, content) = tokenizer.nextToken(tokenList: tokenizer.timeLineTokens, content: text)
        while nextToken != .EOF {
            counter += 1
            (nextToken, content) = tokenizer.nextToken(tokenList: tokenizer.timeLineTokens, content: content)
            if counter > 16 {
                XCTFail()
            }
        }
        XCTAssertEqual(counter, 15)
    }
    
    func testTokenizeBody() {
        let body = "A subtitle\nWith a second line"
        let tokenizer = SubRipTokenizer()
        
        var (nextToken, content) = tokenizer.nextToken(tokenList: tokenizer.bodyTokens, content: body)
        var counter = 1
        while nextToken != .EOF {
            (nextToken, content) = tokenizer.nextToken(tokenList: tokenizer.bodyTokens, content: content)
            counter += 1
            if counter > 100 { XCTFail() }
        }
        XCTAssertEqual(counter, 4)
    }
    
    func testTokenizeBodyWithTags() {
        // Note: this will not change into the tag mode, hence the b and i tag, as well as the right tag symbols (> and }> will not be recognised
        let body = "A <b>subtitle</b>\nWith a {i}second{/i} line"
        let tokenizer = SubRipTokenizer()
        
        var (nextToken, content) = tokenizer.nextToken(tokenList: tokenizer.bodyTokens, content: body)
        var counter = 1
        while nextToken != .EOF {
            (nextToken, content) = tokenizer.nextToken(tokenList: tokenizer.bodyTokens, content: content)
            counter += 1
            if counter > 100 { XCTFail() }
        }
        XCTAssertEqual(counter, 12)
    }
}
