//
//  MetaData.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/9/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation

// MARK: - Pagination
struct Pagination: Codable {
    let current_page: String
    let next_page: String?
    let previous_page: String?
}

// MARK: - MetaData
struct MetaData: Codable {
    let pagination: Pagination
}
