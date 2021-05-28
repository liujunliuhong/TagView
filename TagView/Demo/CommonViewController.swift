//
//  CommonViewController.swift
//  TagView
//
//  Created by galaxy on 2020/10/24.
//

import UIKit
import SnapKit

class CommonViewController: BaseViewController {

    private lazy var tagView: TagView = {
        let tagView = TagView()
        tagView.backgroundColor = .orange
        tagView.lineSpacing = 15.0
        tagView.interitemSpacing = 30.0
        tagView.inset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tagView.verticalAlignment = .top
        return tagView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topHeight: CGFloat = UIApplication.shared.statusBarFrame.height + 80.0
        let left: CGFloat = 25.0
        
        self.view.addSubview(self.tagView)
        self.tagView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(left)
            make.top.equalToSuperview().offset(topHeight)
            make.right.equalToSuperview().offset(-left)
        }
        
        let itemWidth: CGFloat = 80
        let itemHeight: CGFloat = 35
        
        var items: [TagItem] = []
        for i in 0..<20 {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .white
            label.backgroundColor = .red
            label.text = "\(i)"
            
            let item = TagItem(customView: label, width: itemWidth, height: itemHeight)
            items.append(item)
        }
        self.tagView.add(items: items)
    }
}


