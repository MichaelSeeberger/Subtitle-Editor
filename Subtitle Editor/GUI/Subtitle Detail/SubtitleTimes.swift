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
    
    func changeLocked(newLocked: Locked) {
        if locked != newLocked {
            locked = newLocked
        }
    }
    
    var body: some View {
        return HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Start Time")
                    LockButton(locked: locked == .startTime, action: {
                        self.changeLocked(newLocked: .startTime)
                    })
                }
                if locked == .startTime {
                    Text(formatter.string(for: startTime) ?? "<error>")
                } else {
                    TextField("Start Time", value: $subtitle.startTime, formatter: formatter)
                }
            }
            .frame(width: 120)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Duration")
                    LockButton(locked: locked == .duration, action: {
                        self.changeLocked(newLocked: .duration)
                    })
                }
                if locked == .duration {
                    Text(String(format: "%.3fs", duration))
                } else {
                    TextField("Duration", value: $subtitle.duration, formatter: formatter)
                }
            }
            .frame(width: 120)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("End Time")
                    LockButton(locked: locked == .endTime, action: {
                        self.changeLocked(newLocked: .endTime)
                    })
                }
                Text(formatter.string(for: (startTime + duration)) ?? "<error>")
            }
            .frame(width: 120)
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
