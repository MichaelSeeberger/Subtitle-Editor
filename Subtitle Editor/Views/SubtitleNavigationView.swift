//
//  SubtitleNavigationView.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 16.07.23.
//  Copyright © 2023 Michael Seeberger. All rights reserved.
//

import SwiftUI

@available(macOS 13, iOS 15, *)
struct SubtiteNavigationViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowSeparator(.visible)
            .listRowSeparatorTint(.gray)
    }
}

struct SubtiteNavigationViewFallbackModifier: ViewModifier {
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content
            Divider()
        }
    }
}

extension View {
    @ViewBuilder
    func subtitleNavigationListStyle() -> some View {
        if #available(macOS 13, iOS 15, *) {
            self.modifier(SubtiteNavigationViewModifier())
        } else {
            self.modifier(SubtiteNavigationViewFallbackModifier())
        }
    }
}

struct SubtitleNavigationView: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @FetchRequest(entity: Subtitle.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "counter", ascending: true)]) private var subtitles: FetchedResults<Subtitle>
    
    var body: some View {
        NavigationView {
            List(subtitles) { subtitle in
                NavigationLink {
                    SubtitleDetail(selectedSubtitle: subtitle)
                } label: {
                    SubtitleRow(subtitle: subtitle)
                }
                .subtitleNavigationListStyle()
            }
            .frame(minWidth: 250)
            
            Text("Select a subtitle")
                .bold()
                .foregroundColor(.secondary)
        }
    }
}

struct SubtitleNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        SubtitleNavigationView()
    }
}
