//
//  TimeEditorView.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 21.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import SwiftUI

struct TimeEditorView: View {
    let label: String
    let locked: Bool
    @Binding var time: Double
    let action: () -> Void
    let formatter = SubRipTimeFormatter()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label)
                LockButton(locked: locked, action: self.action)
            }
            TextField(label, value: $time, formatter: formatter)
                .frame(width: 100)
                .disabled(locked)
        }
    }
}

struct TimeEditorView_Previews: PreviewProvider {
    static var previews: some View {
        let time = 61.5
        return VStack(alignment: .leading) {
            TimeEditorView(label: "Start Time", locked: false, time: .constant(time), action: {})
            TimeEditorView(label: "End Time", locked: true, time: .constant(time), action: {})
        }
    }
}
