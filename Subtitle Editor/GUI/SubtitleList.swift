//
//  SubtitleList.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 19.07.20.
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
            let subtitle = Subtitle(context: stack.mainContext)
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
            .environment(\.managedObjectContext, stack.mainContext)
    }
}
