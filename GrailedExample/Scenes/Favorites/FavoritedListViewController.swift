//
//  FavoritedListViewController.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 1/11/19.
//  Copyright © 2019 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class FavoritesListViewController: UIViewController, BindableType {
    
    // MARK: - Dependenices
    var viewModel: FavoritesListViewModel
    
    // MARK: - Initalization
    init(viewModel: FavoritesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setViewModelBinding(model: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
    // MARK: - View Properties
    private let tableView = RxTableView(frame: CGRect.zero, style: .grouped)
    
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
    
        let inputs = FavoritesListViewModel.Input(viewDidLoad$: viewDidLoad$)
        
        /// Outputs
        let outputs = viewModel.transform(input: inputs)
        
        outputs.favoritedList$
            .drive(tableView.rx.items(cellIdentifier: String(describing: ImageLabelsCell.self), cellType: ImageLabelsCell.self)) { row, article, cell in
                cell.configure(with: article)
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - View Setup
extension FavoritesListViewController {
    
    private func setupTableView() {
        tableView.register(ImageLabelsCell.self)
        tableView.register(LoadingCell.self)
        tableView.separatorStyle = .singleLine
        
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
}
