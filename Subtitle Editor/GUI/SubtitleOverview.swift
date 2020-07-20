//
//  SubtitleOverview.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 19.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import SwiftUI

struct SubtitleOverview: View {
    let subtitle: Subtitle
    let formatter = SubRipTimeFormatter()
    
    func attributedString() -> NSAttributedString {
        guard (self.subtitle.formattedContent != nil) else {
            return NSAttributedString(string: subtitle.content ?? "")
        }
        
        guard let content = NSAttributedString(rtf: subtitle.formattedContent!, documentAttributes: nil) else {
            return NSAttributedString(string: subtitle.content ?? "")
        }
        
        return content
    }
    
    var body: some View {
        VStack {
            HStack() {
                Text(formatter.string(for: subtitle.startTime) ?? "<error>")
                    .bold()
                Spacer()
                Text(formatter.string(for: (subtitle.startTime + subtitle.duration)) ?? "<error>")
                    .bold()
            }
            TextWithAttributedString(attributedString: attributedString())
        }
        .padding(.vertical, 4)
    }
}

struct SubtitleOverview_Previews: PreviewProvider {
    static let coreDataStack = CoreDataStack()
    
    static var subtitle: Subtitle = {
        let s = Subtitle(context: coreDataStack.mainManagedObjectContext)
        s.startTime = 120.123
        s.duration = 15.835
        s.content = "My attributed string\nWith two lines"
        let attributedString = NSAttributedString(string: s.content!, attributes: [.font: NSFont.boldSystemFont(ofSize: 14.0)])
        
        s.formattedContent = attributedString.rtf(from: NSMakeRange(0, s.content!.count))
        
        return s
    }()
    
    static var previews: some View {
        SubtitleOverview(subtitle: subtitle)
    }
}
