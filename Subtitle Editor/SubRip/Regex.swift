//
//  Regex.swift
//  Kaleidoscope
//
//  Created by Matthew Cheok on 15/11/15.
//  Copyright © 2015 Matthew Cheok. All rights reserved.
//  Modified by Michael Seeberger on 07/07/20.
//
import Foundation

var expressions = [String: NSRegularExpression]()
public extension String {
    func firstMatch(regex: String) -> NSRange? {
        let expression: NSRegularExpression
        if let exists = expressions[regex] {
            expression = exists
        } else {
            expression = try! NSRegularExpression(pattern: regex, options: [])
            expressions[regex] = expression
        }
        
        let range = expression.rangeOfFirstMatch(in: self, options: [], range: NSMakeRange(0, self.count))
        if range.location != NSNotFound {
            return range
        }
        
        return nil
    }
}
