//
//  TableViewCell.swift
//  Example
//
//  Created by William.Weng on 2023/12/18.
//

import UIKit
import WWExpandableCell

final class MyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myExpandView: WWExpandView!
    @IBOutlet weak var myLabel: UILabel!
    
    static weak var myTableView: UITableView?
    static var expandRowsList: [Int: Set<IndexPath>] = [:]
    
    var indexPath: IndexPath = []
    
    private let isSingle = true
    
    /// 展開 / 折疊
    /// - Parameter sender: UIButton
    @IBAction func expandAction(_ sender: UIButton) {
        guard let myTableView = Self.myTableView else { return }
        MyTableViewCell.exchangeExpandState(myTableView, indexPath: indexPath, isSingle: isSingle)
    }
}

// MARK: - WWCellExpandable
extension MyTableViewCell: WWCellExpandable {    
    
    func configure(with indexPath: IndexPath) {
        self.indexPath = indexPath
        myExpandView.isHidden = !(Self.expandRowsList[indexPath.section]?.contains(indexPath) ?? false)
        myLabel.text = "\(indexPath)"
    }
    
    func expandView() -> WWExpandView? { return myExpandView }
}
