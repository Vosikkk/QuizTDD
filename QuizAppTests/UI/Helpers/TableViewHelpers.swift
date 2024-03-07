//
//  TableViewHelpers.swift
//  QuizAppTests
//
//  Created by Саша Восколович on 25.02.2024.
//

import UIKit

extension UITableViewCell {
    var textFromContext: String? {
        (self.contentConfiguration as? UIListContentConfiguration)?.text
    }
}

extension UITableView {
    
    func cell(at row: Int) -> UITableViewCell? {
    dataSource?.tableView(self, cellForRowAt: IndexPath(row: row, section: 0))
    }
    
    func title(at row: Int) -> String? {
        if #available(iOS 14, *) {
            cell(at: row)?.textFromContext
        } else {
            cell(at: row)?.textLabel?.text
        }
    }
    
    func select(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        selectRow(at: indexPath, animated: false, scrollPosition: .none)
        delegate?.tableView?(self, didSelectRowAt: indexPath)
    }
    
    func deselect(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        deselectRow(at: indexPath, animated: false)
        delegate?.tableView?(self, didDeselectRowAt: indexPath)
    }
}
