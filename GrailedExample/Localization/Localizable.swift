//
//  Localizable.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 1/7/19.
//  Copyright © 2019 Cluk Labs. All rights reserved.
//

import Foundation

protocol Localizable {
    var tableName: String { get }
    var localized: String { get }
}

extension Localizable where Self: RawRepresentable, Self.RawValue == String {
    var localized: String {
        return rawValue.localized(tableName: tableName)
    }
}

enum LocalizeableString: String, Localizable {
    case articles
    
    var tableName: String {
        return "Localizable"
    }
}

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: self, comment: "")
    }
}


