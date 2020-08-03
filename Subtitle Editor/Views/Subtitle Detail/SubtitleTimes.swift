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
    let formatter = SubRipTimeFormatter()
    @ObservedObject var subtitle: Subtitle
    
    @State private var locked: Locked = .duration
    
    private var endTime: Binding<Double> { Binding (
        get: { return self.subtitle.endTime },
        set: { self.subtitle.changeEndTime(newEndTime: $0, keepDuration: self.locked == .duration) }
        )
    }
    
    private var startTime: Binding<Double> { Binding (
        get: { return self.subtitle.startTime },
        set: { self.subtitle.changeStartTime(newStartTime: $0, keepDuration: self.locked == .duration) }
        )
    }
    
    private var duration: Binding<Double> { Binding (
        get: { return self.subtitle.duration },
        set: { self.subtitle.changeDuration(newDuration: $0, keepStartTime: self.locked == .startTime) }
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
    }
}

struct SubtitleTimes_Previews: PreviewProvider {
    static let stack = CoreDataStack()
    static var previews: some View {
        let subtitle = Subtitle(context: stack.mainContext)
        subtitle.startTime = 62.183
        subtitle.duration = 5.331
        _ = stack.save()
        return SubtitleTimes(subtitle: subtitle)
            .environment(\.managedObjectContext, stack.mainContext)
    }
}
