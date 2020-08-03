//
//  HoverButton.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 31.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import SwiftUI

struct HoverButton<Label> : View where Label : View {
    let action: () -> Void
    let label: () -> Label
    
    @State var isHovering: Bool = false
    
    public init(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.label = label
    }
    
    var body: some View {
        Button(action: action, label: label)
            .buttonStyle(BorderlessButtonStyle())
            .foregroundColor(isHovering ? .blue : .gray)
            .onHover(perform: { over in
                self.isHovering = over
            })
    }
}

struct HoverButton_Previews: PreviewProvider {
    static var previews: some View {
        HoverButton(action: {}) {
            Text("Hallo")
        }
    }
}
