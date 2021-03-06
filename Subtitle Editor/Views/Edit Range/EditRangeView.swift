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
    @Environment(\.managedObjectContext) var context
    
    @State private var hoveringOverHelp = false
    
    private let formatter = SubRipTimeFormatter()
    
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
        let timeService = EditRangeService(context: context)
        let theAddedTime = self.timeEditMode == TimeEditMode.addTime ? self.addedTime : -self.addedTime
        do {
            NSLog("\(self.startTime) --> \(self.endTime): +\(theAddedTime)")
            if rangeEditMode == EditMode.editTimeRange {
                try timeService.addTimeToSubtitlesInRange(startTime: self.startTime, endTime: self.endTime, add: theAddedTime)
            } else {
                try timeService.addTimeToAllSubitles(theAddedTime)
            }
        } catch let error as NSError {
            NSLog("error \(error): \(error.localizedDescription)")
        } catch {
            NSLog("error: \(error)")
        }
        }
}

struct EditRangeView_Previews: PreviewProvider {
    static var previews: some View {
        EditRangeView(rangeEditMode: .editTimeRange, isVisible: .constant(true))
    }
}
