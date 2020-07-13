//
//  SubRipTokenizer.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 07.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import Foundation

struct SubRipTokenizer {
    private let input: String
    
    public typealias TokenDefinition = (String, TokenGenerator)

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
            CloseLeftBrace,
            CloseLeftAngledBracket,
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

    init(string: String) {
        input = string
    }
    
    fileprivate func matchLongest(_ currentTokenList: [(String, TokenGenerator)], _ content: String) -> (matchedString: String, token: SubRipToken)? {
        var longestMatch: (matchedString: String, token: SubRipToken)?
        for (pattern, generator) in currentTokenList {
            guard let match = content.match(regex: pattern) else {
                continue
            }
            
            if longestMatch == nil || longestMatch!.matchedString.count < match.count {
                longestMatch = (match, generator(match))
            }
        }
        return longestMatch
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
            
            /*guard let match = content.match(regex: pattern) else {
                continue
            }
            
            return (match, generator(match))*/
        }
        
        guard let detectedRange = closestRange else {
            return (content, .Other(content))
        }
        let rangeToString = NSMakeRange(0, detectedRange.location)
        let matchedString: String = (content as NSString).substring(with: rangeToString)
        
        return (matchedString, .Other(matchedString))
    }
    
    /**
     * Tokenize will match the longest possible string.
     */
    func tokenize() -> [SubRipToken] {
        var content = input
        var unmatchedString = ""
        var currentTokenList = tokenList
        var tokenListStack: [[(String, TokenGenerator)]] = []
        var popTokenListOn = [SubRipToken]()
        var tokens = [SubRipToken]()
        
        func addUnmatchedStringToTokenList() {
            if unmatchedString.count > 0 {
                tokens.append(SubRipToken.Other(unmatchedString))
                unmatchedString = ""
            }
        }

        while content.count > 0 {
            /*guard let (match, newToken) = matchLongest(currentTokenList, content) else {
                let index = content.index(after: content.startIndex)
                unmatchedString += content[..<index]
                content = String(content[index...])
                
                continue
            }*/
            /*guard let (match, newToken) = firstMatch(currentTokenList, content) else {
                let index = content.index(after: content.startIndex)
                unmatchedString += content[..<index]
                content = String(content[index...])
                
                continue
            }*/
            let (match, newToken) = firstMatch(currentTokenList, content)
            
            content = String(content[match.endIndex...])
            
            addUnmatchedStringToTokenList()
            
            tokens.append(newToken)
            
            func updateTokenListStack(popOn: SubRipToken) {
                tokenListStack.append(currentTokenList)
                currentTokenList = tagTokenList + tokenList
                popTokenListOn.append(popOn)
            }
            
            if newToken == .OpenLeftAngledBracket || newToken == .CloseLeftAngleBracket {
                updateTokenListStack(popOn: .RightAngledBracket)
            } else if newToken == .OpenLeftBrace || newToken == .CloseLeftBrace {
                updateTokenListStack(popOn: .RightBrace)
            } else if let popToken = popTokenListOn.last {
                if popToken == newToken {
                    popTokenListOn.removeLast()
                    currentTokenList = tokenListStack.popLast()! // if this is not set, crash... something went horribly wrong!
                }
            }
        }
        
        addUnmatchedStringToTokenList()
        tokens.append(SubRipToken.EOF)
        
        return tokens
    }
    
    func nextToken(tokenList: [(String, TokenGenerator)], content: String) -> (token: SubRipToken, newContent: String) {
        if content.count == 0 {
            return (.EOF, "")
        }
        
        let (matchedString, token) = firstMatch(tokenList, content)
        return (token, String(content[matchedString.endIndex...]))
    }
}
