//
//  DoubleComparator.swift
//  Subtitle Editor
//
//  Created by Michael Seeberger on 28.07.20.
//  Copyright © 2020 Michael Seeberger. All rights reserved.
//

import Foundation

extension Double {
    func equals(_ otherValue: Double, precision: Double = 0.0001) -> Bool {
        return (self - otherValue).magnitude <= precision
    }
}
