//
//  EditRangeView.swift
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

struct EditRangeView: View {
    @State var rangeEditMode: EditMode = .editAll
    @State var timeEditMode: TimeEditMode = .addTime
    
    @State private var startTime = 0.0
    @State private var endTime = 0.0
    
    @State private var addedTime: Double = 0.0
    
    @Binding var isVisible: Bool
    @Environment(\.undoManager) var undoManager
    @EnvironmentObject var document: SubRipDocument
    
    @State private var hoveringOverHelp = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                EditModePicker(editMode: $rangeEditMode)
                    .frame(maxWidth: 200)
                if rangeEditMode == EditMode.editTimeRange {
                    RangeEditorView(startTime: $startTime, endTime: $endTime)
                }
            }
            TimeEditView(timeEditMode: $timeEditMode, addedTime: $addedTime)
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: self.closeView) {
                    Text("Cancel")
                }.padding(.trailing)
                
                Button(action: self.applyChanges) {
                    Text("Apply Changes")
                }
            }
        }
    }
}

extension EditRangeView {
    func closeView() {
        self.isVisible = false
    }
    
    func applyChanges() {
        let timeService = EditRangeService(document: document, undoManager: undoManager)
        let theAddedTime = self.timeEditMode == TimeEditMode.addTime ? self.addedTime : -self.addedTime

        if rangeEditMode == EditMode.editTimeRange {
            timeService.addTimeToSubtitlesInRange(startTime: self.startTime, endTime: self.endTime, add: theAddedTime)
        } else {
            timeService.addTimeToAllSubitles(theAddedTime)
        }
    }
}

struct EditRangeView_Previews: PreviewProvider {
    static var previews: some View {
        EditRangeView(rangeEditMode: .editTimeRange, isVisible: .constant(true))
    }
}
