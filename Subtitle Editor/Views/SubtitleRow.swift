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
    @Binding var subtitle: Subtitle
    let formatter = SubRipTimeFormatter()
    
    var body: some View {
        VStack {
            HStack() {
                Text(formatter.string(for: subtitle.startTime) ?? "<error>")
                    .bold()
                Spacer()
                Text(formatter.string(for: (subtitle.startTime + subtitle.duration)) ?? "<error>")
                    .bold()
            }
            TextWithAttributedString(attributedString: subtitle.formattedContent)
        }
    }
}

struct SubtitleOverview_Previews: PreviewProvider {
    static var subtitle: Subtitle = {
        return Subtitle(content: "My attributed string\nWith two lines", startTime: 120.123, duration: 15.835)
    }()
    
    static var previews: some View {
        SubtitleRow(subtitle: .constant(subtitle))
    }
}
