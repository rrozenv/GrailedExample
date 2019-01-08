//
//  SavedSearch.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/9/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift

protocol Modalable {
    associatedtype T
    static var created$: Observable<T> { get }
    static var updated$: Observable<T> { get }
    static var deleted$: Observable<T> { get }
}

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

extension SavedSearch {
    static let created = Notification.Name("\(String(describing: SavedSearch.self)).created")
    static let updated = Notification.Name("\(String(describing: SavedSearch.self)).updated")
    static let deleted = Notification.Name("\(String(describing: SavedSearch.self)).deleted")
}

extension SavedSearch: Modalable {
    static var created$: Observable<SavedSearch> {
        return NotificationCenter.default.rx.notification(SavedSearch.created)
        .map { $0.object as? SavedSearch }
        .filterNil()
    }
    
    static var updated$: Observable<SavedSearch> {
        return NotificationCenter.default.rx.notification(SavedSearch.updated)
            .map { $0.object as? SavedSearch }
            .filterNil()
    }
    
    static var deleted$: Observable<SavedSearch> {
        return NotificationCenter.default.rx.notification(SavedSearch.deleted)
            .map { $0.object as? SavedSearch }
            .filterNil()
    }
}
