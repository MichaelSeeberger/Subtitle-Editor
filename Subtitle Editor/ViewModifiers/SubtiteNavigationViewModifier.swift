//
//  SubtiteNavigationViewModifier.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 19.07.23.
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
