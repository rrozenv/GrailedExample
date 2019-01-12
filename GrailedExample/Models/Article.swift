//
//  Article.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/5/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift

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

extension Article {
    static let favorited = Notification.Name("\(String(describing: Article.self)).favorited")
    static let unfavorited = Notification.Name("\(String(describing: Article.self)).unfavorited")
}

extension Article {
    static var favorited$: Observable<Article> {
        return NotificationCenter.default.rx.notification(Article.favorited)
            .map { $0.object as? Article }
            .filterNil()
    }
    
    static var unfavorited$: Observable<Article> {
        return NotificationCenter.default.rx.notification(Article.unfavorited)
            .map { $0.object as? Article }
            .filterNil()
    }
}
