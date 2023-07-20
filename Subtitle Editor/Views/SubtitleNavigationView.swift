//
//  SubtitleNavigationView.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 16.07.23.
//  Copyright © 2023 Michael Seeberger. All rights reserved.
//

import SwiftUI

struct SubtitleNavigationView: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @FetchRequest(entity: Subtitle.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "startTime", ascending: true)]) private var subtitles: FetchedResults<Subtitle>
    
    @Binding var selectedSubtitle: Subtitle?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(subtitles) { subtitle in
                    NavigationLink(
                        destination: SubtitleDetail(selectedSubtitle: subtitle),
                        tag: subtitle,
                        selection: $selectedSubtitle, label: {
                            SubtitleRow(subtitle: subtitle)
                        }
                    )
                    .subtitleNavigationListStyle()
                    .swipeActions {
                        Button("Delete", role: .destructive, action: {
                            withAnimation {
                                context.delete(subtitle)
                            }
                        })
                    }
                }
            }
            .frame(minWidth: 250)
            
            Text("Select a subtitle")
                .bold()
                .foregroundColor(.secondary)
        }
    }
    
    private func deleteRows(at offsets: IndexSet) {
        for index in offsets {
            let deletedSubtitle = subtitles[index]
            context.delete(deletedSubtitle)
        }
    }
}

struct SubtitleNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        SubtitleNavigationView(selectedSubtitle: .constant(nil))
    }
}
