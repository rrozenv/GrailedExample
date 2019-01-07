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
    
    deinit { debugPrint("\(type(of: self)) deinit") }

    override func start() -> Observable<Void> {
        
        let buttonStyles = ["Articles", "Search", "Settings"].map { _ in
            ButtonStyle(enabledBackgroundColor: .white,
                        enabledTitleColor: .gray,
                        selectedTitleColor: .blue,
                        image: UIImage(named: "dashboard"))
        }
        
        let segmentedControlView = SegmentedControlView()
        segmentedControlView.configure(with: buttonStyles)

        let pageViewController = SegmentedPageViewController(segmentedControlView: segmentedControlView, segmentedControlPosition: .bottom, viewControllers: [createSearchNavController(), createArticlesNavController(), createSettingsNavController()], isAnimatedTransition: false)
  
        window.rootViewController = pageViewController
        window.makeKeyAndVisible()
        
        return .never()
    }
    
    private func createArticlesNavController() -> UINavigationController {
        let articleListNav = UINavigationController()
        coordinate(to: ArticleListCoordinator(rootNavigationController: articleListNav))
        return articleListNav
    }
    
    private func createSearchNavController() -> UINavigationController {
        let searchListNav = UINavigationController()
        coordinate(to: SearchListCoordinator(rootNavigationController: searchListNav))
        return searchListNav
    }
    
    private func createSettingsNavController() -> UINavigationController {
        let settingsNav = UINavigationController()
        coordinate(to: SettingsCoordinator(rootNavigationController: settingsNav))
        return settingsNav
    }

}
