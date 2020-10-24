//
//  BaseViewController.swift
//  TagView
//
//  Created by galaxy on 2020/10/24.
//

import UIKit

@objc open class BaseViewController: UIViewController {

    @objc init(title: String?) {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = title
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
}
