//
//  TableViewDemoController.swift
//  Example
//
//  Created by William.Weng on 2023/9/11.
//

import UIKit

final class TableViewDemoController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
    
    deinit {
        MyTableViewCell.myTableView = nil
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TableViewDemoController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { return 3 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 5 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return cellMaker(tableView, cellForRowAt: indexPath)! }
}

// MARK: - 小工具
private extension TableViewDemoController {
    
    /// 初始化設定
    func initSetting() {
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        MyTableViewCell.myTableView = myTableView
        MyTableViewCell.expandedCell(section: 0, row: 0)
    }
    
    /// Cell產生器
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: IndexPath
    /// - Returns: MyTableViewCell
    func cellMaker(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> MyTableViewCell? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as? MyTableViewCell
        cell?.configure(with: indexPath)
        
        return cell
    }
}
