//
//  SavedSearch.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/9/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation

// MARK: - SavedSearchResult
struct SavedSearchResult: Codable {
    let data: [SavedSearch]
}

// MARK: - SavedSearch
struct SavedSearch: Codable, Equatable {
    let id: Int
    let name: String
    let image_url: String
}
