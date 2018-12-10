//
//  Article.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/5/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation

// MARK: - ArticlesResult
struct ArticlesResult: Codable {
    let data: [Article]
    let metadata: MetaData
}

// MARK: - Article
struct Article: Codable, Equatable {
    let id: Int
    let url: String
    let title: String
    let author: String
}
