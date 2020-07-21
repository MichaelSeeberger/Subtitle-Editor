//
//  SubtitleTimes.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 20.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import SwiftUI

enum Locked {
    case startTime
    case duration
    case endTime
}

struct SubtitleTimes: View {
    let formatter = SubRipTimeFormatter()
    let startTime: Double
    let duration: Double
    @Binding var subtitle: Subtitle
    @State private var locked: Locked = .duration
    
    private var endTime: Binding<Double> { Binding (
        get: { return self.subtitle.endTime },
        set: { self.subtitle.changeEndTime(newEndTime: $0, keepDuration: self.locked == .duration) }
        )
    }
    
    func changeLocked(newLocked: Locked) {
        if locked != newLocked {
            locked = newLocked
        }
    }
    
    var body: some View {
        return HStack {
            TimeEditorView(label: "Start Time", locked: locked == .startTime, time: $subtitle.startTime, action: { self.changeLocked(newLocked: .startTime) })
            TimeEditorView(label: "End Time", locked: locked == .endTime, time: endTime, action: { self.changeLocked(newLocked: .startTime) })
            TimeEditorView(label: "Duration", locked: locked == .duration, time: $subtitle.duration, action: { self.changeLocked(newLocked: .duration) })
        }
    }
}

struct SubtitleTimes_Previews: PreviewProvider {
    static let stack = CoreDataStack()
    static var previews: some View {
        let subtitle = Subtitle(context: stack.mainManagedObjectContext)
        subtitle.startTime = 62.183
        subtitle.duration = 5.331
        _ = stack.save()
        return SubtitleTimes(startTime: 61.0135, duration: 3.332, subtitle: .constant(subtitle))
            .environment(\.managedObjectContext, stack.mainManagedObjectContext)
    }
}
