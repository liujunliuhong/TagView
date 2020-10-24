//
//  SpecialViewController.swift
//  TagView
//
//  Created by galaxy on 2020/10/24.
//

import UIKit
import SnapKit

public class SpecialViewController: BaseViewController {

    private lazy var toolView: ToolView = {
        let toolView = ToolView()
        return toolView
    }()
    
    private lazy var tagView: GLTagView = {
        let tagView = GLTagView()
        tagView.backgroundColor = .orange
        tagView.lineSpacing = 15.0
        tagView.interitemSpacing = 30.0
        tagView.preferdWidth = 250.0
        tagView.inset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        tagView.verticalAlignment = .top
        return tagView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let topHeight: CGFloat = UIApplication.shared.statusBarFrame.height + 80.0
        let left: CGFloat = 25.0
        
        self.view.addSubview(self.toolView)
        self.toolView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(topHeight)
            make.height.equalTo(120)
        }
        
        self.view.addSubview(self.tagView)
        self.tagView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(left)
            make.top.equalTo(self.toolView.snp.bottom).offset(20)
        }
        
        var items: [GLTagItem] = []
        
        let widths: [CGFloat] = [25, 30, 40, 50, 60, 70]
        let heights: [CGFloat] = [30, 40, 50, 60]
        
        for i in 0..<10 {
            let view = _View()
            if i == 5 {
                view.backgroundColor = .red
            } else {
                view.backgroundColor = .gray
            }
            var string: String = "\(i)"
            for _ in 0..<2 {
                string += string
            }
            view.button.setTitle(string, for: .normal)
            let widthIndex = arc4random() % UInt32(widths.count)
            let heightIndex = arc4random() % UInt32(heights.count)
            let itemWidth = widths[Int(widthIndex)]
            let itemHeight = heights[Int(heightIndex)]
            let item = GLTagItem(view: view, width: itemWidth, height: itemHeight)
            items.append(item)
            
            view.tapClosure = {
                guard let v = item.view as? _View else { return }
                items.forEach { (item) in
                    if let vv = item.view as? _View {
                        vv.backgroundColor = .gray
                    }
                }
                v.backgroundColor = .red
            }
        }
        self.tagView.add(items: items)
        
        
        
        
        
        self.toolView.insertClosure = { [weak self] in
            guard let self = self else { return }
            let view = _View()
            view.button.setTitle("Insert", for: .normal)
            view.backgroundColor = .green
            let item = GLTagItem(view: view, width: 100, height: 100)
            self.tagView.insert(item: item, at: 5)
        }
        
        self.toolView.alignmentClosure = { [weak self] in
            guard let self = self else { return }
            if self.tagView.verticalAlignment == .top {
                self.tagView.verticalAlignment = .center
            } else if self.tagView.verticalAlignment == .center {
                self.tagView.verticalAlignment = .bottom
            } else if self.tagView.verticalAlignment == .bottom {
                self.tagView.verticalAlignment = .top
            }
        }
        
        self.toolView.preferdClosure = { [weak self] in
            guard let self = self else { return }
            let widths: [CGFloat] = [250.0, 300.0, 100.0, 120.0, 140.0, 160.0, 180.0, 200.0]
            let widthIndex = arc4random() % UInt32(widths.count)
            let width = widths[Int(widthIndex)]
            print("\(width)")
            self.tagView.preferdWidth = width
        }
        
        self.toolView.removeClosure = { [weak self] in
            guard let self = self else { return }
            self.tagView.removeItem(at: 5)
        }
    }
}


fileprivate class _View: UIView {
    lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        return button
    }()
    
    var tapClosure: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    func setupUI() {
        self.addSubview(self.button)
        self.button.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func tapAction(){
        self.tapClosure?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 50, height: 20)
    }
}




fileprivate class ToolView: UIView {
    lazy var insertButton: UIButton = {
        let insertButton = UIButton(type: .system)
        insertButton.setTitle("插入一个Item", for: .normal)
        insertButton.backgroundColor = .gray
        insertButton.setTitleColor(.white, for: .normal)
        insertButton.addTarget(self, action: #selector(insertAction), for: .touchUpInside)
        return insertButton
    }()
    
    lazy var alignmentButton: UIButton = {
        let alignmentButton = UIButton(type: .system)
        alignmentButton.setTitle("对齐方式", for: .normal)
        alignmentButton.backgroundColor = .gray
        alignmentButton.setTitleColor(.white, for: .normal)
        alignmentButton.addTarget(self, action: #selector(alignmentAction), for: .touchUpInside)
        return alignmentButton
    }()
    
    lazy var preferdButton: UIButton = {
        let preferdButton = UIButton(type: .system)
        preferdButton.setTitle("容器宽度", for: .normal)
        preferdButton.backgroundColor = .gray
        preferdButton.setTitleColor(.white, for: .normal)
        preferdButton.addTarget(self, action: #selector(preferdAction), for: .touchUpInside)
        return preferdButton
    }()
    
    lazy var removeButton: UIButton = {
        let removeButton = UIButton(type: .system)
        removeButton.setTitle("移除一个Item", for: .normal)
        removeButton.backgroundColor = .gray
        removeButton.setTitleColor(.white, for: .normal)
        removeButton.addTarget(self, action: #selector(removeAction), for: .touchUpInside)
        return removeButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    var insertClosure: (()->())?
    var alignmentClosure: (()->())?
    var preferdClosure: (()->())?
    var removeClosure: (()->())?
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = .cyan
        self.addSubview(self.insertButton)
        self.addSubview(self.alignmentButton)
        self.addSubview(self.preferdButton)
        self.addSubview(self.removeButton)
        
        self.insertButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        
        self.alignmentButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.insertButton)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        
        self.preferdButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(self.insertButton.snp.bottom).offset(20)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        
        self.removeButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.preferdButton)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
    }
    @objc func insertAction() {
        self.insertClosure?()
    }
    @objc func alignmentAction() {
        self.alignmentClosure?()
    }
    @objc func preferdAction() {
        self.preferdClosure?()
    }
    @objc func removeAction() {
        self.removeClosure?()
    }
}
