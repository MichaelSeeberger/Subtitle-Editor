//
//  SubtitleDetailView.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 19.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import SwiftUI

struct SubtitleDetail: View {
    @Binding public var selectedSubtitle: Subtitle
    
    var parser = SubRipParser()
    private var subtitleString: Binding<String> { Binding (
        get: { return (self.selectedSubtitle.content ?? "") },
        set: {
            self.selectedSubtitle.content = $0
            do {
                let (_, formatted, _) = try self.parser.parseBody(tokenizer: SubRipTokenizer(), subtitlesString: $0)
                self.selectedSubtitle.formattedContent = formatted.rtf(from: NSMakeRange(0, formatted.string.count))
            } catch {
                print("Could not parse body")
            }
        })
    }
    
    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .leading) {
                    SubtitleTimes(startTime: selectedSubtitle.startTime, duration: selectedSubtitle.duration, subtitle: .constant(selectedSubtitle))
                        .padding()
                    Divider()
                    TextField("Subtitle Text", text: subtitleString)
                        .padding()
                }
                Spacer()
            }
            .padding()
        }
    }
}



struct SubtitleDetail_Previews: PreviewProvider {
    static let stack = CoreDataStack()
    static var subtitle: Subtitle = {
        let s = Subtitle(context: stack.mainManagedObjectContext)
        s.startTime = 120.123
        s.duration = 15.835
        s.content = "My <b>attributed</b> string\nWith two lines"
        let attributedString = NSAttributedString(string: s.content!, attributes: [.font: NSFont.boldSystemFont(ofSize: 14.0)])
        
        s.formattedContent = attributedString.rtf(from: NSMakeRange(0, s.content!.count))
        
        return s
    }()
    
    static var previews: some View {
        SubtitleDetail(selectedSubtitle: .constant(subtitle))
            .environment(\.managedObjectContext, stack.mainManagedObjectContext)
    }
}
