//
//  BindableType.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/5/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import UIKit

public protocol BindableType: class {
    associatedtype ViewModel
    var viewModel: ViewModel { get set }
    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    public func setViewModelBinding(model: Self.ViewModel) {
        loadViewIfNeeded()
        bindViewModel()
    }
}
