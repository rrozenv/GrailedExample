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
        let vm = ArticleListViewModel()
        vm.didSelectArticle
            .subscribe(onNext: {
                print("did select article: \($0.title)")
            })
            .disposed(by: disposeBag)
        
        let vc = ArticleListViewController(viewModel: vm)
        rootNavigationController.pushViewController(vc, animated: false)
        return Observable.never()
    }

}
