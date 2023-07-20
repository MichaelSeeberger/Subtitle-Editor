//
//  Subtitle.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 20.07.23.
//  Copyright © 2023 Michael Seeberger. All rights reserved.
//

import Foundation

extension Subtitle {
    var content: String {
        get {
            self.content_ ?? ""
        }
        set {
            self.content_ = newValue
            self.formattedContent_ = nil
        }
    }
    
    var formattedContent: NSAttributedString {
        if formattedContent_ == nil {
            updateFormattedContent()
        }
        
        guard let data = formattedContent_ else {
            return NSAttributedString(string: "")
        }
        
        guard let attributedString = NSAttributedString(rtf: data, documentAttributes: nil) else {
            return NSAttributedString(string: "")
        }
        
        return attributedString
    }
    
    private func updateFormattedContent() {
        let parser = SubRipParser()
        do {
            let (_, formatted, _) = try parser.parseBody(tokenizer: SubRipTokenizer(), subtitlesString: content)
            self.formattedContent_ = formatted.rtf(from: NSMakeRange(0, formatted.string.count))
        } catch {
            NSLog("Could not parse body of \(content)")
        }
    }
}
