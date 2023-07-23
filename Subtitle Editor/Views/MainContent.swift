//
//  MainContent.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 20.07.20.
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

struct MainContent: View {
    @Environment(\.undoManager) var undoManager
    @EnvironmentObject var document: SubRipDocument
    
    @State private var selectedSubtitleID: UUID? = nil
    @State private var isEditingRange: Bool = false
    
    var body: some View {
        SubtitleNavigationView(selectedSubtitleID: $selectedSubtitleID)
            .frame(minWidth: 700, minHeight: 300)
            .sheet(isPresented: $isEditingRange) {
                EditRangeView(isVisible: $isEditingRange)
                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        withAnimation {
                            addSubtitle()
                        }
                    } label: {
                        Label("Delete subtitle", systemImage: "plus")
                    }
                }
                
                ToolbarItem {
                    Button {
                        isEditingRange.toggle()
                    } label: {
                        Label("Edit Range", systemImage: "slider.horizontal.2.square.on.square")
                    }
                }
            }
    }
}

extension MainContent {
    private func selectedSubtitle() -> Subtitle? {
        guard let id = selectedSubtitleID else {
            return nil
        }
        
        return document.subtitlesById[id]
    }
    
    fileprivate func addSubtitle() {
        var startTime: Double = 0
        
        if let selection = selectedSubtitle() {
            startTime = selection.startTime + selection.duration
        } else if let lastSubtitle = document.lastSubtitle() {
            startTime = lastSubtitle.startTime + lastSubtitle.duration
        }
        
        guard let newSubtitle = document.newSubtitle(startTime: startTime) else {
            NSLog("Could not create a subtitle")
            return
        }
        
        undoManager?.registerUndo(withTarget: document, handler: { document in
            document.delete(subtitle: newSubtitle)
        })
        
        selectedSubtitleID = newSubtitle.id
    }
}

struct Content_Previews: PreviewProvider {
    static let document = SubRipDocument()
    static var subtitles: [Subtitle] = []
    
    static func createSampleData() {
        subtitles = []
        for i in 0...6 {
            let subtitle = document.newSubtitle(content: "Subtitle \(i)", startTime: Double(60*i), duration: 25.0)!
            subtitles.append(subtitle)
        }
    }
    
    static var previews: some View {
        createSampleData()
        return MainContent()
            .environmentObject(document)
    }
}
