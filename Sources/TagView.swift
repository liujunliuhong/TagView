//
//  TagView.swift
//  TagView
//
//  Created by galaxy on 2021/5/28.
//

import UIKit

/// 垂直对其方式。当每个`item`的高度不一样时，能看到明显的效果
public enum VerticalAlignment {
    case center   /// 居中
    case top      /// 置顶
    case bottom   /// 置底
}


/// 标签`View`
public final class TagView: UIView {
    deinit {
        removeNotification()
    }
    /// 容器偏移量
    public var inset: UIEdgeInsets = .zero {
        didSet {
            refresh()
        }
    }
    
    /// 行间距
    public var lineSpacing: CGFloat = .zero {
        didSet {
            refresh()
        }
    }
    
    /// 列间距
    public var interitemSpacing: CGFloat = .zero {
        didSet {
            refresh()
        }
    }
    /// 总共有几行
    public private(set) var rowCount: Int = 0
    
    /// 垂直对其方式。默认置顶
    public var verticalAlignment: VerticalAlignment = .top {
        didSet {
            refresh()
        }
    }
    /// DEBUG模式下，是否开启日志打印
    public var enableDebugLog: Bool = false
    
    /// `item`集合
    private var items: [TagItem] = []
    /// `contentSize`
    private var contentSize: CGSize = .zero
    
    private var containerWidth: CGFloat = .zero
    private var containerHeight: CGFloat = .zero
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addNotification()
    }
    
    public init() {
        super.init(frame: .zero)
        addNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension TagView {
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc private func orientationDidChange() {
        refresh()
    }
}

extension TagView {
    public override func layoutIfNeeded() {
        super.layoutIfNeeded()
        items.forEach { (item) in
            item.customView?.layoutIfNeeded()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        #if DEBUG
        if enableDebugLog {
            print("containerWidth: \(containerWidth)")
            print("containerHeight: \(containerHeight)")
        }
        #endif
        return CGSize(width: containerWidth, height: containerHeight)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        containerWidth = bounds.width
        layout()
        invalidateIntrinsicContentSize()
    }
}

extension TagView {
    private func layout() {
        let topPadding: CGFloat = inset.top
        let leftPadding: CGFloat = inset.left
        let rightPadding: CGFloat = inset.right
        let bottomPadding: CGFloat = inset.bottom
        //
        if containerWidth.isLessThanOrEqualTo(.zero) {
            #if DEBUG
            if enableDebugLog {
                print("The content width is less than 0")
            }
            #endif
            containerHeight = .zero
            return
        }
        if (containerWidth - leftPadding - rightPadding).isLessThanOrEqualTo(.zero) {
            #if DEBUG
            if enableDebugLog {
                print("The actual content width is less than 0")
            }
            #endif
            containerHeight = .zero
            return
        }
        if items.count <= 0 {
            #if DEBUG
            if enableDebugLog {
                print("The number of items is 0")
            }
            #endif
            containerHeight = topPadding + bottomPadding
            return
        }
        
        var preItem: TagItem? = nil
        var X: CGFloat = leftPadding
        var _rowCount: Int = 0
        var maxUpLineHeight: CGFloat = 0
        var groupItems: [[TagItem]] = []
        var subItems: [TagItem] = []
        for (_, item) in items.enumerated() {
            if item.customView == nil { continue }
            let size = getItemSize(item: item)
            let width: CGFloat = size.width
            let height: CGFloat = size.height
            //
            if preItem != nil && preItem?.customView != nil {
                if (X + width + rightPadding).isLessThanOrEqualTo(containerWidth) { /* 不需要换行 */
                    item.customView?.frame = CGRect(x: X,
                                                    y: preItem!.customView!.frame.minY,
                                                    width: width,
                                                    height: height)
                    if maxUpLineHeight.isLess(than: preItem!.customView!.frame.minY + height) {
                        maxUpLineHeight = preItem!.customView!.frame.minY + height
                    }
                    X += (width + interitemSpacing)
                    //
                    subItems.append(item)
                } else {  /* 需要换行 */
                    //
                    groupItems.append(subItems)
                    subItems.removeAll()
                    //
                    _rowCount += 1
                    maxUpLineHeight += lineSpacing
                    X = leftPadding
                    item.customView?.frame = CGRect(x: X,
                                                    y: maxUpLineHeight,
                                                    width: width,
                                                    height: height)
                    X += (width + interitemSpacing)
                    maxUpLineHeight += height
                    //
                    subItems.append(item)
                }
            } else {
                // 没有上一个item，也就是第一个item
                _rowCount += 1
                maxUpLineHeight = topPadding
                item.customView?.frame = CGRect(x: X,
                                                y: maxUpLineHeight,
                                                width: width,
                                                height: height)
                X += (width + interitemSpacing)
                maxUpLineHeight += height
                //
                subItems.append(item)
            }
            preItem = item
        }
        groupItems.append(subItems)
        //
        layoutAlignment(groupItems: groupItems)
        //
        rowCount = _rowCount
        //
        var y: CGFloat = .zero
        for (_, item) in subItems.enumerated() {
            y = max(y, item.customView!.frame.maxY)
        }
        containerHeight = y + bottomPadding
    }
    
    private func getItemSize(item: TagItem) -> CGSize {
        guard let customView = item.customView else { return .zero }
        let _containerWidth = containerWidth - inset.left - inset.right
        
        let _size: CGSize = customView.intrinsicContentSize
        var _width: CGFloat = item.width
        var _height: CGFloat = item.height
        
        if item.width.isAuto {
            _width = _size.width
        }
        if item.height.isAuto {
            _height = _size.height
        }
        if _width.isLessThanOrEqualTo(.zero) {
            _width = .zero
        }
        if _height.isLessThanOrEqualTo(.zero) {
            _height = .zero
        }
        if _containerWidth.isLessThanOrEqualTo(_width) {
            _width = _containerWidth
        }
        return CGSize(width: _width, height: _height)
    }
    
    private func layoutAlignment(groupItems: [[TagItem]]) {
        for (_, items) in groupItems.enumerated() {
            if verticalAlignment == .top { /* top */
                var top: CGFloat = items.first!.customView!.frame.minY
                let tops = items.map{ $0.customView!.frame.minY }
                tops.forEach { (_top) in
                    top = min(top, _top)
                }
                for (_, item) in items.enumerated() {
                    item.customView?.frame.origin = CGPoint(x: item.customView!.frame.origin.x, y: top)
                }
            } else if self.verticalAlignment == .center { /* centerY */
                var centerY: CGFloat = items.first!.customView!.center.y
                let centerYs = items.map{ $0.customView!.center.y }
                centerYs.forEach { (_centerY) in
                    centerY = max(centerY, _centerY)
                }
                for (_, item) in items.enumerated() {
                    item.customView?.center = CGPoint(x: item.customView!.center.x, y: centerY)
                }
            } else { /* bottom */
                var bottom: CGFloat = items.first!.customView!.frame.maxY
                let bottoms = items.map{ $0.customView!.frame.maxY }
                bottoms.forEach { (_bottom) in
                    bottom = max(bottom, _bottom)
                }
                for (_, item) in items.enumerated() {
                    var frame = item.customView!.frame
                    frame.origin.y = bottom - item.customView!.frame.height
                    item.customView?.frame = frame
                }
            }
        }
    }
}

extension TagView {
    public func add(items: [TagItem]) {
        for (_, item) in (items.filter{ $0.customView != nil }).enumerated() {
            addSubview(item.customView!)
            self.items.append(item)
        }
        refresh()
    }
    
    public func add(item: TagItem) {
        if item.customView == nil { return }
        addSubview(item.customView!)
        items.append(item)
        refresh()
    }
    
    public func insert(item: TagItem, at index: Int) {
        if item.customView == nil { return }
        if index > items.count - 1 {
            add(item: item)
            return
        }
        var index = index
        if index < 0 {
            index = 0
        }
        insertSubview(item.customView!, at: index)
        items.insert(item, at: index)
        refresh()
    }
    
    public func insert(items: [TagItem], at index: Int) {
        if index > self.items.count - 1 {
            add(items: items)
            return
        }
        var index = index
        if index < 0 {
            index = 0
        }
        for (_index, item) in (items.filter{ $0.customView != nil }).enumerated() {
            let i = _index + index
            self.insertSubview(item.customView!, at: i)
            self.items.insert(item, at: i)
        }
        refresh()
    }
    
    public func remove(item: TagItem) {
        for (index, _item) in (items.filter{ $0.customView != nil }).enumerated() {
            if item.identifier == _item.identifier {
                if item.identifier == _item.identifier {
                    items.remove(at: index)
                    _item.customView?.removeFromSuperview()
                    refresh()
                    break
                }
            }
        }
    }
    
    public func remove(items: [TagItem]) {
        for (_, i_item) in items.enumerated() {
            for (j, j_item) in (self.items.filter{ $0.customView != nil }).enumerated() {
                if j_item.identifier == i_item.identifier {
                    self.items.remove(at: j)
                    j_item.customView?.removeFromSuperview()
                    break
                }
            }
        }
        refresh()
    }
    
    public func removeItem(at index: Int) {
        if index < 0 {
            return
        }
        if index >= items.count {
            return
        }
        let item = items.remove(at: index)
        item.customView?.removeFromSuperview()
        refresh()
    }
    
    public func removeAllItems() {
        items.forEach { (item) in
            item.customView?.removeFromSuperview()
        }
        items.removeAll()
        refresh()
    }
    
    /// 刷新界面
    public func refresh() {
        setNeedsLayout()
        layoutIfNeeded()
    }
}
