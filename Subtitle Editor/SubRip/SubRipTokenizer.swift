//
//  SubRipTokenizer.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 07.07.20.
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

typealias TokenDefinition = (String, TokenGenerator)

struct SubRipTokenizer {

    let WhiteSpace: TokenDefinition = ("[ \t]", { (r: String) in .WhiteSpace(r) })
    let NewLine: TokenDefinition = ("\r*\n", { _ in .Newline })
    let FloatValue: TokenDefinition = ("[0-9]+[,\\.][0-9]+", { (r: String) in .FloatValue(value: (r.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil) as NSString).doubleValue, original: r) })
    let IntegerValue: TokenDefinition = ("[0-9]+", { (r: String) in .IntValue(value: (r as NSString).longLongValue, original: r) })
    let Arrow: TokenDefinition = ("-+>", { (r: String) in .Arrow(r) })
    let OpenLeftAngledBracket: TokenDefinition = ("<", { _ in .OpenLeftAngledBracket })
    let RightAngledBracket: TokenDefinition = (">", { _ in .RightAngledBracket })
    let OpenLeftBrace: TokenDefinition = ("\\{", { _ in .OpenLeftBrace })
    let RightBrace: TokenDefinition = ("\\}", { _ in .RightBrace})
    let CloseLeftAngledBracket: TokenDefinition = ("</", { _ in .CloseLeftAngleBracket })
    let CloseLeftBrace: TokenDefinition = ("\\{/", { _ in .CloseLeftBrace } )
    let Colon: TokenDefinition = (":", { _ in .Colon })
    let BoldTag: TokenDefinition = ("b", { (r: String) in .Bold(r) })
    let ItalicTag: TokenDefinition = ("i", { (r: String) in .Italic(r) })
    let FontTag: TokenDefinition = ("font", { (r: String) in .Font(r) })
    let ColorAttr: TokenDefinition = ("color", { (r: String) in .Color(r) })
    let StringDel: TokenDefinition = ("\"", { _ in .StringDelimiter })
    let NumberSign: TokenDefinition = ("#", { _ in .NumberSign })
    let EqualSign: TokenDefinition = ("=", { _ in .Assign })
    let ColorName: TokenDefinition = ("[a-zA-Z]+", { (r: String) in .ColorName(r) })
    

    var counterTagTokens: [TokenDefinition] {
        return [
            IntegerValue,
            NewLine
        ]
    }

    var timeLineTokens: [TokenDefinition] {
        return[
            FloatValue,
            IntegerValue,
            Colon,
            WhiteSpace,
            NewLine
        ]
    }

    var bodyTokens: [TokenDefinition] {
        return [
            OpenLeftBrace,
            OpenLeftAngledBracket,
            NewLine
        ]
    }
    
    var tagTokens: [TokenDefinition] {
        return [
            BoldTag,
            ItalicTag,
            FontTag
        ]
    }
    
    var braceTagTokens: [TokenDefinition] {
        return [
            CloseLeftBrace,
            RightBrace
        ]
    }
    
    var angledTagTokens: [TokenDefinition] {
        return [
            CloseLeftAngledBracket,
            RightAngledBracket
        ]
    }
    
    var fontAttributeTags: [TokenDefinition] {
        return [
            FontTag,
            IntegerValue,
            ColorAttr,
            EqualSign,
            NumberSign,
            ColorName
        ]
    }
    
    var whiteSpaceAndNewlines: [TokenDefinition] {
        return [
            WhiteSpace,
            NewLine
        ]
    }
    
    var whiteSpace: [TokenDefinition] {
        return [ WhiteSpace ]
    }
    
    fileprivate func firstMatch(_ tokenList: [(String, TokenGenerator)], _ content: String) -> (matchedString: String, token: SubRipToken) {
        var closestRange: NSRange?
        for (pattern, generator) in tokenList {
            guard let firstMatch:NSRange = content.firstMatch(regex: pattern) else {
                continue
            }
            
            if firstMatch.location == 0 {
                let matchedString: String = (content as NSString).substring(with: firstMatch)
                return (matchedString, generator(matchedString))
            }
            
            if closestRange == nil || closestRange!.location > firstMatch.location {
                closestRange = firstMatch
            }
        }
        
        guard let detectedRange = closestRange else {
            return (content, .Other(content))
        }
        let rangeToString = NSMakeRange(0, detectedRange.location)
        let matchedString: String = (content as NSString).substring(with: rangeToString)
        
        return (matchedString, .Other(matchedString))
    }
    
    func nextToken(tokenList: [(String, TokenGenerator)], content: String) -> (token: SubRipToken, newContent: String) {
        if content.count == 0 {
            return (.EOF, "")
        }
        
        let (matchedString, token) = firstMatch(tokenList, content)
        return (token, String(content[matchedString.endIndex...]))
    }
}
