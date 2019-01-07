//
//  LoginCoordinator.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/24/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift

final class LoginCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    private let rootNavigationController: UINavigationController
    
    init(window: UIWindow, rootNavigationController: UINavigationController = UINavigationController()) {
        self.window = window
        self.rootNavigationController = rootNavigationController
    }
    
    deinit { debugPrint("\(type(of: self)) deinit") }
    
    @discardableResult
    override func start() -> Observable<Void> {
        let vm = LoginViewModel()
        let vc = LoginViewController(viewModel: vm)

        rootNavigationController.pushViewController(vc, animated: false)
        
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
        
        return .never()
    }
    
}
