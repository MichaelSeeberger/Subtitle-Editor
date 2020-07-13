//
//  HexColor.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 09.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import struct SwiftUI.Color

public extension Color {
    /**
     * Creates a color object with for a given RGB color which can be specified as an HTML hex color value.
     *
     *  - parameter rgb a 3 bit value with red, green, blue. E.g. 0xa0ff2c
     */
    init(rgb: Int, alpha: Double = 1.0) {
        self.init(red: Double((rgb & 0xFF0000) >> 16)/0xFF,
                  green: Double((rgb & 0x00FF00) >> 8)/0xFF,
                  blue: Double(rgb & 0x0000FF)/0xFF,
                  opacity: alpha)
    }
}
