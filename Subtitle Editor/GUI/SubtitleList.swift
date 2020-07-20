//
//  SubtitleList.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 19.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import SwiftUI

struct SubtitleList: View {
    @FetchRequest(entity: Subtitle.entity(), sortDescriptors: [NSSortDescriptor(key: "counter", ascending: true)]) var subtitles: FetchedResults<Subtitle>
    @Binding var selectedSubtitle: Subtitle?
    
    var body: some View {
        List(selection: $selectedSubtitle) {
            ForEach(subtitles, id: \.self) { subtitle in
                VStack {
                    SubtitleOverview(subtitle: subtitle)
                    Divider()
                }
                .tag(subtitle)
            }
        }
    }
}

struct SubtitleList_Previews: PreviewProvider {
    static let stack = CoreDataStack()
    static var subtitles = [Subtitle]()
    
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
        return SubtitleList(selectedSubtitle: .constant(subtitles[1]))
            .environment(\.managedObjectContext, stack.mainManagedObjectContext)
    }
}
