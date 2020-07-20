//
//  NavigationPrimary.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 19.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import SwiftUI

struct NavigationPrimary: View {
    @Binding var selectedSubtitle: Subtitle?
    
    var body: some View {
        SubtitleList(selectedSubtitle: $selectedSubtitle)
            .frame(minWidth: 250, maxWidth: 350)
            .listStyle(SidebarListStyle())
    }
}

struct NavigationPrimary_Previews: PreviewProvider {
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
        let selectedSubtitle = subtitles[1]
        return NavigationPrimary(selectedSubtitle: .constant(selectedSubtitle)).environment(\.managedObjectContext, stack.mainManagedObjectContext)
    }
}
