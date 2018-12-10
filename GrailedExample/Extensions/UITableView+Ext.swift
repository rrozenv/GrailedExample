//
//  UITableView+Ext.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/10/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var identifier: String { return String(describing: self) }
}

extension UITableView {
    func dequeueReusableCell<CellClass: UITableViewCell>(of class: CellClass.Type, for indexPath: IndexPath, configure: ((CellClass) -> Void) = { _ in }) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: CellClass.identifier, for: indexPath)
        if let typedCell = cell as? CellClass {
            configure(typedCell)
        }
        return cell
    }
    
    func register(_ cell: UITableViewCell.Type) {
        register(cell, forCellReuseIdentifier: cell.identifier)
    }
}
