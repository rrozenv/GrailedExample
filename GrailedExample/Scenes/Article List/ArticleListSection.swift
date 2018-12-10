//
//  ArticleListSection.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/6/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import RxDataSources

// MARK: ArticleListSection - Defines section for tableview
struct ArticleListSection {
    let title: String
    var items: [ArticleListRow]
}

extension ArticleListSection: AnimatableSectionModelType {
    typealias Item = ArticleListRow
    
    var identity: String { return title }
    
    init(original: ArticleListSection, items: [Item]) {
        self = original
        self.items = items
    }
}

// MARK: ArticleListRow - Defines individual row for tableview
enum ArticleListRow {
    case article(ArticleViewModel)
    case loading
}

extension ArticleListRow: IdentifiableType, Equatable {
    var identity: String {
        switch self {
        case .article(let vm): return vm.uuid
        case .loading: return UUID().uuidString
        }
    }
    
    static func == (lhs: ArticleListRow, rhs: ArticleListRow) -> Bool {
        return lhs.identity == rhs.identity
    }
}
