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
    var selectedSubtitleID: UUID
    @Environment(\.undoManager) var undoManager
    @EnvironmentObject var document: SubRipDocument
    
    var selectedSubtitle: Subtitle {
        document.subtitlesById[selectedSubtitleID]!
    }
    
    var parser = SubRipParser()
    private var subtitleString: Binding<String> { Binding (
        get: { selectedSubtitle.content },
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
            
            let oldContent = self.selectedSubtitle.content
            undoManager?.registerUndo(withTarget: document, handler: { document in
                document.updateSubtitle(with: self.selectedSubtitle.id, content: oldContent)
            })
            
            document.updateSubtitle(with: selectedSubtitle.id, content: newContent)
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
                    //SubtitleTimes(subtitle: $selectedSubtitle)
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
        let id = subtitle.id
        let startTime = subtitle.startTime
        let duration = subtitle.duration
        let content = subtitle.content

        undoManager?.beginUndoGrouping()
        defer { undoManager?.endUndoGrouping() }
        
        undoManager?.registerUndo(withTarget: document, handler: { document in
            withAnimation {
                let _ = document.newSubtitle(id: id, content: content, startTime: startTime, duration: duration)
            }
        })
        document.delete(subtitle: subtitle)
    }
}

struct SubtitleDetail_Previews: PreviewProvider {
    static var previews: some View {
        let document = SubRipDocument()
        let subtitle = document.newSubtitle(content: "My <b>attributed</b> string\nWith two lines", startTime: 120.123, duration: 15.835)!
        SubtitleDetail(selectedSubtitleID: subtitle.id)
            .environmentObject(document)
    }
}
