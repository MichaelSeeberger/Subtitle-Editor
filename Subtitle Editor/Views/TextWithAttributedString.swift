//
//  TextWithAttributedString.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 12.07.20.
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

struct TextWithAttributedString_Previews: PreviewProvider {
    static var previews: some View {
        TextWithAttributedString(attributedString: NSAttributedString(string: "A string\nwith two lines"))
    }
}
