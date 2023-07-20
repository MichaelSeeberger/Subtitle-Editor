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
    @Environment(\.managedObjectContext) var context
    @Environment(\.undoManager) var undoManager
    
    var parser = SubRipParser()
    private var subtitleString: Binding<String> { Binding (
        get: { self.selectedSubtitle.content },
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
            
            undoManager?.registerUndo(withTarget: self.selectedSubtitle, handler: { subtitle in
                guard subtitle.managedObjectContext != nil else { return }
                
                subtitle.content = self.selectedSubtitle.content
            })
            
            self.selectedSubtitle.content = newContent
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
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button {
                    withAnimation {
                        delete(subtitle: selectedSubtitle)
                    }
                } label: {
                    Label("Delete subtitle", systemImage: "minus")
                }
            }
        }
    }
}

extension SubtitleDetail {
    fileprivate func delete(subtitle: Subtitle) {
        let startTime = subtitle.startTime
        let duration = subtitle.duration
        let content = subtitle.content

        undoManager?.beginUndoGrouping()
        defer { undoManager?.endUndoGrouping() }
        
        undoManager?.registerUndo(withTarget: context, handler: { _ in
            withAnimation {
                let newSubtitle = Subtitle(context: context)
                newSubtitle.startTime = startTime
                newSubtitle.duration = duration
                newSubtitle.content = content
                    try? context.save()
                }
            })
        context.delete(subtitle)
        try? context.save()
    }
}

struct SubtitleDetail_Previews: PreviewProvider {
    static let stack = CoreDataStack()
    static var subtitle: Subtitle = {
        let s = Subtitle(context: stack.mainContext)
        s.startTime = 120.123
        s.duration = 15.835
        s.content = "My <b>attributed</b> string\nWith two lines"

        return s
    }()
    
    static var previews: some View {
        SubtitleDetail(selectedSubtitle: subtitle)
            .environment(\.managedObjectContext, stack.mainContext)
    }
}
