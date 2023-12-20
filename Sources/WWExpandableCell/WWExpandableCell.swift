//
//  WWCellExpandable.swift
//  WWCellExpandable
//
//  Created by William.Weng on 2023/12/18.
//

import UIKit

open class WWExpandView: UIView {}

// MARK: - 可以折疊使用Cell的Protocol
public protocol WWCellExpandable: AnyObject {
    
    static var identifier: String { get }
    static var expandRowsList: [Int: Set<IndexPath>] { get set }
    
    var indexPath: IndexPath { get set }
    
    static func exchangeExpandState(_ tableView: UITableView, indexPath: IndexPath, isSingle: Bool, duration: TimeInterval, delay: TimeInterval, options: UIView.AnimationOptions)
    static func expandedCells(section: Int, rowCount: Int)
    static func expandedCell(section: Int, row: Int)

    func configure(with indexPath: IndexPath)
    func expandView() -> WWExpandView?
}

// MARK: - CellReusable
public extension WWCellExpandable {
    
    static var identifier: String { return String(describing: Self.self) }      // 設定identifier跟class同名
    var indexPath: IndexPath { return [] }                                      // 記錄indexPath數值
}

// MARK: - CellExpandable
public extension WWCellExpandable {
    
    /// 設定預設值 => 那個section的cell們預設是打開的
    /// - Parameters:
    ///   - section: Int
    ///   - rowCount: Int
    static func expandedCells(section: Int, rowCount: Int) {
        
        if ((Self.expandRowsList[section]) == nil) { Self.expandRowsList[section] = [] }
        
        for row in 0..<rowCount {
            let indexPath = IndexPath(row: row, section: section)
            Self.expandRowsList[section]?.insert(indexPath)
        }
    }
    
    /// 設定預設值 => 那一個IndexPath是打開的
    /// - Parameters:
    ///   - section: Int
    ///   - row: Int
    static func expandedCell(section: Int, row: Int) {
        if ((Self.expandRowsList[section]) == nil) { Self.expandRowsList[section] = [] }
        let indexPath = IndexPath(row: row, section: section)
        Self.expandRowsList[section]?.insert(indexPath)
    }
    
    /// 交換展開狀態
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: IndexPath
    ///   - isSingle: 是否只有單一開合？
    ///   - duration: 動畫時間
    ///   - delay: 動畫延遲時間
    ///   - options: 動畫效果
    static func exchangeExpandState(_ tableView: UITableView, indexPath: IndexPath, isSingle: Bool, duration: TimeInterval = 0.3, delay: TimeInterval = 0, options: UIView.AnimationOptions = []) {
        
        let visibleCells = tableView.visibleCells.compactMap { cell -> WWCellExpandable? in
            guard let cell = cell as? WWCellExpandable else { return nil }
            return cell
        }
        
        let selectedCell = visibleCells.first { $0.indexPath == indexPath }
                
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: delay, options: options , animations: {
            let isExpanded = Self.expandedRowAction(selectedCell: selectedCell)
            if (isSingle) { Self.singleExpandedRowAction(visibleCells: visibleCells, selectedIndex: indexPath, isExpanded: isExpanded) }
        }, completion: { _ in
            
        })
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

// MARK: - 小工具
private extension WWCellExpandable {
    
    /// 取得該展開Cell的IndexPath
    /// - Parameter selectedCell: WWCellExpandable?
    /// - Returns: Bool
    static func expandedRowAction(selectedCell: WWCellExpandable?) -> Bool {
        
        var isExpanded = false
        
        guard let selectedCell = selectedCell,
              let indexPath = Optional.some(selectedCell.indexPath),
              let key = Optional.some(indexPath.section)
        else {
            return isExpanded
        }
        
        if ((Self.expandRowsList[key]) == nil) { Self.expandRowsList[key] = [] }
        
        if var sets = Self.expandRowsList[key] {
            
            if !sets.contains(indexPath) {
                sets.insert(indexPath)
                selectedCell.expandView()?.isHidden = false
                isExpanded = true
            } else {
                sets.remove(indexPath)
                selectedCell.expandView()?.isHidden = true
                isExpanded = false
            }
            
            Self.expandRowsList[key] = sets
        }
        
        return isExpanded
    }
    
    /// 單一展開的處理
    /// - Parameters:
    ///   - visibleCells: [WWCellExpandable]
    ///   - selectedIndex: IndexPath
    ///   - isExpanded: Bool
    static func singleExpandedRowAction(visibleCells: [WWCellExpandable], selectedIndex: IndexPath, isExpanded: Bool) {
        
        let key = selectedIndex.section
        Self.expandRowsList[key] = []

        if isExpanded { Self.expandRowsList[key] = [selectedIndex] }
        
        visibleCells.forEach { cell in
            
            guard cell.indexPath.section == selectedIndex.section,
                  cell.indexPath != selectedIndex,
                  let isHidden = cell.expandView()?.isHidden,
                  !isHidden
            else {
                return
            }
            
            cell.expandView()?.isHidden = true
        }
    }
}


