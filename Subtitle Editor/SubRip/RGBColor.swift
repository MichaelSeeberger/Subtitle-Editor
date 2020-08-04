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
import AppKit

public extension NSColor {
    /**
     * Creates a color object with for a given RGB color which can be specified as an HTML hex color value.
     *
     *  - parameter rgb a 3 bit value with red, green, blue. E.g. 0xa0ff2c
     */
    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16)/255.0,
                  green: CGFloat((rgb & 0x00FF00) >> 8)/255.0,
                  blue: CGFloat(rgb & 0x0000FF)/255.0,
                  alpha: alpha)
    }
}
