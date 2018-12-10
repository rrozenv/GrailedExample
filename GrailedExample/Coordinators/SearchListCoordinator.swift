//
//  SearchListCoordinator.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/5/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift

final class SearchListCoordinator: BaseCoordinator<Void> {
    
    private let rootNavigationController: UINavigationController
    
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    override func start() -> Observable<Void> {
        let viewController = SearchListViewController(viewModel: SearchListViewModel())
        rootNavigationController.pushViewController(viewController, animated: false)
        return Observable.never()
    }
    
}
