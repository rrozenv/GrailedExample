//
//  LoadingIndicatable.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/9/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import UIKit

public protocol LoadingIndicatable {
    var view: UIView { get }
    var loadingIndicator: UIActivityIndicatorView { get }
}

public extension LoadingIndicatable where Self: UIView {
    var view: UIView { return self }
}
