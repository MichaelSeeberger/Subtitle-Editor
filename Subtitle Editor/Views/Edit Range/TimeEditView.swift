//
//  TimeEditView.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 31.07.20.
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

enum TimeEditMode {
    case addTime
    case subtractTime
}

struct TimeEditView: View {
    @Binding var timeEditMode: TimeEditMode
    @Binding var addedTime: Double
    
    var body: some View {
        HStack {
            Picker(selection: $timeEditMode, label: Text("")) {
                Text("Add Time").tag(TimeEditMode.addTime)
                Text("Subtract Time").tag(TimeEditMode.subtractTime)
            }.frame(maxWidth: 200)
            TimeField(time: $addedTime)
        }
    }
}

struct TimeEditView_Previews: PreviewProvider {
    static var previews: some View {
        TimeEditView(timeEditMode: .constant(.addTime), addedTime: .constant(15.0))
    }
}
