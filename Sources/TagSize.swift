//
//  TagSize.swift
//  TagView
//
//  Created by galaxy on 2021/5/28.
//

import Foundation
import CoreGraphics

public typealias TagSize = CGFloat

extension TagSize {
    public static let auto: TagSize = -9999.0
    
    internal var isAuto: Bool {
        return NSDecimalNumber(value: Float(self)).compare(NSDecimalNumber(value: Float(.auto))) == .orderedSame
    }
}
