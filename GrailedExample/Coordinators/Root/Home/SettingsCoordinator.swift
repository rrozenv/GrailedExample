//
//  SettingsCoordinator.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/24/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift

final class SettingsCoordinator: BaseCoordinator<Void> {
    
    private let rootNavigationController: UINavigationController
    
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    deinit { debugPrint("\(type(of: self)) deinit") }
    
    override func start() -> Observable<Void> {
        let vm = SettingsViewModel()
        let vc = SettingsViewController(viewModel: vm)
    
        rootNavigationController.pushViewController(vc, animated: false)
        
        return .never()
    }
    
}
