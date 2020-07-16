//
//  SubRipToken.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 07.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import Foundation

public enum SubRipToken: Equatable {
    case Newline
    case WhiteSpace(String)
    case IntValue(value: Int64, original: String)
    case FloatValue(value: Double, original: String)
    case OpenLeftAngledBracket // <
    case CloseLeftAngleBracket // </
    case RightAngledBracket // >
    case OpenLeftBrace // {
    case CloseLeftBrace // {/
    case RightBrace // }
    case Arrow(String)
    case Colon
    case Other(String)
    case ColorName(String)
    
    case Bold(String)
    case Italic(String)
    case Font(String)
    case Color(String) // color attribute in font tag
    case StringDelimiter // "
    case Assign // =
    case NumberSign // #
    
    case EOF
    
    func isSameType(as otherToken: SubRipToken) -> Bool {
        if self == otherToken {
            return true
        }
        
        switch (self, otherToken) {
        case (.WhiteSpace(_), .WhiteSpace(_)): return true
        case (.IntValue(_, _), .IntValue(_, _)): return true
        case (.FloatValue(_, _), .FloatValue(_, _)): return true
        case (.Other(_), .Other(_)): return true
        case (.Arrow(_), .Arrow(_)): return true
        case (.ColorName(_), .ColorName(_)): return true
        case (.Bold(_), .Bold(_)): return true
        case (.Italic(_), .Italic(_)): return true
        case (.Font(_), .Font(_)): return true
        case (.Color(_), .Color(_)): return true
        default: return false
        }
    }
    
    func isSameType(asOneOf otherTokens: [SubRipToken]) -> Bool {
        for token in otherTokens {
            if self.isSameType(as: token) {
                return true
            }
        }
        
        return false
    }
}

typealias TokenGenerator = (String) -> SubRipToken

let tokenList: [(String, TokenGenerator)] = [
    ("[ \t]", { (r: String) in .WhiteSpace(r) }),
    ("\r*\n", { _ in .Newline }),
    ("[0-9]+[,\\.][0-9]+", { (r: String) in .FloatValue(value: (r.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil) as NSString).doubleValue, original: r) }),
    ("[0-9]+", { (r: String) in .IntValue(value: (r as NSString).longLongValue, original: r) }),
    ("-+>", { (r: String) in .Arrow(r) }),
    ("</", { _ in .CloseLeftAngleBracket }),
    ("\\{/", { _ in .CloseLeftBrace } ),
    ("<", { _ in .OpenLeftAngledBracket }),
    (">", { _ in .RightAngledBracket }),
    ("\\{", { _ in .OpenLeftBrace }),
    ("\\}", { _ in .RightBrace}),
    (":", { _ in .Colon })
]

// Tokens that are valid only inside a tag ({} or <>)
let tagTokenList: [(String, TokenGenerator)] = [
    ("b", { (r: String) in .Bold(r) }),
    ("i", { (r: String) in .Italic(r) }),
    ("font", { (r: String) in .Font(r) }),
    ("color", { (r: String) in .Color(r) }),
    ("\"", { _ in .StringDelimiter }),
    ("#", { _ in .NumberSign }),
    ("=", { _ in .Assign })
]

