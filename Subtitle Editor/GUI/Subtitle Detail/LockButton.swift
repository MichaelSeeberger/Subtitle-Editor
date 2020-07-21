//
//  LockButton.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 20.07.20.
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

struct LockButton: View {
    var locked: Bool = false
    @State var overButton: Bool = false
    static let imageLocked = NSImage(named: NSImage.lockLockedTemplateName)!
    static let imageUnlocked = NSImage(named: NSImage.lockUnlockedTemplateName)!
    
    let action: () -> Void

    var body: some View {
        Button(action: self.action) {
            Image(nsImage: locked ? LockButton.imageLocked : LockButton.imageUnlocked)
        }
        .buttonStyle(BorderlessButtonStyle())
        .foregroundColor(overButton ? .blue : .gray)
        .onHover(perform: { over in
            self.overButton = over
        })
    }
}

struct LockButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack{
            LockButton(locked: true, action: {})
            LockButton(locked: false, action: {})
        }
    }
}
