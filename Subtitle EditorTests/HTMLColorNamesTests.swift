//
//  HTMLColorCodesTests.swift
//  Subtitle EditorTests
//
//  Created by Michael Seeberger on 09.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import XCTest
import Foundation
@testable import Subtitle_Editor

final class HTMLColorNamesTests: XCTestCase {
    //"indianred": 0xCD5C5C
        //"indianred": 0xCD5C5C
    func test_indianred() {
        let color = HTMLColors["indianred"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xCD5C5C)
    }

    //"lightcoral": 0xF08080
    func test_lightcoral() {
        let color = HTMLColors["lightcoral"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xF08080)
    }

    //"salmon": 0xFA8072
    func test_salmon() {
        let color = HTMLColors["salmon"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFA8072)
    }

    //"darksalmon": 0xE9967A
    func test_darksalmon() {
        let color = HTMLColors["darksalmon"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xE9967A)
    }

    //"lightsalmon": 0xFFA07A
    func test_lightsalmon() {
        let color = HTMLColors["lightsalmon"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFFA07A)
    }

    //"crimson": 0xDC143C
    func test_crimson() {
        let color = HTMLColors["crimson"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xDC143C)
    }

    //"red": 0xFF0000
    func test_red() {
        let color = HTMLColors["red"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFF0000)
    }

    //"firebrick": 0xB22222
    func test_firebrick() {
        let color = HTMLColors["firebrick"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xB22222)
    }

    //"darkred": 0x8B0000
    func test_darkred() {
        let color = HTMLColors["darkred"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x8B0000)
    }

    //"pink": 0xFFC0CB
    func test_pink() {
        let color = HTMLColors["pink"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFFC0CB)
    }

    //"lightpink": 0xFFB6C1
    func test_lightpink() {
        let color = HTMLColors["lightpink"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFFB6C1)
    }

    //"hotpink": 0xFF69B4
    func test_hotpink() {
        let color = HTMLColors["hotpink"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFF69B4)
    }

    //"deeppink": 0xFF1493
    func test_deeppink() {
        let color = HTMLColors["deeppink"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFF1493)
    }

    //"mediumvioletred": 0xC71585
    func test_mediumvioletred() {
        let color = HTMLColors["mediumvioletred"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xC71585)
    }

    //"palevioletred": 0xDB7093
    func test_palevioletred() {
        let color = HTMLColors["palevioletred"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xDB7093)
    }

    //"coral": 0xFF7F50
    func test_coral() {
        let color = HTMLColors["coral"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFF7F50)
    }

    //"tomato": 0xFF6347
    func test_tomato() {
        let color = HTMLColors["tomato"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFF6347)
    }

    //"orangered": 0xFF4500
    func test_orangered() {
        let color = HTMLColors["orangered"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFF4500)
    }

    //"darkorange": 0xFF8C00
    func test_darkorange() {
        let color = HTMLColors["darkorange"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFF8C00)
    }

    //"orange": 0xFFA500
    func test_orange() {
        let color = HTMLColors["orange"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFFA500)
    }

    //"gold": 0xFFD700
    func test_gold() {
        let color = HTMLColors["gold"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFFD700)
    }

    //"yellow": 0xFFFF00
    func test_yellow() {
        let color = HTMLColors["yellow"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFFFF00)
    }

    //"lightyellow": 0xFFFFE0
    func test_lightyellow() {
        let color = HTMLColors["lightyellow"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFFFFE0)
    }

    //"lemonchiffon": 0xFFFACD
    func test_lemonchiffon() {
        let color = HTMLColors["lemonchiffon"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFFFACD)
    }

    //"lightgoldenrodyellow": 0xFAFAD2
    func test_lightgoldenrodyellow() {
        let color = HTMLColors["lightgoldenrodyellow"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFAFAD2)
    }

    //"papayawhip": 0xFFEFD5
    func test_papayawhip() {
        let color = HTMLColors["papayawhip"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFFEFD5)
    }

    //"moccasin": 0xFFE4B5
    func test_moccasin() {
        let color = HTMLColors["moccasin"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFFE4B5)
    }

    //"peachpuff": 0xFFDAB9
    func test_peachpuff() {
        let color = HTMLColors["peachpuff"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFFDAB9)
    }

    //"palegoldenrod": 0xEEE8AA
    func test_palegoldenrod() {
        let color = HTMLColors["palegoldenrod"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xEEE8AA)
    }

    //"khaki": 0xF0E68C
    func test_khaki() {
        let color = HTMLColors["khaki"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xF0E68C)
    }

    //"darkkhaki": 0xBDB76B
    func test_darkkhaki() {
        let color = HTMLColors["darkkhaki"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xBDB76B)
    }

    //"lavender": 0xE6E6FA
    func test_lavender() {
        let color = HTMLColors["lavender"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xE6E6FA)
    }

    //"thistle": 0xD8BFD8
    func test_thistle() {
        let color = HTMLColors["thistle"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xD8BFD8)
    }

    //"plum": 0xDDA0DD
    func test_plum() {
        let color = HTMLColors["plum"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xDDA0DD)
    }

    //"violet": 0xEE82EE
    func test_violet() {
        let color = HTMLColors["violet"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xEE82EE)
    }

    //"orchid": 0xDA70D6
    func test_orchid() {
        let color = HTMLColors["orchid"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xDA70D6)
    }

    //"fuchsia": 0xFF00FF
    func test_fuchsia() {
        let color = HTMLColors["fuchsia"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFF00FF)
    }

    //"magenta": 0xFF00FF
    func test_magenta() {
        let color = HTMLColors["magenta"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFF00FF)
    }

    //"mediumorchid": 0xBA55D3
    func test_mediumorchid() {
        let color = HTMLColors["mediumorchid"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xBA55D3)
    }

    //"mediumpurple": 0x9370DB
    func test_mediumpurple() {
        let color = HTMLColors["mediumpurple"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x9370DB)
    }

    //"rebeccapurple": 0x663399
    func test_rebeccapurple() {
        let color = HTMLColors["rebeccapurple"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x663399)
    }

    //"blueviolet": 0x8A2BE2
    func test_blueviolet() {
        let color = HTMLColors["blueviolet"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x8A2BE2)
    }

    //"darkviolet": 0x9400D3
    func test_darkviolet() {
        let color = HTMLColors["darkviolet"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x9400D3)
    }

    //"darkorchid": 0x9932CC
    func test_darkorchid() {
        let color = HTMLColors["darkorchid"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x9932CC)
    }

    //"darkmagenta": 0x8B008B
    func test_darkmagenta() {
        let color = HTMLColors["darkmagenta"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x8B008B)
    }

    //"purple": 0x800080
    func test_purple() {
        let color = HTMLColors["purple"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x800080)
    }

    //"indigo": 0x4B0082
    func test_indigo() {
        let color = HTMLColors["indigo"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x4B0082)
    }

    //"slateblue": 0x6A5ACD
    func test_slateblue() {
        let color = HTMLColors["slateblue"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x6A5ACD)
    }

    //"darkslateblue": 0x483D8B
    func test_darkslateblue() {
        let color = HTMLColors["darkslateblue"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x483D8B)
    }

    //"mediumslateblue": 0x7B68EE
    func test_mediumslateblue() {
        let color = HTMLColors["mediumslateblue"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x7B68EE)
    }

    //"greenyellow": 0xADFF2F
    func test_greenyellow() {
        let color = HTMLColors["greenyellow"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xADFF2F)
    }

    //"chartreuse": 0x7FFF00
    func test_chartreuse() {
        let color = HTMLColors["chartreuse"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x7FFF00)
    }

    //"lawngreen": 0x7CFC00
    func test_lawngreen() {
        let color = HTMLColors["lawngreen"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x7CFC00)
    }

    //"lime": 0x00FF00
    func test_lime() {
        let color = HTMLColors["lime"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x00FF00)
    }

    //"limegreen": 0x32CD32
    func test_limegreen() {
        let color = HTMLColors["limegreen"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x32CD32)
    }

    //"palegreen": 0x98FB98
    func test_palegreen() {
        let color = HTMLColors["palegreen"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x98FB98)
    }

    //"lightgreen": 0x90EE90
    func test_lightgreen() {
        let color = HTMLColors["lightgreen"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x90EE90)
    }

    //"mediumspringgreen": 0x00FA9A
    func test_mediumspringgreen() {
        let color = HTMLColors["mediumspringgreen"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x00FA9A)
    }

    //"springgreen": 0x00FF7F
    func test_springgreen() {
        let color = HTMLColors["springgreen"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x00FF7F)
    }

    //"mediumseagreen": 0x3CB371
    func test_mediumseagreen() {
        let color = HTMLColors["mediumseagreen"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x3CB371)
    }

    //"seagreen": 0x2E8B57
    func test_seagreen() {
        let color = HTMLColors["seagreen"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x2E8B57)
    }

    //"forestgreen": 0x228B22
    func test_forestgreen() {
        let color = HTMLColors["forestgreen"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x228B22)
    }

    //"green": 0x008000
    func test_green() {
        let color = HTMLColors["green"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x008000)
    }

    //"darkgreen": 0x006400
    func test_darkgreen() {
        let color = HTMLColors["darkgreen"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x006400)
    }

    //"yellowgreen": 0x9ACD32
    func test_yellowgreen() {
        let color = HTMLColors["yellowgreen"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x9ACD32)
    }

    //"olivedrab": 0x6B8E23
    func test_olivedrab() {
        let color = HTMLColors["olivedrab"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x6B8E23)
    }

    //"olive": 0x808000
    func test_olive() {
        let color = HTMLColors["olive"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x808000)
    }

    //"darkolivegreen": 0x556B2F
    func test_darkolivegreen() {
        let color = HTMLColors["darkolivegreen"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x556B2F)
    }

    //"mediumaquamarine": 0x66CDAA
    func test_mediumaquamarine() {
        let color = HTMLColors["mediumaquamarine"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x66CDAA)
    }

    //"darkseagreen": 0x8FBC8B
    func test_darkseagreen() {
        let color = HTMLColors["darkseagreen"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x8FBC8F)
    }

    //"lightseagreen": 0x20B2AA
    func test_lightseagreen() {
        let color = HTMLColors["lightseagreen"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x20B2AA)
    }

    //"darkcyan": 0x008B8B
    func test_darkcyan() {
        let color = HTMLColors["darkcyan"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x008B8B)
    }

    //"teal": 0x008080
    func test_teal() {
        let color = HTMLColors["teal"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x008080)
    }

    //"aqua": 0x00FFFF
    func test_aqua() {
        let color = HTMLColors["aqua"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x00FFFF)
    }

    //"cyan": 0x00FFFF
    func test_cyan() {
        let color = HTMLColors["cyan"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x00FFFF)
    }

    //"lightcyan": 0xE0FFFF
    func test_lightcyan() {
        let color = HTMLColors["lightcyan"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xE0FFFF)
    }

    //"paleturquoise": 0xAFEEEE
    func test_paleturquoise() {
        let color = HTMLColors["paleturquoise"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xAFEEEE)
    }

    //"aquamarine": 0x7FFFD4
    func test_aquamarine() {
        let color = HTMLColors["aquamarine"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x7FFFD4)
    }

    //"turquoise": 0x40E0D0
    func test_turquoise() {
        let color = HTMLColors["turquoise"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x40E0D0)
    }

    //"mediumturquoise": 0x48D1CC
    func test_mediumturquoise() {
        let color = HTMLColors["mediumturquoise"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x48D1CC)
    }

    //"darkturquoise": 0x00CED1
    func test_darkturquoise() {
        let color = HTMLColors["darkturquoise"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x00CED1)
    }

    //"cadetblue": 0x5F9EA0
    func test_cadetblue() {
        let color = HTMLColors["cadetblue"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x5F9EA0)
    }

    //"steelblue": 0x4682B4
    func test_steelblue() {
        let color = HTMLColors["steelblue"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x4682B4)
    }

    //"lightsteelblue": 0xB0C4DE
    func test_lightsteelblue() {
        let color = HTMLColors["lightsteelblue"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xB0C4DE)
    }

    //"powderblue": 0xB0E0E6
    func test_powderblue() {
        let color = HTMLColors["powderblue"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xB0E0E6)
    }

    //"lightblue": 0xADD8E6
    func test_lightblue() {
        let color = HTMLColors["lightblue"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xADD8E6)
    }

    //"skyblue": 0x87CEEB
    func test_skyblue() {
        let color = HTMLColors["skyblue"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x87CEEB)
    }

    //"lightskyblue": 0x87CEFA
    func test_lightskyblue() {
        let color = HTMLColors["lightskyblue"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x87CEFA)
    }

    //"deepskyblue": 0x00BFFF
    func test_deepskyblue() {
        let color = HTMLColors["deepskyblue"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x00BFFF)
    }

    //"dodgerblue": 0x1E90FF
    func test_dodgerblue() {
        let color = HTMLColors["dodgerblue"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x1E90FF)
    }

    //"cornflowerblue": 0x6495ED
    func test_cornflowerblue() {
        let color = HTMLColors["cornflowerblue"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x6495ED)
    }

    //"royalblue": 0x4169E1
    func test_royalblue() {
        let color = HTMLColors["royalblue"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x4169E1)
    }

    //"blue": 0x0000FF
    func test_blue() {
        let color = HTMLColors["blue"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x0000FF)
    }

    //"mediumblue": 0x0000CD
    func test_mediumblue() {
        let color = HTMLColors["mediumblue"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x0000CD)
    }

    //"darkblue": 0x00008B
    func test_darkblue() {
        let color = HTMLColors["darkblue"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x00008B)
    }

    //"navy": 0x000080
    func test_navy() {
        let color = HTMLColors["navy"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x000080)
    }

    //"midnightblue": 0x191970
    func test_midnightblue() {
        let color = HTMLColors["midnightblue"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x191970)
    }

    //"cornsilk": 0xFFF8DC
    func test_cornsilk() {
        let color = HTMLColors["cornsilk"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFFF8DC)
    }

    //"blanchedalmond": 0xFFEBCD
    func test_blanchedalmond() {
        let color = HTMLColors["blanchedalmond"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFFEBCD)
    }

    //"bisque": 0xFFE4C4
    func test_bisque() {
        let color = HTMLColors["bisque"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFFE4C4)
    }

    //"navajowhite": 0xFFDEAD
    func test_navajowhite() {
        let color = HTMLColors["navajowhite"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFFDEAD)
    }

    //"wheat": 0xF5DEB3
    func test_wheat() {
        let color = HTMLColors["wheat"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xF5DEB3)
    }

    //"burlywood": 0xDEB887
    func test_burlywood() {
        let color = HTMLColors["burlywood"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xDEB887)
    }

    //"tan": 0xD2B48C
    func test_tan() {
        let color = HTMLColors["tan"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xD2B48C)
    }

    //"rosybrown": 0xBC8F8F
    func test_rosybrown() {
        let color = HTMLColors["rosybrown"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xBC8F8F)
    }

    //"sandybrown": 0xF4A460
    func test_sandybrown() {
        let color = HTMLColors["sandybrown"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xF4A460)
    }

    //"goldenrod": 0xDAA520
    func test_goldenrod() {
        let color = HTMLColors["goldenrod"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xDAA520)
    }

    //"darkgoldenrod": 0xB8860B
    func test_darkgoldenrod() {
        let color = HTMLColors["darkgoldenrod"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xB8860B)
    }

    //"peru": 0xCD853F
    func test_peru() {
        let color = HTMLColors["peru"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xCD853F)
    }

    //"chocolate": 0xD2691E
    func test_chocolate() {
        let color = HTMLColors["chocolate"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xD2691E)
    }

    //"saddlebrown": 0x8B4513
    func test_saddlebrown() {
        let color = HTMLColors["saddlebrown"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x8B4513)
    }

    //"sienna": 0xA0522D
    func test_sienna() {
        let color = HTMLColors["sienna"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xA0522D)
    }

    //"brown": 0xA52A2A
    func test_brown() {
        let color = HTMLColors["brown"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xA52A2A)
    }

    //"maroon": 0x800000
    func test_maroon() {
        let color = HTMLColors["maroon"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x800000)
    }

    //"white": 0xFFFFFF
    func test_white() {
        let color = HTMLColors["white"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFFFFFF)
    }

    //"snow": 0xFFFAFA
    func test_snow() {
        let color = HTMLColors["snow"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFFFAFA)
    }

    //"honeydew": 0xF0FFF0
    func test_honeydew() {
        let color = HTMLColors["honeydew"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xF0FFF0)
    }

    //"mintcream": 0xF5FFFA
    func test_mintcream() {
        let color = HTMLColors["mintcream"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xF5FFFA)
    }

    //"azure": 0xF0FFFF
    func test_azure() {
        let color = HTMLColors["azure"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xF0FFFF)
    }

    //"aliceblue": 0xF0F8FF
    func test_aliceblue() {
        let color = HTMLColors["aliceblue"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xF0F8FF)
    }

    //"ghostwhite": 0xF8F8FF
    func test_ghostwhite() {
        let color = HTMLColors["ghostwhite"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xF8F8FF)
    }

    //"whitesmoke": 0xF5F5F5
    func test_whitesmoke() {
        let color = HTMLColors["whitesmoke"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xF5F5F5)
    }

    //"seashell": 0xFFF5EE
    func test_seashell() {
        let color = HTMLColors["seashell"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFFF5EE)
    }

    //"beige": 0xF5F5DC
    func test_beige() {
        let color = HTMLColors["beige"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xF5F5DC)
    }

    //"oldlace": 0xFDF5E6
    func test_oldlace() {
        let color = HTMLColors["oldlace"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFDF5E6)
    }

    //"floralwhite": 0xFFFAF0
    func test_floralwhite() {
        let color = HTMLColors["floralwhite"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFFFAF0)
    }

    //"ivory": 0xFFFFF0
    func test_ivory() {
        let color = HTMLColors["ivory"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFFFFF0)
    }

    //"antiquewhite": 0xFAEBD7
    func test_antiquewhite() {
        let color = HTMLColors["antiquewhite"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFAEBD7)
    }

    //"linen": 0xFAF0E6
    func test_linen() {
        let color = HTMLColors["linen"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFAF0E6)
    }

    //"lavenderblush": 0xFFF0F5
    func test_lavenderblush() {
        let color = HTMLColors["lavenderblush"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFFF0F5)
    }

    //"mistyrose": 0xFFE4E1
    func test_mistyrose() {
        let color = HTMLColors["mistyrose"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xFFE4E1)
    }

    //"gainsboro": 0xDCDCDC
    func test_gainsboro() {
        let color = HTMLColors["gainsboro"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xDCDCDC)
    }

    //"lightgray": 0xD3D3D3
    func test_lightgray() {
        let color = HTMLColors["lightgray"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xD3D3D3)
    }

    //"silver": 0xC0C0C0
    func test_silver() {
        let color = HTMLColors["silver"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xC0C0C0)
    }

    //"darkgray": 0xA9A9A9
    func test_darkgray() {
        let color = HTMLColors["darkgray"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0xA9A9A9)
    }

    //"gray": 0x808080
    func test_gray() {
        let color = HTMLColors["gray"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x808080)
    }

    //"dimgray": 0x696969
    func test_dimgray() {
        let color = HTMLColors["dimgray"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x696969)
    }

    //"lightslategray": 0x778899
    func test_lightslategray() {
        let color = HTMLColors["lightslategray"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x778899)
    }

    //"slategray": 0x708090
    func test_slategray() {
        let color = HTMLColors["slategray"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x708090)
    }

    //"darkslategray": 0x2F4F4F
    func test_darkslategray() {
        let color = HTMLColors["darkslategray"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x2F4F4F)
    }

    //"black": 0x000000
    func test_black() {
        let color = HTMLColors["black"]
        XCTAssertNotNil(color)
        XCTAssertEqual(color, 0x000000)
    }


}
