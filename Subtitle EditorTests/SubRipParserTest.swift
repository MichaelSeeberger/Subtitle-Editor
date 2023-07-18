//
//  SubRipParserTest.swift
//  Subtitle EditorTests
//
//  Created by Michael Seeberger on 10.07.20.
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

final class SubRipParserTests: XCTestCase {
    var coreDataStack: CoreDataStack!
    lazy var testHelpers = TestHelpers()
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    override func setUp() {
        coreDataStack = CoreDataStack()
        
        super.setUp()
    }
    
    func newSubtitle() -> Subtitle {
        return Subtitle(context: coreDataStack.mainContext)
    }
    
    func fetchSubtitles() -> [Subtitle] {
        guard let subtitleEntityName = Subtitle.entity().name else {
            fatalError()
        }
        let request = NSFetchRequest<Subtitle>(entityName: subtitleEntityName)
        request.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true)]
        do {
            return try coreDataStack.mainContext.fetch(request)
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
            let sub1Font = formattedText.attributes(at: 2, effectiveRange: nil)[.font] as! NSFont
            XCTAssertTrue(sub1Font.fontDescriptor.symbolicTraits.contains(.bold))
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
            let sub1Font = formattedText.attributes(at: 2, effectiveRange: nil)[.font] as! NSFont
            XCTAssertTrue(sub1Font.fontDescriptor.symbolicTraits.contains(.italic))
        } catch {
            XCTFail()
        }
    }
    
    func testParseBodyWithFontTagAndHexColor() {
        let text = "A <font color=\"#ff0023\">Subtitle</font>"
        let parser = SubRipParser()
        do {
            let tokenizer = SubRipTokenizer()
            let (rawText, formattedText, _) = try parser.parseBody(tokenizer: tokenizer, subtitlesString: text)
            XCTAssertEqual(text, rawText)
            XCTAssertEqual("A Subtitle", formattedText.string)
            let sub1Color = formattedText.attributes(at: 2, effectiveRange: nil)[.foregroundColor] as! NSColor
            XCTAssertNotNil(sub1Color)
            XCTAssertEqual(sub1Color, NSColor(rgb: 0xff0023))
        } catch {
            XCTFail()
        }
    }
    
    func testParseBodyWithFontTagAndNamedColor() {
        let text = "A <font color=\"blue\">Subtitle</font>"
        let parser = SubRipParser()
        do {
            let tokenizer = SubRipTokenizer()
            let (rawText, formattedText, _) = try parser.parseBody(tokenizer: tokenizer, subtitlesString: text)
            XCTAssertEqual(text, rawText)
            XCTAssertEqual("A Subtitle", formattedText.string)
            let sub1Color = formattedText.attributes(at: 2, effectiveRange: nil)[.foregroundColor] as! NSColor
            XCTAssertNotNil(sub1Color)
            XCTAssertEqual(sub1Color, NSColor.blue)
        } catch {
            XCTFail()
        }
    }
    
    func testParseBodyWithFontTagAndCapitalizedNamedColor() {
        let text = "A <font color=\"CornflowerBlue\">Subtitle</font>"
        let parser = SubRipParser()
        do {
            let tokenizer = SubRipTokenizer()
            let (rawText, formattedText, _) = try parser.parseBody(tokenizer: tokenizer, subtitlesString: text)
            XCTAssertEqual(text, rawText)
            XCTAssertEqual("A Subtitle", formattedText.string)
            let sub1Color = formattedText.attributes(at: 2, effectiveRange: nil)[.foregroundColor] as! NSColor
            XCTAssertNotNil(sub1Color)
            XCTAssertEqual(sub1Color, NSColor(rgb: 0x6495ed))
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
            let sub1Font1 = formattedText.attributes(at: 2, effectiveRange: nil)[.font] as! NSFont
            XCTAssertTrue(sub1Font1.fontDescriptor.symbolicTraits.contains(.bold))
            XCTAssertFalse(sub1Font1.fontDescriptor.symbolicTraits.contains(.italic))
            
            let sub1Font2 = formattedText.attributes(at: 7, effectiveRange: nil)[.font] as! NSFont
            XCTAssertTrue(sub1Font2.fontDescriptor.symbolicTraits.contains(.bold))
            XCTAssertTrue(sub1Font2.fontDescriptor.symbolicTraits.contains(.italic))
        } catch {
            XCTFail()
        }
    }
    
    func testParseBodyWithFontWithinBoldTag() {
        let text = "A <b><font color=\"blue\">Subtitle</font></b>"
        let parser = SubRipParser()
        do {
            let tokenizer = SubRipTokenizer()
            let (rawText, formattedText, _) = try parser.parseBody(tokenizer: tokenizer, subtitlesString: text)
            XCTAssertEqual(text, rawText)
            XCTAssertEqual("A Subtitle", formattedText.string)
            let sub1Color = formattedText.attributes(at: 2, effectiveRange: nil)[.foregroundColor] as! NSColor
            XCTAssertNotNil(sub1Color)
            XCTAssertEqual(sub1Color, NSColor.blue)
            
            let sub1Font1 = formattedText.attributes(at: 2, effectiveRange: nil)[.font] as! NSFont
            XCTAssertTrue(sub1Font1.fontDescriptor.symbolicTraits.contains(.bold))
            XCTAssertFalse(sub1Font1.fontDescriptor.symbolicTraits.contains(.italic))
        } catch {
            XCTFail()
        }
    }

    func testParseBodyWithBoldTagInsideFontTag() {
        let text = "A <font color=\"blue\"><b>Subtitle</b></font>"
        let parser = SubRipParser()
        do {
            let tokenizer = SubRipTokenizer()
            let (rawText, formattedText, _) = try parser.parseBody(tokenizer: tokenizer, subtitlesString: text)
            XCTAssertEqual(text, rawText)
            XCTAssertEqual("A Subtitle", formattedText.string)
            let sub1Color = formattedText.attributes(at: 2, effectiveRange: nil)[.foregroundColor] as! NSColor
            XCTAssertNotNil(sub1Color)
            XCTAssertEqual(sub1Color, NSColor.blue)
            
            let sub1Font1 = formattedText.attributes(at: 2, effectiveRange: nil)[.font] as! NSFont
            XCTAssertTrue(sub1Font1.fontDescriptor.symbolicTraits.contains(.bold))
            XCTAssertFalse(sub1Font1.fontDescriptor.symbolicTraits.contains(.italic))
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
            let sub1Font1 = formattedText.attributes(at: 2, effectiveRange: nil)[.font] as! NSFont
            XCTAssertTrue(sub1Font1.fontDescriptor.symbolicTraits.contains(.bold))
            XCTAssertFalse(sub1Font1.fontDescriptor.symbolicTraits.contains(.italic))
            
            let sub1Font2 = formattedText.attributes(at: 7, effectiveRange: nil)[.font] as! NSFont
            XCTAssertTrue(sub1Font2.fontDescriptor.symbolicTraits.contains(.bold))
            XCTAssertTrue(sub1Font2.fontDescriptor.symbolicTraits.contains(.italic))
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
            let sub1Font1 = formattedText.attributes(at: 2, effectiveRange: nil)[.font] as! NSFont
            XCTAssertTrue(sub1Font1.fontDescriptor.symbolicTraits.contains(.bold))
            XCTAssertFalse(sub1Font1.fontDescriptor.symbolicTraits.contains(.italic))
            
            let sub1Font2 = formattedText.attributes(at: 7, effectiveRange: nil)[.font] as! NSFont
            XCTAssertTrue(sub1Font2.fontDescriptor.symbolicTraits.contains(.bold))
            XCTAssertTrue(sub1Font2.fontDescriptor.symbolicTraits.contains(.italic))
            
            let sub1Font3 = formattedText.attributes(at: 15, effectiveRange: nil)[.font] as! NSFont
            XCTAssertTrue(sub1Font3.fontDescriptor.symbolicTraits.contains(.bold))
            XCTAssertFalse(sub1Font3.fontDescriptor.symbolicTraits.contains(.italic))
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
    
    func testIncompleteTag() {
        let text = "An <b>incomplete tag"
        let parser = SubRipParser()
        do {
            let tokenizer = SubRipTokenizer()
            let (rawText, formattedText, _) = try parser.parseBody(tokenizer: tokenizer, subtitlesString: text)
            XCTAssertEqual(text, rawText)
            XCTAssertEqual(text, formattedText.string)
        } catch {
            XCTFail()
        }
    }
    
    func testIncompleteTagInTag() throws {
        let text = "An <i><b>incomplete tag</i>"
        let expected = "An <b>incomplete tag"
        let parser = SubRipParser()
        do {
            let tokenizer = SubRipTokenizer()
            let (rawText, formattedText, _) = try parser.parseBody(tokenizer: tokenizer, subtitlesString: text)
            XCTAssertEqual(text, rawText)
            XCTAssertEqual(expected, formattedText.string)
            
            let sub1Font1 = formattedText.attributes(at: 3, effectiveRange: nil)[.font] as! NSFont
            XCTAssertTrue(sub1Font1.fontDescriptor.symbolicTraits.contains(.italic))
            XCTAssertFalse(sub1Font1.fontDescriptor.symbolicTraits.contains(.bold))
        } catch {
            XCTFail()
        }
    }
    
    func testEmptySubtitleBody() {
        let text = """
        1
        00:00:00,000 --> 00:00:05,000
        A Subtitle
        
        2
        00:00:10,123 --> 00:00:13,000
        
        3
        00:00:15,385 --> 00:00:22,348
        Another Subtitle
        """
        
        let parser = SubRipParser()
        do {
            try parser.parse(string: text, subtitleGenerator: newSubtitle)
        } catch {
            XCTFail()
            return
        }
        let subtitles = fetchSubtitles()
        
        XCTAssertEqual(subtitles.count, 3)
        XCTAssertEqual(subtitles[0].content, "A Subtitle")
        XCTAssertEqual(subtitles[0].startTime, 0.0, accuracy: 0.0001)
        XCTAssertEqual(subtitles[0].duration, 5.0, accuracy: 0.0001)
        
        XCTAssertEqual(subtitles[1].content, "")
        XCTAssertEqual(subtitles[1].startTime, 10.123, accuracy: 0.0001)
        XCTAssertEqual(subtitles[1].duration, 2.877, accuracy: 0.0001)

        XCTAssertEqual(subtitles[2].content, "Another Subtitle")
        XCTAssertEqual(subtitles[2].startTime, 15.385, accuracy: 0.0001)
        XCTAssertEqual(subtitles[2].duration, 6.963, accuracy: 0.0001)
    }
}
