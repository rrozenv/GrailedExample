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
    
    deinit { debugPrint("\(type(of: self)) deinit") }
    
    override func start() -> Observable<Void> {
        let vm = ArticleListViewModel()
        let vc = ArticleListViewController(viewModel: vm)

        vm.displaySelectedArticle$
            .subscribe(onNext: { [weak self] _ in
                self?.navigateToArticleDetail()
            })
            .disposed(by: disposeBag)

        rootNavigationController.pushViewController(vc, animated: false)
        
        return .never()
    }
    
    private func navigateToArticleDetail() {
        let vc = TestViewController()
        rootNavigationController.pushViewController(vc, animated: true)
    }

}
