//
//  HomeTabBarCoordinator.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/5/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

final class HomeTabBarCoordinator: BaseCoordinator<Void> {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> Observable<Void> {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [createArticlesNavController(), createSearchNavController()]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        return Observable.never()
    }
    
    private func createArticlesNavController() -> UINavigationController {
        let articleListNav = UINavigationController()
        articleListNav.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        coordinate(to: ArticleListCoordinator(rootNavigationController: articleListNav))
            .subscribe()
            .disposed(by: disposeBag)
        return articleListNav
    }
    
    private func createSearchNavController() -> UINavigationController {
        let searchListNav = UINavigationController()
        searchListNav.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        coordinate(to: SearchListCoordinator(rootNavigationController: searchListNav))
            .subscribe()
            .disposed(by: disposeBag)
        return searchListNav
    }

}