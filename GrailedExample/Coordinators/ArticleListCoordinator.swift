//
//  ArticleListCoordinator.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/5/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import UIKit
import RxSwift

final class ArticleListCoordinator: BaseCoordinator<Void> {
    
    private let rootNavigationController: UINavigationController
    
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    override func start() -> Observable<Void> {
        let vc = ArticleListViewController(viewModel: ArticleListViewModel())
        rootNavigationController.pushViewController(vc, animated: false)
        return Observable.never()
    }

}
