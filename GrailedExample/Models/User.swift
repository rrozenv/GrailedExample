//
//  User.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/24/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - SavedSearchResult
struct User: Codable {
    let name: String
}

extension User {
    static let loggedIn = Notification.Name("\(String(describing: User.self)).loggedIn")
    static let loggedOut = Notification.Name("\(String(describing: User.self)).loggedOut")
}

extension User {
    static var didLogInNotification$: Observable<User> {
        return NotificationCenter.default.rx.notification(User.loggedIn)
            .map { $0.object as? User }
            .filterNil()
    }
    
    static var didLogOutNotification$: Observable<Void> {
        return NotificationCenter.default.rx.notification(User.loggedOut).mapToVoid()
    }
}
