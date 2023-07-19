//
//  MainContent.swift
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

struct MainContent: View {
    @State private var selectedSubtitle: Subtitle?
    @State private var isEditingRange: Bool = false
    
    var body: some View {
        SubtitleNavigationView()
            .frame(minWidth: 700, minHeight: 300)
            .sheet(isPresented: $isEditingRange) {
                EditRangeView(isVisible: $isEditingRange)
                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        
                    } label: {
                        Label("Delete subtitle", systemImage: "plus")
                    }
                }
                
                ToolbarItem {
                    Button {
                        isEditingRange.toggle()
                    } label: {
                        Label("Edit Range", systemImage: "slider.horizontal.2.square.on.square")
                    }
                }
            }
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
        return MainContent()
            .environment(\.managedObjectContext, stack.mainContext)
    }
}