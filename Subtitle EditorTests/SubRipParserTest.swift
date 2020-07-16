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
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    override func setUp() {
        persistentContainer = NSPersistentContainer(name: "Document")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        //managedObjectContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        managedObjectContext = persistentContainer.viewContext
        
        super.setUp()
    }
    
    func newSubtitle() -> Subtitle {
        return Subtitle(context: managedObjectContext)
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
    
    func testParseWithWellFormedSubtitles() {
        let text = """
        1
        00:00:00,000 --> 00:00:05,000
        A Subtitle
        
        2
        00:00:10,123 --> 00:00:13,000
        Another Subtitle
        """
        //let subtitles = parseTextAndReturnSubtitles(text)
        let parser = SubRipParser()
        do {
            try parser.parse(string: text, subtitleGenerator: newSubtitle)
        } catch {
            XCTFail()
            return
        }
        let subtitles = fetchSubtitles()
        
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
        let parser = SubRipParser()
        do {
            try parser.parse(string: text, subtitleGenerator: newSubtitle)
        } catch {
            XCTFail()
            return
        }
        let subtitles = fetchSubtitles()
        
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
        let parser = SubRipParser()
        do {
            let tokenizer = SubRipTokenizer()
            let (rawText, formattedText, _) = try parser.parseBody(tokenizer: tokenizer, subtitlesString: text)
            XCTAssertEqual(text, rawText)
            XCTAssertEqual("A Subtitle", formattedText.string)
            let data = formattedText.rtf(from: NSMakeRange(0, formattedText.length))
            do {
                try data!.write(to: getDocumentsDirectory().appendingPathComponent("bold.rtf"))
            } catch {
                print("\(error)")
            }
        } catch {
            XCTFail()
        }
    }
    
    func testParseBodyWithItalicFont() {
        let text = "A <i>Subtitle</i>"
        let parser = SubRipParser()
        do {
            let tokenizer = SubRipTokenizer()
            let (rawText, formattedText, _) = try parser.parseBody(tokenizer: tokenizer, subtitlesString: text)
            XCTAssertEqual(text, rawText)
            XCTAssertEqual("A Subtitle", formattedText.string)
            let data = formattedText.rtf(from: NSMakeRange(0, formattedText.length))
            func getDocumentsDirectory() -> URL {
                let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                return paths[0]
            }
            do {
                try data!.write(to: getDocumentsDirectory().appendingPathComponent("italic.rtf"))
            } catch {
                print("\(error)")
            }
        } catch {
            XCTFail()
        }
    }
    
    func testParseBoldItalicFont() {
        let text = "A <b>test <i>Subtitle</i></b>"
        let parser = SubRipParser()
        do {
            let tokenizer = SubRipTokenizer()
            let (rawText, formattedText, _) = try parser.parseBody(tokenizer: tokenizer, subtitlesString: text)
            XCTAssertEqual(text, rawText)
            XCTAssertEqual("A test Subtitle", formattedText.string)
            let data = formattedText.rtf(from: NSMakeRange(0, formattedText.length))
            func getDocumentsDirectory() -> URL {
                let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                return paths[0]
            }
            do {
                try data!.write(to: getDocumentsDirectory().appendingPathComponent("boldItalic.rtf"))
            } catch {
                print("\(error)")
            }
        } catch {
            XCTFail()
        }
    }
    
    func testParseFormattedMultilineSubtitle() {
        let text = "A <b>test <i>Subtitle</i></b>\nwith two lines"
        let parser = SubRipParser()
        do {
            let tokenizer = SubRipTokenizer()
            let (rawText, formattedText, _) = try parser.parseBody(tokenizer: tokenizer, subtitlesString: text)
            XCTAssertEqual(text, rawText)
            XCTAssertEqual("A test Subtitle\nwith two lines", formattedText.string)
            let data = formattedText.rtf(from: NSMakeRange(0, formattedText.length))
            do {
                try data!.write(to: getDocumentsDirectory().appendingPathComponent("boldItalicTwoLines.rtf"))
            } catch {
                print("\(error)")
            }
        } catch {
            XCTFail()
        }
    }
    
    func testParseFormattedSubtitleWithNewLineInTag() {
        let text = "A <b>test <i>Subtitle</i>\nwith</b> two lines"
        let parser = SubRipParser()
        do {
            let tokenizer = SubRipTokenizer()
            let (rawText, formattedText, _) = try parser.parseBody(tokenizer: tokenizer, subtitlesString: text)
            XCTAssertEqual(text, rawText)
            XCTAssertEqual("A test Subtitle\nwith two lines", formattedText.string)
            let data = formattedText.rtf(from: NSMakeRange(0, formattedText.length))
            do {
                try data!.write(to: getDocumentsDirectory().appendingPathComponent("boldItalicTwoLinesSpanFormat.rtf"))
            } catch {
                print("\(error)")
            }
        } catch {
            XCTFail()
        }
    }
    
    func testParseMultilineSubtitle() {
        let text = "A test Subtitle\nwith two lines"
        let parser = SubRipParser()
        do {
            let tokenizer = SubRipTokenizer()
            let (rawText, formattedText, _) = try parser.parseBody(tokenizer: tokenizer, subtitlesString: text)
            XCTAssertEqual(text, rawText)
            XCTAssertEqual("A test Subtitle\nwith two lines", formattedText.string)
            let data = formattedText.rtf(from: NSMakeRange(0, formattedText.length))
            do {
                try data!.write(to: getDocumentsDirectory().appendingPathComponent("boldItalicTwoLines.rtf"))
            } catch {
                print("\(error)")
            }
        } catch {
            XCTFail()
        }
    }


    func testRealSubtitle() {
        let subtitleString = testHelpers.getSubtitlesFromFile()
        let parser = SubRipParser()
        do {
            try parser.parse(string: subtitleString, subtitleGenerator: newSubtitle)
            let subtitles = fetchSubtitles()
            XCTAssertEqual(subtitles.count, 937)
        } catch SubRipParseError.UnexpectedToken(_, _) {
            XCTFail()
        } catch {
            XCTFail()
        }
    }
    
    func testRealSubtitleTime() {
        let subtitleString = testHelpers.getSubtitlesFromFile()
        let parser = SubRipParser()
        self.measure {
            do {
                try parser.parse(string: subtitleString, subtitleGenerator: newSubtitle)
            } catch SubRipParseError.UnexpectedToken(_, _) {
                XCTFail()
            } catch {
                XCTFail()
            }
        }
    }
}
