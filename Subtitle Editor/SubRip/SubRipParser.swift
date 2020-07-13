//
//  SubRipParser.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 05.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import Foundation
import struct SwiftUI.Color
import class AppKit.NSFont
import class AppKit.NSFontDescriptor
import class AppKit.NSFontManager
import struct AppKit.NSFontTraitMask
import CoreData

enum SubRipParseError: Error {
    case UnexpectedToken(expected: String, actual: SubRipToken)
}

enum TagType {
    case Bold
    case Italic
    case Font
}

enum BracketType {
    case Curly
    case Angled
}

struct SubRipParser {
    let tokens: [SubRipToken]
    var index = 0
    
    private func peek() -> SubRipToken {
        return tokens[index]
    }
    
    private func currentToken() -> SubRipToken {
        return tokens[index - 1]
    }
    
    private mutating func pop() -> SubRipToken {
        let token = tokens[index]
        index += 1
        return token
    }
    
    private mutating func skipWhiteSpace() {
        while case SubRipToken.WhiteSpace(_) = peek() {
            _ = pop()
        }
    }
    
    private mutating func returnWhiteSpace() -> String {
        var content = ""
        while case let SubRipToken.WhiteSpace(string) = peek() {
            content += string
            _ = pop()
        }
        return content
    }
    
    private mutating func skipWhiteSpaceAndNewLines() {
        var nextToken = peek()
        while nextToken.isSameType(asOneOf: [.WhiteSpace(" "), .Newline]) {
            _ = pop()
            nextToken = peek()
        }
    }
    
    mutating func parseSubtitles(generator: SubtitleGenerator) throws {
        skipWhiteSpaceAndNewLines()
        while index < tokens.count && !peek().isSameType(as: .EOF) {
            try parseSubtitle(generator: generator)
            skipWhiteSpaceAndNewLines()
        }
    }
    
    private mutating func parseSubtitle(generator: SubtitleGenerator) throws {
        let subtitleID = try parseInteger().value
        try parseNewLine()
        skipWhiteSpace()
        
        let startTime = try parseTime()
        skipWhiteSpace()
        
        try parseArrow()
        skipWhiteSpace()
        
        let endTime = try parseTime()
        skipWhiteSpace()
        try parseNewLine()
        
        let (original, formatted) = try parseBody()
        
        let subtitle = generator()
        subtitle.counter = subtitleID
        subtitle.startTime = startTime
        subtitle.duration = endTime - startTime
        subtitle.content = original
        subtitle.formattedContent = formatted.rtf(from: NSMakeRange(0, formatted.length))
    }
    
    private mutating func parseNewLine() throws {
        guard SubRipToken.Newline == pop() else {
            throw SubRipParseError.UnexpectedToken(expected: "NewLine", actual: currentToken())
        }
    }
    
    private mutating func parseInteger() throws -> (value: Int64, original: String) {
        guard case let SubRipToken.IntValue(value, original) = pop() else {
            throw SubRipParseError.UnexpectedToken(expected: "Integer", actual: currentToken())
        }
        
        return (value, original)
    }
    
    private mutating func parseFloat() throws -> (value: Double, original: String) {
        guard case let SubRipToken.FloatValue(value, original) = pop() else {
            throw SubRipParseError.UnexpectedToken(expected: "Float", actual: currentToken())
        }
        
        return (value, original)
    }
    
    private mutating func parseTime() throws -> Double {
        var time = try Double(parseInteger().value * 3600)
        
        if SubRipToken.Colon != pop() {
            throw SubRipParseError.UnexpectedToken(expected: "Colon", actual: currentToken())
        }
        
        time += try Double(parseInteger().value * 60)
        
        if SubRipToken.Colon != pop() {
            throw SubRipParseError.UnexpectedToken(expected: "Colon", actual: currentToken())
        }
        
        time += try parseFloat().value

        return time
    }
    
    /**
     * Parse the body part of a subtitle (the actual subtitle).
     */
    mutating func parseBody() throws -> (original: String, formatted: NSAttributedString) {
        var text = ""
        var attributedText = NSMutableAttributedString(string: "")
        while true {
            let token = peek()
            func popAndAppend() {
                let string = textForToken(token: pop())
                text += string
                attributedText.append(NSAttributedString(string: string))
            }
            
            switch token {
            case .OpenLeftBrace,
                 .OpenLeftAngledBracket:
                let currentIndex = index
                do {
                    let (result, attributedString) = try parseTag()
                    text += result
                    attributedText.append(attributedString)
                } catch {
                    index = currentIndex
                    popAndAppend()
                }
            case .EOF:
                return (text, attributedText)
            case .Newline:
                _ = pop()
                if peek() == .Newline {
                    _ = pop()
                    return (text, attributedText)
                }
                text += "\n"
                attributedText.append(NSAttributedString(string: "\n"))
            default:
                popAndAppend()
            }
        }
    }
    
    /**
     * Parse the end token of a tag. This returns a tuple. where the success element is set to true when the end tag has been parsed. rawText contains the text the end tag had, e.g. </b> or < /b > (both allowed)
     */
    private mutating func parseEndToken(endTokenStart: SubRipToken, tagToken: SubRipToken) -> (success: Bool, rawText: String?) {
        let storedIndex = index
        
        var currentToken = pop()
        if !currentToken.isSameType(as: endTokenStart) {
            index = storedIndex
            return (false, nil)
        }
        var scannedText = textForToken(token: currentToken)
        
        currentToken = pop()
        scannedText += textForToken(token: currentToken)
        if !currentToken.isSameType(as: tagToken) {
            index = storedIndex
            return (false, nil)
        } // should now have reached </b
        
        currentToken = pop()
        scannedText += textForToken(token: currentToken)
        if endTokenStart.isSameType(as: .CloseLeftBrace) && currentToken.isSameType(as: .RightBrace) {
            return (true, scannedText)
        } else if currentToken.isSameType(as: .RightAngledBracket) {
            return (true, scannedText)
        } else {
            index = storedIndex
            return (false, nil)
        }
    }
    
    /**
     * Returns a tuple, where success is true when a tag has been parsed. The text parsed will be returned as parsedTag (including e.g. <b>...</b>) and the formatted text as attributedString (without the <b></b> tags).
     *
     * If an error occurs, the stack pointer will be reset to the point it had when parseTag() was called.
     *
     * In case success is false, parsedTag and attributedString are nil
     */
    private mutating func parseTag() throws -> (parsedTag: String, attributedString: NSAttributedString) {
        var text = ""
        let token = pop()
        var endToken: SubRipToken!
        let expectedRightBracket: SubRipToken!
        // parse the opening tag (e.g. <
        switch token {
        case .OpenLeftBrace:
            endToken = .CloseLeftBrace
            expectedRightBracket = .RightBrace
            text += "{"
        case .OpenLeftAngledBracket:
            endToken = .CloseLeftAngleBracket
            expectedRightBracket = .RightAngledBracket
            text += "<"
        default:
            throw SubRipParseError.UnexpectedToken(expected: "{ or <", actual: token)
        }

        // check what kind of tag it is (b, i or font)
        let tagToken = pop()
        var attribute: [NSAttributedString.Key : Any]!
        switch tagToken {
        case let .Font(fontString):
            text += fontString
            let (color, string) = try parseFontAttributes()
            text += string
            attribute = [ .foregroundColor: color ]
        case let .Bold(boldTag):
            text += boldTag
            attribute = [ .font: NSFont.boldSystemFont(ofSize: NSFont.systemFontSize) ]
        case let .Italic(italicTag):
            text += italicTag
            let italicFont = NSFontManager.shared.convert(NSFont.systemFont(ofSize: NSFont.systemFontSize), toHaveTrait: NSFontTraitMask.italicFontMask)
            attribute = [ .font: italicFont ]
        default:
            throw SubRipParseError.UnexpectedToken(expected: "font, b or i", actual: tagToken)
        }
        
        let closingToken = pop()
        if !closingToken.isSameType(as: expectedRightBracket) {
            throw SubRipParseError.UnexpectedToken(expected: "", actual: expectedRightBracket)
        } else if closingToken == .RightAngledBracket {
            text += ">"
        } else {
            text += "}"
        }
        
        var attributedText = NSAttributedString(string: "", attributes: attribute)
        
        // parse text until EOF or the closing tag was encountered
        while !peek().isSameType(as: .EOF) {
            let (success, rawPartial) = parseEndToken(endTokenStart: endToken, tagToken: tagToken)
            if success {
                text += rawPartial!
                return (text, attributedText)
            }
            
            let nextToken = peek()
            switch nextToken {
            case .OpenLeftBrace,
                 .OpenLeftAngledBracket:
                let currentIndex = index
                do {
                    let (result, attributedString) = try parseTag()
                    (text, attributedText) = append(newString: result, newAttributedString: attributedString, rawText: text, attributedText: attributedText)
                } catch {
                    index = currentIndex
                    (text, attributedText) = popAndAppend(rawText: text, attributedText: attributedText)
                }
            case .Newline:
                (text, attributedText) = popAndAppend(rawText: text, attributedText: attributedText)
                if peek() == .Newline {
                    throw SubRipParseError.UnexpectedToken(expected: "closing tag", actual: .Newline)
                }
            default:
                (text, attributedText) = popAndAppend(rawText: text, attributedText: attributedText)
            }
        }
        
        throw SubRipParseError.UnexpectedToken(expected: "closing tag", actual: .EOF)
    }
    
    /*
     * If there is an error while parsing, an exception is throwns.
     *
     * color may be nil in case of something like <font>text</font>
     * This will return before popping the closing > or }
     */
    private mutating func parseFontAttributes() throws -> (color: Color, alternative: String) {
        var rawTextValue = returnWhiteSpace()
        
        var next = peek()
        if next.isSameType(asOneOf: [.RightBrace, .RightAngledBracket]) {
            throw SubRipParseError.UnexpectedToken(expected: "color", actual: next)
        }
        
        guard case let SubRipToken.Color(colorTag) = pop()  else {
            throw SubRipParseError.UnexpectedToken(expected: "color", actual: currentToken())
        }
        
        rawTextValue += colorTag
        next = pop()
        rawTextValue += returnWhiteSpace()
        next = peek()
        if !next.isSameType(as: SubRipToken.Assign) {
            throw SubRipParseError.UnexpectedToken(expected: "=", actual: next)
        }
        _ = pop()
        
        var requireStringDelimiter = true
        if !next.isSameType(as: .StringDelimiter) {
            requireStringDelimiter = false
        }
        
        rawTextValue = returnWhiteSpace()
        next = pop()
        let color: Color!
        switch next {
        case .NumberSign:
            rawTextValue += textForToken(token: next)
            let (colorValue, rawValue) = try parseInteger()
            rawTextValue += rawValue
            color = Color(rgb: Int(colorValue))
        case let .Other(colorName):
            guard let colorValue: Int = HTMLColors[colorName] else {
                throw SubRipParseError.UnexpectedToken(expected: "valid color name or hex value", actual: next)
            }
            
            color = Color(rgb: Int(colorValue))
            rawTextValue += colorName
        default:
            throw SubRipParseError.UnexpectedToken(expected: "Hex value or color name", actual: next)
        }
        
        
        rawTextValue += returnWhiteSpace()
        if requireStringDelimiter {
            guard peek() == SubRipToken.StringDelimiter else {
                throw SubRipParseError.UnexpectedToken(expected: "\"", actual: peek())
            }
            _ = pop()
        }
        
        return (color, rawTextValue)
    }
    
    private mutating func popAndAppend(rawText: String, attributedText: NSAttributedString) -> (rawText: String, attributedText: NSAttributedString) {
        let value = textForToken(token: pop())
        return append(newString: value, rawText: rawText, attributedText: attributedText)
    }
    
    private func append(newString: String, rawText: String, attributedText: NSAttributedString) -> (rawText: String, attributedText: NSAttributedString) {
        return append(newString: newString, newAttributedString: NSAttributedString(string: newString), rawText: rawText, attributedText: attributedText)
    }
    
    private func append(newString: String, newAttributedString: NSAttributedString, rawText: String, attributedText: NSAttributedString) -> (rawText: String, attributedText: NSAttributedString) {
        let concatenatedAttributedString = NSMutableAttributedString(attributedString: attributedText)
        concatenatedAttributedString.append(newAttributedString)
        
        return (rawText + newString, concatenatedAttributedString)
    }
    
    private func textForToken(token: SubRipToken) -> String {
        switch token {
        case let .Other(textValue):
            return textValue
        case .OpenLeftBrace:
            return "{"
        case .OpenLeftAngledBracket:
            return "<"
        case .CloseLeftBrace:
            return "{/"
        case .CloseLeftAngleBracket:
            return "</"
        case .RightAngledBracket:
            return ">"
        case .RightBrace:
            return "}"
        case let .WhiteSpace(string):
            return string
        case .Colon:
            return ":"
        case let .IntValue(value: _, original: string):
            return string
        case let .FloatValue(value: _, original: string):
            return string
        case let .Bold(text):
            return text
        case let .Italic(text):
            return text
        case let .Font(text):
            return text
        case let .Color(text):
            return text
        case .StringDelimiter:
            return "\""
        case .NumberSign:
            return "#"
        case .Newline:
            return "\n"
        case let .Arrow(text):
            return text
        case .Assign:
            return "="
        case .EOF:
            return ""
        case let .ColorName(colorName):
            return colorName
        }
    }
    
    private mutating func parseArrow() throws {
        guard case SubRipToken.Arrow(_) = pop() else {
            throw SubRipParseError.UnexpectedToken(expected: "Arrow (-->)", actual: currentToken())
        }
    }
}
