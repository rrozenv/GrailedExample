//
//  AppCoordinator.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/5/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    private let userNetwork: UserNetwork
    private var rootCoordinator: BaseCoordinator<Void>?
    
    init(window: UIWindow, userNetwork: UserNetwork = UserNetwork.shared) {
        self.window = window
        self.userNetwork = userNetwork
    }
    
    override func start() -> Observable<Void> {

        let currentUser$ = userNetwork.fetchCurrentUser().share()

        /// 1. Triggers on user is already logged in
        /// 2. Triggers on user did login notification
        Observable.merge(
            currentUser$.filterNil(),
            User.didLogInNotification$
        )
            .subscribe(onNext: { [unowned self] _ in
                self.rootCoordinator = HomeTabBarCoordinator(window: self.window)
                self.rootCoordinator?.start()
                    .subscribe()
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)

        /// 1. Triggers on user not logged in
        /// 2. Triggers on user did logout notification
        Observable.merge(
            currentUser$.filter { $0 == nil }.mapToVoid(),
            User.didLogOutNotification$
        )
            .subscribe(onNext: { [unowned self] _ in
                self.rootCoordinator = LoginCoordinator(window: self.window)
                self.rootCoordinator?.start()
                    .subscribe()
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)

        return .never()
    }
    
}
