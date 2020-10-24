//
//  GLTagItem.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/23.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

@objc public class GLTagItem: NSObject {
    /// item对应的view
    @objc public let view: UIView
    /// `item`的宽度。如果`item`的宽度小于等于`0`，那么将使用`item`对应`view`的`intrinsicContentSize.width`
    @objc public let width: CGFloat
    /// `item`的高度。如果`item`的高度小于等于`0`，那么将使用`item`对应`view`的`intrinsicContentSize.height`
    @objc public let height: CGFloat
    
    /// 初始化方法
    @objc public init(view: UIView, width: CGFloat, height: CGFloat) {
        self.view = view
        self.width = width
        self.height = height
        super.init()
    }
}

extension GLTagItem {
    /// `item`的唯一标识符，用于两个`item`之间的比较
    internal var identifier: String {
        return UUID().uuidString
    }
}
