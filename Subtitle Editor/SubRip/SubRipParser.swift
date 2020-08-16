//
//  SubRipParser2.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 13.07.20.
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
import AppKit
import struct SwiftUI.Color

enum SubRipParseError: Error {
    case UnexpectedToken(expected: String, actual: SubRipToken)
}

/**
 This struct provides a parser for the sub rip subtitle format. It will parse the string using the SubRipTokenizer.
 
 When parsing a comlete subtitle file, the tokenizer will be created by `SubRipParser`. In case only the actual subtitle should be parsed using `parseBody(tokenizer, subtitleString)`, one must be provided.
 
 In order to create subtitles from the parsed string, the parser will require a closure that creates an instance of `Subtitle` that can be used. See the sample code in order to
 
 # Thread safety
 `SubRipParser` is thread safe, as it does not have state. Due to that, multiple subtitles can be parsed in parallel by the same parser.
 
 # Sample Code
 To use the parser, use something like the following
 ```
 let managedObjectContext = myMOC() // set this to your NSManagedObjectContext
 let subRipParser = SubRipParser()
 let subtitlesString = ... // load from disk or otherwise
 subRipParseer.parse(string: subtitlesString, subtitleGenerator: { return Subtitle(context: managedObjectContext) })
 ```
 */
struct SubRipParser {
    /**
     Parse the subtitles string. This will create subtitles using the `subtitleGenerator` param and populate the newly created subtitles with values.
     */
    func parse(string: String, subtitleGenerator: SubtitleGenerator) throws {
        let tokenizer = SubRipTokenizer()
        try parseAndCreateSubtitles(tokenizer: tokenizer, subtitlesString: string, subtitleGenerator: subtitleGenerator)
    }
    
    func parseAndCreateSubtitles(tokenizer: SubRipTokenizer, subtitlesString: String, subtitleGenerator: SubtitleGenerator) throws {
         let subtitles = subtitlesString.replacingOccurrences(of: "\r", with: "").components(separatedBy: "\n\n")
         for component in subtitles {
            if component.replacingOccurrences(of: "\n", with: "") == "" {
                continue
            }
            _ = try parseAndCreateSubtitle(tokenizer: tokenizer, subtitlesString: component, subtitleGenerator: subtitleGenerator)
        }
    }
    
    fileprivate func parseAndCreateSubtitle(tokenizer: SubRipTokenizer, subtitlesString: String, subtitleGenerator: SubtitleGenerator) throws -> String {
        var newSubtitlesString = skipWhiteSpaceAndNewlines(tokenizer: tokenizer, subtitlesString: subtitlesString)
        let counter: Int64!
        (counter, _, newSubtitlesString) = try parseInt(tokenizer: tokenizer, subtitlesString: newSubtitlesString)
        newSubtitlesString = try parseNewLine(tokenizer: tokenizer, subtitlesString: newSubtitlesString)
        
        newSubtitlesString = skipWhiteSpace(tokenizer: tokenizer, subtitlesString: newSubtitlesString)
        
        let startTime: Double!
        let endTime: Double!
        (startTime, endTime, newSubtitlesString) = try parseTimeLabels(tokenizer: tokenizer, subtitlesString: newSubtitlesString)
        
        let body: String!
        let formattedBody: NSAttributedString
        do {
            newSubtitlesString = try parseNewLine(tokenizer: tokenizer, subtitlesString: newSubtitlesString)
            (body, formattedBody, newSubtitlesString) = try parseBody(tokenizer: tokenizer, subtitlesString: newSubtitlesString)
        } catch {
            NSLog("Error parsing body. Assuming no content, add empty body: \(error). Here is my subtitle component:\n***\n\(subtitlesString)\n***")
            body = ""
            formattedBody = NSAttributedString(string: "")
        }
        
        let newSubtitle = subtitleGenerator()
        newSubtitle.counter = counter
        newSubtitle.startTime = startTime
        newSubtitle.duration = endTime - startTime
        newSubtitle.content = body
        newSubtitle.formattedContent = formattedBody.rtf(from: NSMakeRange(0, formattedBody.length))
        
        return newSubtitlesString
    }
    
    fileprivate func skipWhiteSpaceAndNewlines(tokenizer: SubRipTokenizer, subtitlesString: String) -> String {
        var subtitlesString = subtitlesString
        while true {
            let (token, newSubtitlesString) = tokenizer.nextToken(tokenList: tokenizer.whiteSpaceAndNewlines, content: subtitlesString)
            if !token.isSameType(asOneOf: [.Newline, .WhiteSpace("")]) {
                return subtitlesString
            }
            subtitlesString = newSubtitlesString
        }
    }
    
    fileprivate func skipWhiteSpace(tokenizer: SubRipTokenizer, subtitlesString: String) -> String {
        var subtitlesString = subtitlesString
        while true {
            let (token, newSubtitlesString) = tokenizer.nextToken(tokenList: tokenizer.whiteSpace, content: subtitlesString)
            if !token.isSameType(as: .WhiteSpace("")) {
                return subtitlesString
            }
            subtitlesString = newSubtitlesString
        }
    }
    
    fileprivate func parseArrowIgnoringWhitespace(tokenizer: SubRipTokenizer, subtitlesString: String) throws -> String {
        let subtitlesString = skipWhiteSpace(tokenizer: tokenizer, subtitlesString: subtitlesString)
        let (token, newSubtitlesString) = tokenizer.nextToken(tokenList: tokenizer.whiteSpace + [tokenizer.Arrow], content: subtitlesString)
        if !token.isSameType(as: .Arrow("")) {
            throw SubRipParseError.UnexpectedToken(expected: "-->", actual: token)
        }
        
        return skipWhiteSpace(tokenizer: tokenizer, subtitlesString: newSubtitlesString)
    }
    
    /**
     * Will return the white space. If no whitespace is encountered, an error is thrown.
     */
    fileprivate func parseWhiteSpace(tokenizer: SubRipTokenizer, subtitlesString: String) throws -> (whiteSpace: String, subtitlesString: String) {
        var subtitlesString = subtitlesString
        var whiteSpace = ""
        while true {
            let (token, newSubtitlesString) = tokenizer.nextToken(tokenList: tokenizer.whiteSpace, content: subtitlesString)
            switch token {
            case let .WhiteSpace(ws):
                whiteSpace += ws
                subtitlesString = newSubtitlesString
            default:
                if whiteSpace == "" {
                    throw SubRipParseError.UnexpectedToken(expected: "whitespace", actual: token)
                }
                return (whiteSpace, subtitlesString)
            }
        }
    }
    
    fileprivate func parseNewLine(tokenizer: SubRipTokenizer, subtitlesString: String) throws -> String {
        let (token, subtitlesString) = tokenizer.nextToken(tokenList: [tokenizer.NewLine], content: subtitlesString)
        if token != .Newline {
            throw SubRipParseError.UnexpectedToken(expected: "\\n", actual: token)
        }
        return subtitlesString
    }
    
    fileprivate func parseTimeLabels(tokenizer: SubRipTokenizer, subtitlesString: String) throws -> (startTime: Double, endTime: Double, subtitlesString: String) {
        var subtitlesString = subtitlesString
        let startTime: Double!
        (startTime, subtitlesString) = try parseTime(tokenizer: tokenizer, subtitlesString: subtitlesString)
        
        subtitlesString = try parseArrowIgnoringWhitespace(tokenizer: tokenizer, subtitlesString: subtitlesString)
        
        let endTime: Double!
        (endTime, subtitlesString) = try parseTime(tokenizer: tokenizer, subtitlesString: subtitlesString)
        
        return (startTime, endTime, subtitlesString)
    }
    
    func parseTime(tokenizer: SubRipTokenizer, subtitlesString: String) throws -> (time: Double, subtitlesString: String) {
        var newSubtitlesString = subtitlesString
        let hours: Int64!
        let minutes: Int64!
        let seconds: Double!
        (hours, _, newSubtitlesString) = try parseInt(tokenizer: tokenizer, subtitlesString: newSubtitlesString)
        var time = Double(hours * 3600)
        
        newSubtitlesString = try parseColon(tokenizer: tokenizer, subtitlesString: newSubtitlesString)
        
        (minutes, _, newSubtitlesString) = try parseInt(tokenizer: tokenizer, subtitlesString: newSubtitlesString)
        time += Double(minutes * 60)
        
        newSubtitlesString = try parseColon(tokenizer: tokenizer, subtitlesString: newSubtitlesString)
        
        (seconds, _, newSubtitlesString) = try parseFloat(tokenizer: tokenizer, subtitlesString: newSubtitlesString)
        time += seconds

        return (time, newSubtitlesString)
    }
    
    func parseBody(tokenizer: SubRipTokenizer, subtitlesString: String) throws -> (body: String, formattedBody: NSAttributedString, subtitlesString: String) {
        var subtitlesString = subtitlesString
        var rawString = ""
        let attributedString = NSMutableAttributedString(string: "")
        while true {
            var (currentToken, newSubtitlesString) = tokenizer.nextToken(tokenList: tokenizer.bodyTokens, content: subtitlesString)
            switch currentToken {
            case let .Other(content):
                rawString += content
                attributedString.append(NSAttributedString(string: content, attributes: [ .font: NSFont.systemFont(ofSize: NSFont.systemFontSize) ]))
            case .OpenLeftBrace:
                rawString += "{"
                do {
                    let newRawText: String!
                    let newAttributedString: NSAttributedString!
                    (newRawText, newAttributedString, newSubtitlesString) = try continueParsingTag(tokenizer: tokenizer, tagTokens: tokenizer.braceTagTokens, subtitlesString: newSubtitlesString)
                    rawString += newRawText
                    attributedString.append(newAttributedString)
                } catch {
                    // continue parsing, ignoring the open tag.
                    attributedString.append(NSAttributedString(string: "{"))
                }
            case .OpenLeftAngledBracket:
                rawString += "<"
                do {
                    let newRawText: String!
                    let newAttributedString: NSAttributedString!
                    (newRawText, newAttributedString, newSubtitlesString) = try continueParsingTag(tokenizer: tokenizer, tagTokens: tokenizer.angledTagTokens, subtitlesString: newSubtitlesString)
                    rawString += newRawText
                    attributedString.append(newAttributedString)
                } catch {
                    // continue parsing, ignoring the open tag.
                    attributedString.append(NSAttributedString(string: "<"))
                }
            case .EOF:
                return (rawString, attributedString, "")
            case .Newline:
                let (nlToken, nlSubtitlesString) = tokenizer.nextToken(tokenList: tokenizer.bodyTokens, content: newSubtitlesString)
                if nlToken == .Newline {
                    return (rawString, attributedString, nlSubtitlesString)
                } else {
                    rawString += "\n"
                    attributedString.append(NSAttributedString(string: "\n"))
                }
            default:
                throw SubRipParseError.UnexpectedToken(expected: "{, <, \n or text", actual: currentToken)
            }
            subtitlesString = newSubtitlesString
        }
    }
    
    /**
     Parse the rest of the tag, continuing from the opening bracket (e.g. {).
     - Parameters:
        - tokenizer: The tokenizer that should be used
        - tagTokens: An array of `TokenDefinition`s that should be used. For angled brackets, this should be `tokenizer.angledTagTokens`, for braces `tokenizer.braceTagTokens`
        - subtitlesString: The string that should be parsed. The parsing starts at the beginning of the string.
     - Returns: A tuple of items is returned:
        - `rawText` A string containing every part of the string that was parsed, including tags.
        - `formattedText` The formatted text. This does not include the formatting tags.
        - `subtitlesString` The rest of the string passed as thee `subtitlesString` parameter, that has not been parsed in the function.
     - Throws: If an unexpected token appears, an `SubRipParseError.UnexpectedToken` error is thrown.
     */
    fileprivate func continueParsingTag(tokenizer: SubRipTokenizer, tagTokens: [TokenDefinition], subtitlesString: String) throws -> (rawText: String, formattedText: NSAttributedString, subtitlesString: String) {
        let tokens = tagTokens + tokenizer.bodyTokens
        var rawText: String!
        var subtitlesString = subtitlesString
        let tagToken: SubRipToken! // tag token is the type of tag, (i, b or font)
        let attributes: [NSAttributedString.Key : Any]!
        let tagName: String!
        
        (tagName, attributes, tagToken, subtitlesString) = try parseTagType(tokenizer: tokenizer, subtitlesString: subtitlesString)
        rawText = tagName
        
        var formattedString = NSMutableAttributedString(string: "")

        // parse closing bracket
        let closingBracket: SubRipToken!
        (closingBracket, subtitlesString) = tokenizer.nextToken(tokenList: tagTokens, content: subtitlesString)
        switch closingBracket {
        case .RightBrace:
            rawText += "}"
        case .RightAngledBracket:
            rawText += ">"
        default:
            throw SubRipParseError.UnexpectedToken(expected: "closing bracket", actual: closingBracket)
        }
        
        // Parse content of tag
        while true {
            let token: SubRipToken!
            var newSubtitlesString: String!
            (token, newSubtitlesString) = tokenizer.nextToken(tokenList: tokens, content: subtitlesString)
            rawText += token.stringValue()
            switch token {
            case let .Other(content):
                formattedString.append(NSAttributedString(string: content))
            case .OpenLeftBrace:
                do {
                    let newRawText: String!
                    let newAttributedString: NSAttributedString!
                    (newRawText, newAttributedString, newSubtitlesString) = try continueParsingTag(tokenizer: tokenizer, tagTokens: tokenizer.braceTagTokens, subtitlesString: newSubtitlesString)
                    rawText += newRawText
                    formattedString.append(newAttributedString)
                } catch {
                    // continue parsing, ignoring the open tag.
                    formattedString.append(NSAttributedString(string: "{"))
                }
            case .OpenLeftAngledBracket:
                do {
                    let newRawText: String!
                    let newAttributedString: NSAttributedString!
                    (newRawText, newAttributedString, newSubtitlesString) = try continueParsingTag(tokenizer: tokenizer, tagTokens: tokenizer.angledTagTokens, subtitlesString: newSubtitlesString)
                    rawText += newRawText
                    formattedString.append(newAttributedString)
                } catch {
                    // continue parsing, ignoring the open tag.
                    formattedString.append(NSAttributedString(string: "<"))
                }
            case .CloseLeftBrace:
                let closingTag: SubRipToken!
                (closingTag, newSubtitlesString) = tokenizer.nextToken(tokenList: tagTokens + tokenizer.tagTokens, content: newSubtitlesString)
                if !closingTag.isSameType(as: tagToken) {
                    throw SubRipParseError.UnexpectedToken(expected: String(describing: tagToken), actual: closingTag)
                }
                rawText += tagToken.stringValue()
                let closingBracket: SubRipToken!
                (closingBracket, newSubtitlesString) = tokenizer.nextToken(tokenList: tagTokens, content: newSubtitlesString)
                if !closingBracket.isSameType(as: .RightBrace) {
                    throw SubRipParseError.UnexpectedToken(expected: "}", actual: closingBracket)
                }
                rawText += "}"
                let range = NSMakeRange(0, formattedString.length)
                if attributes[.font] != nil {
                    formattedString = combineFontTraits(formattedString, range: range, font: attributes[.font] as! NSFont)
                } else {
                    formattedString.addAttributes(attributes, range: range)
                }
                return (rawText, formattedString, newSubtitlesString)
            case .CloseLeftAngleBracket:
                let closingTag: SubRipToken!
                (closingTag, newSubtitlesString) = tokenizer.nextToken(tokenList: tagTokens + tokenizer.tagTokens, content: newSubtitlesString)
                if !closingTag.isSameType(as: tagToken) {
                    throw SubRipParseError.UnexpectedToken(expected: String(describing: tagToken), actual: closingTag)
                }
                rawText += tagToken.stringValue()
                let closingBracket: SubRipToken!
                (closingBracket, newSubtitlesString) = tokenizer.nextToken(tokenList: tagTokens, content: newSubtitlesString)
                if !closingBracket.isSameType(as: .RightAngledBracket) {
                    throw SubRipParseError.UnexpectedToken(expected: ">", actual: closingBracket)
                }
                rawText += ">"
                let range = NSMakeRange(0, formattedString.length)
                if attributes[.font] != nil {
                    formattedString = combineFontTraits(formattedString, range: range, font: attributes[.font] as! NSFont)
                } else {
                    formattedString.addAttributes(attributes, range: range)
                }

                return (rawText, formattedString, newSubtitlesString)
            case .Newline:
                let (nlToken, _) = tokenizer.nextToken(tokenList: tokenizer.bodyTokens, content: newSubtitlesString)
                if nlToken == .Newline {
                    throw SubRipParseError.UnexpectedToken(expected: "closing tag", actual: nlToken)
                } else {
                    formattedString.append(NSAttributedString(string: "\n"))
                }
            case .RightBrace:
                formattedString.append(NSAttributedString(string: "}"))
            case .RightAngledBracket:
                formattedString.append(NSAttributedString(string: ">"))
            default:
                throw SubRipParseError.UnexpectedToken(expected: "text or closing tag", actual: token)
            }
            subtitlesString = newSubtitlesString
        }
    }
    
    fileprivate func combineFontTraits(_ string: NSMutableAttributedString, range: NSRange, font: NSFont) -> NSMutableAttributedString {
        let newString = NSMutableAttributedString(string: string.string)
        let newTraits = font.fontDescriptor.symbolicTraits.rawValue
        newString.addAttributes([.font: font], range: range)
        
        string.enumerateAttribute(.font, in: range) { (rawFont: Any?, range: NSRange, shouldStop: UnsafeMutablePointer<ObjCBool>) in
            guard rawFont != nil else {
                return
            }
            
            let currentFont = rawFont as! NSFont
            let currentTraits = currentFont.fontDescriptor.symbolicTraits.rawValue
            let combinedTraits = currentTraits | newTraits
            let symbolicTraits = NSFontDescriptor.SymbolicTraits(rawValue: combinedTraits)
            
            let combinedDescriptor = currentFont.fontDescriptor.withSymbolicTraits(symbolicTraits)
            let combinedFont = NSFont(descriptor: combinedDescriptor, size: currentFont.pointSize)
            
            
            newString.addAttributes([.font : combinedFont ?? currentFont], range: range)
        }
        
        return newString
    }
    
    fileprivate func parseTagType(tokenizer: SubRipTokenizer, subtitlesString: String) throws -> (tagAsText: String, attributes: [NSAttributedString.Key : Any], tagToken: SubRipToken, subtitlesString: String) {
        let tagToken: SubRipToken
        var newSubtitlesString: String
        (tagToken, newSubtitlesString) = tokenizer.nextToken(tokenList: tokenizer.tagTokens, content: subtitlesString)
        var text: String!
        let attributes: [NSAttributedString.Key : Any]
        switch tagToken {
        case let .Font(fontString):
            text = fontString
            let color: NSColor
            let rawString: String
            (color, rawString, newSubtitlesString) = try parseFontAttributes(tokenizer: tokenizer, subtitlesString: newSubtitlesString)
            text += rawString
            attributes = [ .foregroundColor: color ]
        case let .Bold(boldTag):
            text = boldTag
            attributes = [ .font: NSFont.boldSystemFont(ofSize: NSFont.systemFontSize) ]
        case let .Italic(italicTag):
            text = italicTag
            let italicFont = NSFontManager.shared.convert(NSFont.systemFont(ofSize: NSFont.systemFontSize), toHaveTrait: NSFontTraitMask.italicFontMask)
            attributes = [ .font: italicFont ]
        case let .Underline(underlineTag):
            text = underlineTag
            attributes = [.underlineStyle: NSUnderlineStyle.single.rawValue]
        default:
            throw SubRipParseError.UnexpectedToken(expected: "font, b, u or i", actual: tagToken)
        }
        
        return (text, attributes, tagToken, newSubtitlesString)
    }
    
    fileprivate func parseFontAttributes(tokenizer: SubRipTokenizer, subtitlesString: String) throws -> (color: NSColor, rawString: String, subtitlesString: String) {
        var (rawText, subtitlesString) = try parseWhiteSpace(tokenizer: tokenizer, subtitlesString: subtitlesString)
        let colorAttrToken: SubRipToken!
        (colorAttrToken, subtitlesString) = tokenizer.nextToken(tokenList: tokenizer.fontAttributeTags, content: subtitlesString)
        guard case let .Color(colorAttr) = colorAttrToken else {
            throw SubRipParseError.UnexpectedToken(expected: "color", actual: colorAttrToken)
        }
        rawText += colorAttr
        
        // Expect =
        (_, subtitlesString) = try expect(token: .Assign, definition: tokenizer.EqualSign, tokenizer: tokenizer, subtitleString: subtitlesString)
        rawText += "="
        
        // Expect first "
        (_, subtitlesString) = try expect(token: .StringDelimiter, definition: tokenizer.StringDel, tokenizer: tokenizer, subtitleString: subtitlesString)
        rawText += "\""
        
        let color: NSColor
        let rawColorValue: String
        (color, rawColorValue, subtitlesString) = try parseFontColor(tokenizer: tokenizer, subtitleString: subtitlesString)
        rawText += rawColorValue
        
        // Expect second "
        (_, subtitlesString) = try expect(token: .StringDelimiter, definition: tokenizer.StringDel, tokenizer: tokenizer, subtitleString: subtitlesString)
        rawText += "\""
        
        return (color, rawText, subtitlesString)
    }
    
    private func parseFontColor(tokenizer: SubRipTokenizer, subtitleString: String) throws -> (color: NSColor, rawText: String, subtitleString: String) {
        do {
            return try parseHexFontColor(tokenizer: tokenizer, subtitleString: subtitleString)
        } catch {}
        
        do {
            return try parseNamedFontColor(tokenizer: tokenizer, subtitleString: subtitleString)
        } catch SubRipParseError.UnexpectedToken(_, let actual) {
            throw SubRipParseError.UnexpectedToken(expected: "hex number or color name", actual: actual)
        } catch {
            NSLog("Unexpected error in parseFontColor")
            throw error
        }
    }
    
    private func parseHexFontColor(tokenizer: SubRipTokenizer, subtitleString: String) throws -> (color: NSColor, rawText: String, subtitleString: String) {
        // Expect #
        var (_, newSubtitlesString) = try expect(token: .NumberSign, definition: tokenizer.NumberSign, tokenizer: tokenizer, subtitleString: subtitleString)
        var rawText = "#"
        
        let hexNumber: SubRipToken!
        (hexNumber, newSubtitlesString) = tokenizer.nextToken(tokenList: [tokenizer.HexValue], content: newSubtitlesString)
        let color: NSColor
        switch hexNumber {
        case let .IntValue(value, original):
            color = NSColor(rgb: Int(value))
            rawText += original
        default:
            throw SubRipParseError.UnexpectedToken(expected: "hex number", actual: hexNumber)
        }
        
        return (color, rawText, newSubtitlesString)
    }
    
    private func parseNamedFontColor(tokenizer: SubRipTokenizer, subtitleString: String) throws -> (color: NSColor, rawText: String, subtitleString: String) {
        let (token, newSubtitlesString) = tokenizer.nextToken(tokenList: [tokenizer.StringDel], content: subtitleString)
        guard case SubRipToken.Other(let colorName) = token else {
            throw SubRipParseError.UnexpectedToken(expected: "Color name", actual: token)
        }
        
        guard let colorValue = HTMLColors[colorName] else {
            throw SubRipParseError.UnexpectedToken(expected: "Invalid color name", actual: token)
        }
        
        return (NSColor(rgb: colorValue), colorName, newSubtitlesString)
    }
    
    private func expect(token: SubRipToken, definition: TokenDefinition, tokenizer: SubRipTokenizer, subtitleString: String) throws -> (token: SubRipToken, subtitleString: String) {
        let (actualToken, newSubtitleString) = tokenizer.nextToken(tokenList: [definition], content: subtitleString)
        guard actualToken.isSameType(as: token) else {
            throw SubRipParseError.UnexpectedToken(expected: "\(token)", actual: actualToken)
        }
        return (actualToken, newSubtitleString)
    }
    
    fileprivate func parseFloat(tokenizer: SubRipTokenizer, subtitlesString: String) throws -> (floatValue: Double, rawValue: String, subtitlesString: String) {
        let (token, string) = tokenizer.nextToken(tokenList: [tokenizer.FloatValue], content: subtitlesString)
        switch token {
        case let .FloatValue(floatValue, rawValue):
            return (floatValue, rawValue, string)
        default:
            throw SubRipParseError.UnexpectedToken(expected: "Float Value", actual: token)
        }
    }
    fileprivate func parseInt(tokenizer: SubRipTokenizer, subtitlesString: String) throws -> (intValue: Int64, rawValue: String, subtitlesString: String) {
        let (token, string) = tokenizer.nextToken(tokenList: [tokenizer.IntegerValue], content: subtitlesString)
        switch token {
        case let .IntValue(value, original):
            return (value, original, string)
        default:
            throw SubRipParseError.UnexpectedToken(expected: "Integer Value", actual: token)
        }
    }
    fileprivate func parseColon(tokenizer: SubRipTokenizer, subtitlesString: String) throws -> String {
        let (token, string) = tokenizer.nextToken(tokenList: [tokenizer.Colon], content: subtitlesString)
        if !token.isSameType(as: .Colon) {
            throw SubRipParseError.UnexpectedToken(expected: ":", actual: token)
        }
        
        return string
    }
}
