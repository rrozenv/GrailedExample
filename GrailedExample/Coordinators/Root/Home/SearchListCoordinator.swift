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
    private let segmentedControlViewHeight: CGFloat = 50.0
    
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    deinit { debugPrint("\(type(of: self)) deinit") }
    
    override func start() -> Observable<Void> {
        let (searchListController, segmentView, navItem) = setupSearchListViewController()
        
        let navigationProperties = NavigationProperties(navigationItem: navItem)
        
        let pageViewController = SegmentedPageViewController(segmentedControlView: segmentView,segmentedControlPosition: .top, viewControllers: [searchListController, TestViewController(), TestViewController()], navigationProperties: navigationProperties)
        
        rootNavigationController.pushViewController(pageViewController, animated: false)
        
        return .never()
    }
    
    private func navigateToSavedSearchDetail(for savedSearch: SavedSearchViewModel) {
        let vm = SavedSearchDetailViewModel(savedSearch: savedSearch)
        let detailVc = SearchDetailViewController(viewModel: vm)
        rootNavigationController.pushViewController(detailVc, animated: true)
    }
    
}

extension SearchListCoordinator {
    
    private func setupSearchListViewController() ->
        (vc: SearchListViewController,
        segmentView: SegmentedControlView,
        navItem: UINavigationItem) {
        
        let buttonStyles = ["Button 1", "Button 2", "Button 3"].map {
            ButtonStyle(title: $0,
                        enabledBackgroundColor: .white,
                        //selectedBackgroundColor: .white,
                        enabledTitleColor: .black,
                        selectedTitleColor: .red)
        }
        let underlineView = UIView()
        underlineView.backgroundColor = .red
        let segmentedControlView = SegmentedControlView(underlineView: underlineView)
        segmentedControlView.configure(with: buttonStyles)
        
        let navItem = UINavigationItem()
        navItem.title = "Search"
        
        let searchListViewModel = SearchListViewModel()
        let searchListViewController = SearchListViewController(viewModel: searchListViewModel, tableViewEdgeInsets: UIEdgeInsets(top: segmentedControlViewHeight, left: 0, bottom: 0, right: 0))
        
        searchListViewModel.displaySelectedSavedSearch$.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.navigateToSavedSearchDetail(for: $0)
            })
            .disposed(by: disposeBag)
        
        return (searchListViewController, segmentedControlView, navItem)
    }
    
}




