//
//  SearchListViewController.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/9/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class SearchListViewController: UIViewController, BindableType {
    
    // MARK: - Dependenices
    var viewModel: SearchListViewModel
    
    // MARK: - Initalization
    init(viewModel: SearchListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setViewModelBinding(model: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
    // MARK: - View Properties
    private let tableView = RxTableView(frame: CGRect.zero, style: .grouped)
    private let loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    // MARK: - Rx Properties
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupTableView()
    }
    
    deinit { debugPrint("\(type(of: self)) deinit") }
    
    // MARK: - View Model binding
    func bindViewModel() {
        /// Inputs
        let viewDidLoad$ = Observable.just(())

        let inputs = SearchListViewModel.Input(viewDidLoad$: viewDidLoad$)
        
        /// Outputs
        let outputs = viewModel.transform(input: inputs)
        
        outputs.savedSearchList$
            .drive(tableView.rx.items(cellIdentifier: String(describing: ImageLabelsCell.self), cellType: ImageLabelsCell.self)) { row, savedSearch, cell in
                cell.configure(with: savedSearch)
            }
            .disposed(by: disposeBag)
        
        outputs.loading$
            .drive(onNext: { [weak self] isLoading in
                guard let `self` = self else { return }
                self.animate(loadingView: self.loadingView, isLoading)
            })
            .disposed(by: disposeBag)
        
        outputs.error$
            .drive(onNext: { [weak self] in
                self?.display(error: $0)
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - View Setup
extension SearchListViewController {
    
    private func setupTableView() {
        tableView.register(ImageLabelsCell.self)
        tableView.separatorStyle = .singleLine
   
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
}

