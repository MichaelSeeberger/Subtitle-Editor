//
//  Content.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 20.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import SwiftUI

struct Content: View {
    @State private var selectedSubtitle: Subtitle?

    var body: some View {
        NavigationView {
            NavigationPrimary(selectedSubtitle: $selectedSubtitle)
            
            if selectedSubtitle != nil {
                SubtitleDetail(selectedSubtitle: .constant(selectedSubtitle!))
            }
        }
        .frame(minWidth: 700, minHeight: 300)
    }
}

struct Content_Previews: PreviewProvider {
    static let stack = CoreDataStack()
    static var subtitles: [Subtitle] = []
    
    static func createSampleData() {
        do {
            try stack.resetStore()
        } catch {
            fatalError("Could not reset store")
        }
        subtitles = []
        for i in 0...6 {
            let subtitle = Subtitle(context: stack.mainManagedObjectContext)
            subtitle.counter = Int64(i+1)
            subtitle.startTime = Double(60*i)
            subtitle.duration = 25.0
            subtitle.content = "Subtitle \(i)"
            subtitles.append(subtitle)
        }
        
        _ = stack.save()
    }
    
    static var previews: some View {
        createSampleData()
        return Content()
            .environment(\.managedObjectContext, stack.mainManagedObjectContext)
    }
}
