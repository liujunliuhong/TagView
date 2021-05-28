//
//  TagItem.swift
//  TagView
//
//  Created by galaxy on 2021/5/28.
//

import Foundation
import UIKit

public final class TagItem {
    
    /// 自定义`View`
    public var customView: UIView?
    /// 宽度。如果是`auto`，需要实现`customView`的`intrinsicContentSize`方法
    public var width: TagSize = .auto
    /// 宽度。如果是`auto`，需要实现`customView`的`intrinsicContentSize`方法，且是垂直居中显示
    public var height: TagSize = .auto
    
    /// 初始化方法
    public init(customView: UIView?, width: TagSize, height: TagSize) {
        self.customView = customView
        self.width = width
        self.height = height
    }
    
    public init() { }
}


extension TagItem {
    /// `item`的唯一标识符，用于两个`item`之间的比较
    internal var identifier: String {
        return UUID().uuidString
    }
}
