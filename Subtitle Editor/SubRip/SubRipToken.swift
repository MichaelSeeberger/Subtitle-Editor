//
//  SubRipToken.swift
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
    case Underline(String)
    case Font(String)
    case Color(String) // color attribute in font tag
    case StringDelimiter // "
    case Assign // =
    case NumberSign // #
    
    case EOF
}

extension SubRipToken {
    func stringValue() -> String {
        switch self {
        case .Newline:
            return "\n"
        case .WhiteSpace(let ws):
            return ws
        case .IntValue(value: _, original: let original):
            return original
        case .FloatValue(value: _, original: let original):
            return original
        case .OpenLeftAngledBracket:
            return "<"
        case .CloseLeftAngleBracket:
            return "</"
        case .RightAngledBracket:
            return ">"
        case .OpenLeftBrace:
            return "{"
        case .CloseLeftBrace:
            return "{/"
        case .RightBrace:
            return "}"
        case .Arrow(let arrow):
            return arrow
        case .Colon:
            return ":"
        case .Other(let text):
            return text
        case .ColorName(let name):
            return name
        case .Bold(let tag):
            return tag
        case .Italic(let tag):
            return tag
        case .Underline(let tag):
            return tag
        case .Font(let tag):
            return tag
        case .Color(let value):
            return value
        case .StringDelimiter:
            return "\""
        case .Assign:
            return "="
        case .NumberSign:
            return "#"
        case .EOF:
            return ""
        }
    }
}

extension SubRipToken {
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
        case (.Underline(_), .Underline(_)): return true
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
