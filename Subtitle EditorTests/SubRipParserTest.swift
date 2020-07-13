//
//  SubRipParserTest.swift
//  Subtitle EditorTests
//
//  Created by Michael Seeberger on 10.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import XCTest
import Foundation
@testable import Subtitle_Editor

final class SubRipParserTests: XCTestCase {
    var managedObjectContext: NSManagedObjectContext!
    var persistentContainer: NSPersistentContainer!
    lazy var testHelpers = TestHelpers()

    override func setUp() {
        persistentContainer = NSPersistentContainer(name: "Document")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        managedObjectContext = persistentContainer.viewContext
        
        super.setUp()
    }
    
    func newSubtitle() -> Subtitle {
        return Subtitle(context: managedObjectContext)
    }
    
    func parseText(_ text: String) {
        let tokenizer = SubRipTokenizer(string: text)
        let tokens = tokenizer.tokenize()
        var parser = SubRipParser(tokens: tokens)
        do {
            try parser.parseSubtitles(generator: newSubtitle)
        } catch let SubRipParseError.UnexpectedToken(expected, actual) {
            print("Unexpected token \(actual) (expected \(expected))")
            fatalError()
        } catch {
            print("Unkown error")
            fatalError()
        }
    }
    
    func fetchSubtitles() -> [Subtitle] {
        guard let subtitleEntityName = Subtitle.entity().name else {
            fatalError()
        }
        let request = NSFetchRequest<Subtitle>(entityName: subtitleEntityName)
        request.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true)]
        do {
            return try managedObjectContext.fetch(request)
        } catch {
            fatalError()
        }
    }
    
    func parseTextAndReturnSubtitles(_ text: String) -> [Subtitle] {
        parseText(text)
        return fetchSubtitles()
    }
    
    func testParseWithWellFormedSubtitles() {
        let text = """
        1
        00:00:00,000 --> 00:00:05,000
        A Subtitle
        
        2
        00:00:10,123 --> 00:00:13,000
        Another Subtitle
        """
        let subtitles = parseTextAndReturnSubtitles(text)
        
        XCTAssertEqual(subtitles.count, 2)
        XCTAssertEqual(subtitles[0].content, "A Subtitle")
        XCTAssertEqual(Int(subtitles[0].startTime*1000), 0)
        XCTAssertEqual(Int(subtitles[0].duration*1000), 5000)
        
        XCTAssertEqual(subtitles[1].content, "Another Subtitle")
        XCTAssertEqual(Int(subtitles[1].startTime*1000), 10123)
        XCTAssertEqual(Int(subtitles[1].duration*1000), 2877)
    }
    
    func testParseWithBoldFont() {
        let text = """
        1
        00:00:00,000 --> 00:00:05,000
        A <b>Subtitle</b>
        
        2
        00:00:10,123 --> 00:00:13,000
        Another {b}Subtitle{/b}
        """
        let subtitles = parseTextAndReturnSubtitles(text)
        
        XCTAssertEqual(subtitles.count, 2)
        XCTAssertEqual(subtitles[0].content, "A <b>Subtitle</b>")
        guard let sub1RTFData = subtitles[0].formattedContent else {
            XCTFail()
            return
        }
        let sub1RTF = NSAttributedString(rtf: sub1RTFData, documentAttributes: nil)
        XCTAssertEqual(sub1RTF?.string, "A Subtitle")
        XCTAssertEqual(Int(subtitles[0].startTime*1000), 0)
        XCTAssertEqual(Int(subtitles[0].duration*1000), 5000)
        
        XCTAssertEqual(subtitles[1].content, "Another {b}Subtitle{/b}")
        guard let sub2RTFData = subtitles[1].formattedContent else {
            XCTFail()
            return
        }
        let sub2RTF = NSAttributedString(rtf: sub2RTFData, documentAttributes: nil)
        XCTAssertEqual(sub2RTF?.string, "Another Subtitle")
        XCTAssertEqual(Int(subtitles[1].startTime*1000), 10123)
        XCTAssertEqual(Int(subtitles[1].duration*1000), 2877)
    }
    
    func testParseBodyWithBoldFont() {
        let text = "A <b>Subtitle</b>"
        let tokenizer = SubRipTokenizer(string: text)
        var parser = SubRipParser(tokens: tokenizer.tokenize())

        do {
            let (parsedText, attributedText) = try parser.parseBody()
            XCTAssertEqual(text, parsedText)
            XCTAssertEqual("A Subtitle", attributedText.string)
        } catch {
            XCTFail()
        }
    }
    
    func testRealSubtitle() {
        let subtitleString = testHelpers.getSubtitlesFromFile()
        let tokens = SubRipTokenizer(string: subtitleString).tokenize()
        var parser = SubRipParser(tokens: tokens)
        do {
            try parser.parseSubtitles(generator: newSubtitle)
        } catch SubRipParseError.UnexpectedToken(_, _) {
            XCTFail()
        } catch {
            XCTFail()
        }
    }
}
