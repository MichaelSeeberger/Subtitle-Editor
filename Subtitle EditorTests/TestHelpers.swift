//
//  TestHelpers.swift
//  Subtitle EditorTests
//
//  Created by Michael Seeberger on 13.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import Foundation

class TestHelpers {
    func getSubtitlesFromFile() -> String {
        guard let url = Bundle(for: type(of: self)).url(forResource: "The Last Samurai", withExtension: "srt") else {
            fatalError()
        }
        return try! String(contentsOf: url)
    }
}
