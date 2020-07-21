//
//  TestHelpers.swift
//  Subtitle EditorTests
//
//  Created by Michael Seeberger on 13.07.20.
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

import Foundation

class TestHelpers {
    func getSubtitlesFromFile() -> String {
        guard let url = Bundle(for: type(of: self)).url(forResource: "The Last Samurai", withExtension: "srt") else {
            fatalError()
        }
        return try! String(contentsOf: url)
    }
}
