//
//  TimeEditorView.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 21.07.20.
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

struct TimeEditorView: View {
    @Environment(\.undoManager) var undoManager
    
    let label: String
    let locked: Bool
    @Binding var time: Double
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label)
                LockButton(locked: locked, action: self.action)
            }
            TimeField(time: $time)
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
