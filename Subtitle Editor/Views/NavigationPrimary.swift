//
//  NavigationPrimary.swift
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

struct NavigationPrimary: View {
    @Binding var selectedSubtitle: Subtitle?
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @State private var showDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SubtitleList(selectedSubtitle: $selectedSubtitle)
                //.listStyle(SidebarListStyle()) // SidebarListStyle introduces a bug into selection of the subtitle...
            Divider()
            HStack {
                Button(action: self.addSubtitle) {
                    Image(nsImage: NSImage(named: NSImage.addTemplateName)!)
                }
                .buttonStyle(BorderlessButtonStyle())
                
                Divider().frame(height: 18)
                
                Button(action: {
                    self.showDeleteAlert = true
                }) {
                    Image(nsImage: NSImage(named: NSImage.removeTemplateName)!)
                }
                .buttonStyle(BorderlessButtonStyle())
                .disabled(selectedSubtitle == nil)
            }
            .padding(6)
            .padding(.leading, 8)
        }
        .frame(minWidth: 250, maxWidth: 350)
        .alert(isPresented: $showDeleteAlert) {
            Alert(title: Text("Are you sure?"),
                  message: Text("Do you really want to delete the selected Subtitle?"),
                  primaryButton: .default(Text("Yes"), action: deleteSelectedSubtitle), secondaryButton: .cancel())
        }
    }
}

extension NavigationPrimary {
    func deleteSelectedSubtitle() {
        guard let subtitle = selectedSubtitle else {
            return
        }
        
        selectedSubtitle = nil
        context.delete(subtitle)
    }
    
    func addSubtitle() {
        context.undoManager?.beginUndoGrouping()
        defer {
            context.undoManager?.endUndoGrouping()
        }
        let newSubtitle = Subtitle(context: context)
        newSubtitle.startTime = selectedSubtitle?.endTime ?? 0.0
        newSubtitle.duration = 5
        newSubtitle.content = ""
        newSubtitle.formattedContent = NSAttributedString(string:"").rtf(from: NSMakeRange(0, 0))
        let newCounter: Int64!
        if selectedSubtitle != nil {
            newCounter = selectedSubtitle!.counter + 1
        } else {
            newCounter = 1
        }
        
        do {
            var counter: Int64 = newCounter
            let request = NSFetchRequest<Subtitle>(entityName: Subtitle.entity().name ?? "Subtitle")
            request.sortDescriptors = [
                NSSortDescriptor(key: "counter", ascending: true),
            ]
            request.predicate = NSPredicate(format: "counter >= %d", counter)
            let subtitles = try context.fetch(request)
            for subtitle in subtitles {
                counter += 1
                subtitle.counter = counter
            }
            
            newSubtitle.counter = newCounter
            
            try self.context.obtainPermanentIDs(for: [newSubtitle])
        } catch {
            NSLog("An error occured while adding a subtitle. \(error): \((error as NSError).localizedDescription)")
        }
    }
    
    func removeSubtitle() {
        guard let deletableSubtitle = selectedSubtitle else {
            return
        }
        context.delete(deletableSubtitle)
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
        let selectedSubtitle = subtitles[1]
        return NavigationPrimary(selectedSubtitle: .constant(selectedSubtitle)).environment(\.managedObjectContext, stack.mainContext)
    }
}
