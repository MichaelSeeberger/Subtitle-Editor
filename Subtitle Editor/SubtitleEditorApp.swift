//
//  SubtitleEditorApp.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 19.07.23.
//  Copyright © 2023 Michael Seeberger. All rights reserved.
//

import SwiftUI

@main
struct SubtitleEditorApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: { SubRipDocument() }) { file in
            Content()
                .environment(\.managedObjectContext, file.document.context)
        }
    }
}
