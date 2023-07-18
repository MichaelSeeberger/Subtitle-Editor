//
//  SubtitleDetailView.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 19.07.20.
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

struct SubtitleDetail: View {
    @ObservedObject var selectedSubtitle: Subtitle
    @Environment(\.managedObjectContext) var moc
    
    var parser = SubRipParser()
    private var subtitleString: Binding<String> { Binding (
        get: { return (self.selectedSubtitle.content ?? "") },
        set: {
            let lastChar = $0.last
            var newContent = $0.split(whereSeparator: \.isNewline)
                .joined(separator: "\n")
            
            if lastChar == "\n" {
                newContent += "\n"
            }
            
            guard self.selectedSubtitle.content != newContent else {
                return
            }
            
            self.moc.undoManager?.beginUndoGrouping()
            defer { self.moc.undoManager?.endUndoGrouping() }
            self.selectedSubtitle.content = newContent
            do {
                let (_, formatted, _) = try self.parser.parseBody(tokenizer: SubRipTokenizer(), subtitlesString: newContent)
                self.selectedSubtitle.formattedContent = formatted.rtf(from: NSMakeRange(0, formatted.string.count))
            } catch {
                NSLog("Could not parse body")
            }
        })
    }
    
    @ViewBuilder
    var textField: some View {
        if #available(macOS 13, iOS 16, *) {
            TextField("subtitle", text: subtitleString, axis: .vertical)
        } else {
            TextField("subtitle", text: subtitleString)
        }
    }
    
    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .leading) {
                    SubtitleTimes(subtitle: selectedSubtitle)
                    Divider()
                    textField
                        .lineLimit(nil)
                }
                Spacer()
            }
            .padding()
        }
    }
}



struct SubtitleDetail_Previews: PreviewProvider {
    static let stack = CoreDataStack()
    static var subtitle: Subtitle = {
        let s = Subtitle(context: stack.mainContext)
        s.startTime = 120.123
        s.duration = 15.835
        s.content = "My <b>attributed</b> string\nWith two lines"
        let attributedString = NSAttributedString(string: s.content!, attributes: [.font: NSFont.boldSystemFont(ofSize: 14.0)])
        
        s.formattedContent = attributedString.rtf(from: NSMakeRange(0, s.content!.count))
        
        return s
    }()
    
    static var previews: some View {
        SubtitleDetail(selectedSubtitle: subtitle)
            .environment(\.managedObjectContext, stack.mainContext)
    }
}
