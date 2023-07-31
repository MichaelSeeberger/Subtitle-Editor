//
//  SubtitleTimes.swift
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

enum Locked {
    case startTime
    case duration
    case endTime
}

struct SubtitleTimes: View {
    var subtitle: Subtitle
    @Environment(\.undoManager) var undoManager
    @EnvironmentObject var document: SubRipDocument
    
    @State private var locked: Locked = .duration
    
    private var endTime: Binding<Double> {
        Binding(
            get: { return self.subtitle.endTime },
            set: { document.changeEndTime(for: subtitle, newEndTime: $0, keepDuration: self.locked == .duration) }
        )
    }
    
    private var startTime: Binding<Double> {
        Binding(
            get: { return self.subtitle.startTime },
            set: { document.changeStartTime(for: subtitle, newStartTime: $0, keepDuration: self.locked == .duration) }
        )
    }
    
    private var duration: Binding<Double> {
        Binding(
            get: { return self.subtitle.duration },
            set: { document.changeDuration(for: subtitle, newDuration: $0, keepStartTime: self.locked == .startTime) }
        )
    }
    
    func changeLocked(newLocked: Locked) {
        if locked != newLocked {
            locked = newLocked
        }
    }
    
    var body: some View {
        HStack {
            TimeEditorView(
                label: "Start Time",
                locked: locked == .startTime,
                time: startTime,
                action: { self.changeLocked(newLocked: .startTime) }
            )
            TimeEditorView(
                label: "End Time",
                locked: locked == .endTime,
                time: endTime,
                action: { self.changeLocked(newLocked: .endTime) }
            )
            TimeEditorView(
                label: "Duration",
                locked: locked == .duration,
                time: duration,
                action: { self.changeLocked(newLocked: .duration) }
            )
        }
        .onChange(of: subtitle.startTime) { newValue in
            guard document.subtitlesById[subtitle.id] != nil else {
                return
            }
            
            let oldValue = subtitle.startTime
            undoManager?.registerUndo(withTarget: document, handler: { document in
                guard document.subtitlesById[subtitle.id] != nil else { return }
                document.updateSubtitle(with: subtitle.id, startTime: oldValue)
            })
        }
        .onChange(of: subtitle.endTime) { newValue in
            guard document.subtitlesById[subtitle.id] != nil else { return }

            let oldValue = subtitle.endTime
            undoManager?.registerUndo(withTarget: document, handler: { document in
                guard document.subtitlesById[subtitle.id] != nil else { return }
                document.updateSubtitle(with: subtitle.id, startTime: oldValue)
            })
        }
    }
}

struct SubtitleTimes_Previews: PreviewProvider {
    static let document = SubRipDocument()
    
    static var previews: some View {
        let subtitle = document.newSubtitle(startTime: 62.183, duration: 5.331)!

        return SubtitleTimes(subtitle: subtitle)
            .environmentObject(document)
    }
}
