//
//  SubtitleRow.swift
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

struct SubtitleRow: View {
    @ObservedObject var subtitle: Subtitle
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
            Divider()
        }
        //.padding(.vertical, 4)
    }
}

struct SubtitleOverview_Previews: PreviewProvider {
    static let coreDataStack = CoreDataStack()
    
    static var subtitle: Subtitle = {
        let s = Subtitle(context: coreDataStack.mainContext)
        s.startTime = 120.123
        s.duration = 15.835
        s.content = "My attributed string\nWith two lines"
        let attributedString = NSAttributedString(string: s.content!, attributes: [.font: NSFont.boldSystemFont(ofSize: 14.0)])
        
        s.formattedContent = attributedString.rtf(from: NSMakeRange(0, s.content!.count))
        
        return s
    }()
    
    static var previews: some View {
        SubtitleRow(subtitle: subtitle)
    }
}
