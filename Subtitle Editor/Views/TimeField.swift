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
    @State private var inputString: String? = nil
    
    private let formatter = SubRipTimeFormatter()
    
    @State private var isInputOK = true

    private var timeTextBinding: Binding<String> {
        Binding<String>(
            get: {
                inputString ?? formatter.string(for: time)!
            },
            set: { newValue in
                var result: Double! = nil
                let formattedValue = AutoreleasingUnsafeMutablePointer<AnyObject?>(&result)
                
                isInputOK = formatter.isValid(newValue)
                let calculatedValue = formatter.getObjectValue(formattedValue, for: newValue, errorDescription: nil)
                inputString = newValue
                
                if calculatedValue {
                    time = formattedValue.pointee as! Double
                }
            }
        )
    }
        
    var body: some View {
        ZStack(alignment: .trailing) {
            TextField("", text: timeTextBinding, onEditingChanged: { hasFocus in
                if !hasFocus {
                    DispatchQueue.main.async {
                        inputString = nil
                        isInputOK = true
                    }
                }
            })
            .foregroundColor(isInputOK ? .primary : .red)
            .onSubmit {
                inputString = nil
            }
        }
    }
}

struct TimeField_Previews: PreviewProvider {
    static var previews: some View {
        TimeField(time: .constant(20))
    }
}
