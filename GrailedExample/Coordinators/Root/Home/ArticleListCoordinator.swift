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
    
    // MARK: - Properties
    private let rootNavigationController: UINavigationController
    
    // MARK: - Initalization
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    deinit { debugPrint("\(type(of: self)) deinit") }
    
    // MARK: - Start
    override func start() -> Observable<Void> {
        navigateToArticleList()
        return .never()
    }

}

// MARK: - Navigation
extension ArticleListCoordinator {
    
    /// Article list (ROOT)
    private func navigateToArticleList() {
        let vm = ArticleListViewModel()
        let vc = ArticleListViewController(viewModel: vm)
        
        vm.displaySelectedArticle$
            .subscribe(onNext: { [weak self] in self?.navigateToArticleDetail($0) })
            .disposed(by: disposeBag)
        
        rootNavigationController.pushViewController(vc, animated: false)
    }
    
    /// Article detail
    private func navigateToArticleDetail(_ article: ArticleViewModel) {
        let vc = TestViewController()
        rootNavigationController.pushViewController(vc, animated: true)
    }
    
}
