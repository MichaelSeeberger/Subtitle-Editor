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
            if self.selectedSubtitle.content == $0 {
                return
            }
            self.moc.undoManager?.beginUndoGrouping()
            defer { self.moc.undoManager?.endUndoGrouping() }
            self.selectedSubtitle.content = $0
            do {
                let (_, formatted, _) = try self.parser.parseBody(tokenizer: SubRipTokenizer(), subtitlesString: $0)
                self.selectedSubtitle.formattedContent = formatted.rtf(from: NSMakeRange(0, formatted.string.count))
            } catch {
                NSLog("Could not parse body")
            }
        })
    }
    
    @ViewBuilder
    private func textField(_ label: LocalizedStringKey, text: Binding<String>) -> some View {
        if #available(macOS 13, iOS 16, *) {
            TextField(label, text: text, axis: .vertical)
                .lineLimit(5...)
        } else {
            TextField(label, text: text)
        }
    }
    
    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .leading) {
                    SubtitleTimes(subtitle: selectedSubtitle)
                        .padding()
                    Divider()
                    textField("Subtitle Text", text: subtitleString)
                        .padding()
                    Text("Use \u{2325}-\u{23CE} for new line")
                        .font(.footnote)
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
