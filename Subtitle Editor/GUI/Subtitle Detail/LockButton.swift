//
//  LockButton.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 20.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
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
