//
//  EditModePicker.swift
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

enum EditMode {
    case editAll
    case editTimeRange
}

struct EditModePicker: View {
    @Binding var editMode: EditMode
    
    var body: some View {
        Picker(selection: $editMode, label: Text("")) {
            Text("Edit All").tag(EditMode.editAll)
            Text("Edit Range").tag(EditMode.editTimeRange)
        }
    }
}

struct EditModePicker_Previews: PreviewProvider {
    static var previews: some View {
        EditModePicker(editMode: .constant(.editTimeRange))
    }
}
