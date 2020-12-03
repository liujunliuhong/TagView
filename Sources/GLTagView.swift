//
//  GLTagView.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/23.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

/// 垂直对其方式。当每个`item`的高度不一样时，能看到明显的效果
@objc public enum GLTagVerticalAlignment: Int {
    case center   // 居中
    case top      // 置顶
    case bottom   // 置底
}

@objc public class GLTagView: UIView {
    deinit {
        self.removeNotification()
    }
    /// 容器偏移量
    @objc public var inset: UIEdgeInsets = .zero {
        didSet {
            self.refresh()
        }
    }
    /// 行间距
    @objc public var lineSpacing: CGFloat = .zero {
        didSet {
            self.refresh()
        }
    }
    /// 列间距
    @objc public var interitemSpacing: CGFloat = .zero {
        didSet {
            self.refresh()
        }
    }
    /// 总共有几行
    @objc public private(set) var rowCount: Int = 0
    
    /// 垂直对其方式。默认置顶
    @objc public var verticalAlignment: GLTagVerticalAlignment = .top {
        didSet {
            self.refresh()
        }
    }
    /// DEBUG模式下，是否开启日志打印
    public var enableDebugLog: Bool = false
    
    /// `item`集合
    private var items: [GLTagItem] = []
    /// `contentSize`
    private var contentSize: CGSize = .zero
    
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addNotification()
    }
    
    @objc public init() {
        super.init(frame: .zero)
        self.addNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension GLTagView {
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc private func orientationDidChange() {
        self.refresh()
    }
}

extension GLTagView {
    public override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.items.forEach { (item) in
            item.view.layoutIfNeeded()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        return self.contentSize
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.contentSize = self.layout()
        self.invalidateIntrinsicContentSize()
    }
}

extension GLTagView {
    private func layout() -> CGSize {
        let topPadding: CGFloat = self.inset.top
        let leftPadding: CGFloat = self.inset.left
        let rightPadding: CGFloat = self.inset.right
        let bottomPadding: CGFloat = self.inset.bottom
        //
        let containerWidth: CGFloat = self.bounds.width
        if containerWidth.isLessThanOrEqualTo(.zero) {
            #if DEBUG
            if self.enableDebugLog {
                print("The content width is less than 0")
            }
            #endif
            return .zero
        }
        if (containerWidth - leftPadding - rightPadding).isLessThanOrEqualTo(.zero) {
            #if DEBUG
            if self.enableDebugLog {
                print("The actual content width is less than 0")
            }
            #endif
            return .zero
        }
        if self.items.count <= 0 {
            #if DEBUG
            if self.enableDebugLog {
                print("The number of items is 0")
            }
            #endif
            return CGSize(width: containerWidth, height: topPadding + bottomPadding)
        }
        
        var preItem: GLTagItem? = nil
        var X: CGFloat = leftPadding
        var rowCount: Int = 0
        var maxUpLineHeight: CGFloat = 0
        var groupItems: [[GLTagItem]] = []
        var subItems: [GLTagItem] = []
        for (_, item) in self.items.enumerated() {
            let size = self.getActualSize(item: item, containerWidth: containerWidth - leftPadding - rightPadding)
            let width: CGFloat = size.width
            let height: CGFloat = size.height
            //
            if preItem != nil {
                if (X + width + rightPadding).isLessThanOrEqualTo(containerWidth) { /* 不需要换行 */
                    item.view.frame = CGRect(x: X, y: preItem!.view.frame.minY, width: width, height: height)
                    if maxUpLineHeight.isLess(than: preItem!.view.frame.minY + height) {
                        maxUpLineHeight = preItem!.view.frame.minY + height
                    }
                    X += (width + self.interitemSpacing)
                    //
                    subItems.append(item)
                } else {  /* 需要换行 */
                    //
                    groupItems.append(subItems)
                    subItems.removeAll()
                    //
                    rowCount += 1
                    maxUpLineHeight += self.lineSpacing
                    X = leftPadding
                    item.view.frame = CGRect(x: X, y: maxUpLineHeight, width: width, height: height)
                    X += (width + self.interitemSpacing)
                    maxUpLineHeight += height
                    //
                    subItems.append(item)
                }
            } else {
                // 没有上一个item，也就是第一个item
                rowCount += 1
                maxUpLineHeight = topPadding
                item.view.frame = CGRect(x: X, y: maxUpLineHeight, width: width, height: height)
                X += (width + self.interitemSpacing)
                maxUpLineHeight += height
                //
                subItems.append(item)
            }
            preItem = item
        }
        groupItems.append(subItems)
        //
        self.layoutAlignment(groupItems: groupItems)
        //
        self.rowCount = rowCount
        //
        return CGSize(width: containerWidth, height: self.getContentHeight())
    }
    
    
    
    private func getActualSize(item: GLTagItem, containerWidth: CGFloat) -> CGSize {
        //
        let itemIntrinsicContentSize: CGSize = item.view.intrinsicContentSize
        //
        var width: CGFloat = item.width.isLessThanOrEqualTo(.zero) ? itemIntrinsicContentSize.width : item.width
        width = width.isLessThanOrEqualTo(.zero) ? .zero : width
        width = min(width, containerWidth)
        width = width.isLessThanOrEqualTo(.zero) ? .zero : width
        //
        var height: CGFloat = item.height.isLessThanOrEqualTo(.zero) ? itemIntrinsicContentSize.height : item.height
        height = height.isLessThanOrEqualTo(.zero) ? .zero : height
        //
        return CGSize(width: width, height: height)
    }
    
    private func layoutAlignment(groupItems: [[GLTagItem]]) {
        for (_, items) in groupItems.enumerated() {
            if self.verticalAlignment == .top { /* top */
                var top: CGFloat = items.first!.view.frame.minY
                let tops = items.map{ $0.view.frame.minY }
                tops.forEach { (_top) in
                    top = min(top, _top)
                }
                for (_, item) in items.enumerated() {
                    item.view.frame.origin = CGPoint(x: item.view.frame.origin.x, y: top)
                }
            } else if self.verticalAlignment == .center { /* centerY */
                var centerY: CGFloat = items.first!.view.center.y
                let centerYs = items.map{ $0.view.center.y }
                centerYs.forEach { (_centerY) in
                    centerY = max(centerY, _centerY)
                }
                for (_, item) in items.enumerated() {
                    item.view.center = CGPoint(x: item.view.center.x, y: centerY)
                }
            } else { /* bottom */
                var bottom: CGFloat = items.first!.view.frame.maxY
                let bottoms = items.map{ $0.view.frame.maxY }
                bottoms.forEach { (_bottom) in
                    bottom = max(bottom, _bottom)
                }
                for (_, item) in items.enumerated() {
                    var frame = item.view.frame
                    frame.origin.y = bottom - item.view.frame.height
                    item.view.frame = frame
                }
            }
        }
    }
    
    private func getContentHeight() -> CGFloat {
        var y: CGFloat = .zero
        for (_, item) in self.items.enumerated() {
            y = max(y, item.view.frame.maxY)
        }
        return y + self.inset.bottom
    }
}

extension GLTagView {
    @objc public func add(items: [GLTagItem]) {
        for (_, item) in items.enumerated() {
            self.addSubview(item.view)
            self.items.append(item)
        }
        self.refresh()
    }
    
    @objc public func add(item: GLTagItem) {
        self.addSubview(item.view)
        self.items.append(item)
        self.refresh()
    }
    
    @objc public func insert(item: GLTagItem, at index: Int) {
        if index > self.items.count - 1 {
            self.add(item: item)
            return
        }
        var index = index
        if index < 0 {
            index = 0
        }
        self.insertSubview(item.view, at: index)
        self.items.insert(item, at: index)
        self.refresh()
    }
    
    @objc public func insert(items: [GLTagItem], at index: Int) {
        if index > self.items.count - 1 {
            self.add(items: items)
            return
        }
        var index = index
        if index < 0 {
            index = 0
        }
        for (_index, item) in items.enumerated() {
            let i = _index + index
            self.insertSubview(item.view, at: i)
            self.items.insert(item, at: i)
        }
        self.refresh()
    }
    
    @objc public func remove(item: GLTagItem) {
        for (index, _item) in self.items.enumerated() {
            if item.identifier == _item.identifier {
                if item.identifier == _item.identifier {
                    self.items.remove(at: index)
                    _item.view.removeFromSuperview()
                    self.refresh()
                    break
                }
            }
        }
    }
    
    @objc public func remove(items: [GLTagItem]) {
        for (_, i_item) in items.enumerated() {
            for (j, j_item) in self.items.enumerated() {
                if j_item.identifier == i_item.identifier {
                    self.items.remove(at: j)
                    j_item.view.removeFromSuperview()
                    break
                }
            }
        }
        self.refresh()
    }
    
    @objc public func removeItem(at index: Int) {
        if index < 0 {
            return
        }
        if index >= self.items.count {
            return
        }
        let item = self.items.remove(at: index)
        item.view.removeFromSuperview()
        self.refresh()
    }
    
    @objc public func removeItems(at indexs: [Int]) {
        var hasIndexs: [Int] = []
        for (_, index) in indexs.enumerated() {
            if index < 0 {
                continue
            }
            if index >= self.items.count {
                continue
            }
            if hasIndexs.contains(index) {
                continue
            }
            let item = self.items.remove(at: index)
            item.view.removeFromSuperview()
            hasIndexs.append(index)
        }
        self.refresh()
    }
    
    @objc public func removeAllItems() {
        self.items.forEach { (item) in
            item.view.removeFromSuperview()
        }
        self.items.removeAll()
        self.refresh()
    }
    
    /// 刷新界面
    @objc public func refresh() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
