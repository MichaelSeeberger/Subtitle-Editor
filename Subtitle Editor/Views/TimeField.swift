//
//  TimeField.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 02.08.20.
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

struct TimeField: View {
    @Binding var time: Double
    @State private var inputString: String?
    @State private var inputOK: Bool = true
    
    let formatter = SubRipTimeFormatter()
    
    private var timeText: Binding<String> { Binding(
        get: { (self.inputString ?? self.formatter.string(for: self.time)) ?? "00:00:00,000" },
        set: {
            self.inputString = $0
            var result: Double! = nil
            let formattedValue = AutoreleasingUnsafeMutablePointer<AnyObject?>(&result)
            if !self.formatter.getObjectValue(formattedValue, for: $0, errorDescription: nil) {
                self.inputOK = false
                return
            }
            self.inputOK = true
            self.time = formattedValue.pointee as! Double
        }
    )}
    
    var body: some View {
        ZStack(alignment: .trailing) {
            TextField("", text: timeText, onCommit: {
                self.inputString = self.formatter.string(for: self.time)
            })
            if !self.inputOK {
                Text("\u{2717}")
                    .bold()
                    .padding(.trailing, 4)
                    .foregroundColor(inputOK ? .green : .red)
            }
        }
    }
}

struct TimeField_Previews: PreviewProvider {
    static var previews: some View {
        TimeField(time: .constant(20))
    }
}
