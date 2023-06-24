//
//  RangeEditorView.swift
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

struct RangeEditorView: View {
    @Binding var startTime: Double
    @Binding var endTime: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .trailing) {
                Text("Start").padding(.all, 5)
                Text("End").padding(.all, 5)
            }
            VStack(alignment: .trailing) {
                TimeField(time: $startTime)
                TimeField(time: $endTime)
            }
        }
    }
}

struct RangeEditorView_Previews: PreviewProvider {
    static var previews: some View {
        RangeEditorView(startTime: .constant(0.0), endTime: .constant(15.0))
    }
}
