//
//  TextWithAttributedString.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 12.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import SwiftUI
import AppKit.NSTextField

struct TextWithAttributedString: NSViewRepresentable {
    typealias NSViewType = NSTextField
    
    var attributedString: NSAttributedString
    
    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField(labelWithAttributedString: attributedString)
        return textField
    }
    
    func updateNSView(_ nsView: NSTextField, context: Context) {
        guard nsView.attributedStringValue != attributedString else { return }
        nsView.attributedStringValue = attributedString
    }
}
