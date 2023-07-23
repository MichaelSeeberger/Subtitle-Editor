//
//  SubtitleNavigationView.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 16.07.23.
//  Copyright © 2023 Michael Seeberger. All rights reserved.
//

import SwiftUI

struct SubtitleNavigationView: View {
    @EnvironmentObject var document: SubRipDocument
    
    @Binding var selectedSubtitleID: UUID?
    
    var body: some View {
        NavigationView {
            List {
                ForEach($document.orderedSubtitles) { subtitle in
                    NavigationLink(
                        destination: SubtitleDetail(selectedSubtitleID: subtitle.id),
                        tag: subtitle.id,
                        selection: $selectedSubtitleID, label: {
                            SubtitleRow(subtitle: subtitle)
                        }
                    )
                    /*NavigationLink(destination: {
                        SubtitleDetail(selectedSubtitle: subtitle)
                    }, label: {
                        SubtitleRow(subtitle: subtitle)
                    })*/
                    .subtitleNavigationListStyle()
                    .swipeActions {
                        Button("Delete", role: .destructive, action: {
                            withAnimation {
                                document.delete(subtitle: subtitle.wrappedValue)
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
            document.delete(subtitle: document.orderedSubtitles[index])
        }
    }
}

struct SubtitleNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        SubtitleNavigationView(selectedSubtitleID: .constant(nil))
    }
}
