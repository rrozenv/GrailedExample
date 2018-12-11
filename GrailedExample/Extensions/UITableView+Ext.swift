//
//  UITableView+Ext.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/10/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

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

class RxTableView: UITableView {
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        rx.itemSelected.asObservable()
            .subscribe(onNext: { [weak self] in
                 self?.deselectRow(at: $0, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
