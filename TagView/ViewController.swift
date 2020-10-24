//
//  ViewController.swift
//  TagView
//
//  Created by galaxy on 2020/10/24.
//

import UIKit
import SnapKit

class Model {
    let title: String?
    init(title: String?) {
        self.title = title
    }
}

class ViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: NSStringFromClass(UITableViewCell.classForCoder()))
        return tableView
    }()
    
    var dataSource: [Model] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .always
        } else {
            self.automaticallyAdjustsScrollViewInsets = true
        }
        
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let model1 = Model(title: "等宽等高")
        let model2 = Model(title: "等高不等宽")
        let model3 = Model(title: "不等宽不等高")
        let model4 = Model(title: "OC Demo")
        self.dataSource = [model1, model2, model3, model4]
        self.tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.classForCoder()))
        let model = self.dataSource[indexPath.row]
        cell?.textLabel?.text = model.title
        return cell!
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataSource[indexPath.row]
        if indexPath.row == 0 {
            let vc = CommonViewController(title: model.title)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc = Common1ViewController(title: model.title)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            let vc = SpecialViewController(title: model.title)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 3 {
            let vc = OCDemoViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
