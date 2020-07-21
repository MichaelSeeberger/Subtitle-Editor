//
//  HexColor.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 09.07.20.
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
