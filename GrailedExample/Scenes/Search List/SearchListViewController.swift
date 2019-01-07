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

final class SearchListViewController: RxViewController, BindableType {

    // MARK: - Dependenices
    var viewModel: SearchListViewModel
    private let tableViewEdgeInsets: UIEdgeInsets
    
    // MARK: - Initalization
    init(viewModel: SearchListViewModel,
         tableViewEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        self.viewModel = viewModel
        self.tableViewEdgeInsets = tableViewEdgeInsets
        super.init(nibName: nil, bundle: nil)
        self.setViewModelBinding(model: viewModel)
    }
    
    deinit { debugPrint("\(type(of: self)) deinit") }
    
    required init?(coder aDecoder: NSCoder) { return nil }

    // MARK: - View Properties
    private let tableView = RxTableView(frame: .zero, style: .grouped)
    private let loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupTableView()
    }
    
    // MARK: - View Model binding
    override func bindViewModel() {
        super.bindViewModel()
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
    /** MARK: - Inputs **/
        
        /// Triggers on `viewDidLoad`
        let viewDidLoad$ = Observable.just(())
        
        /// Triggers on `didSelectCell`
        let didSelectCell$ = tableView.rx.itemSelected.asObservable()

        /// Final Inputs
        let inputs = SearchListViewModel.Input(viewDidLoad$: viewDidLoad$,
                                               didSelectCell$: didSelectCell$)
        
    /** MARK: - Outputs **/
        
        let outputs = viewModel.transform(input: inputs)
        
        /// Displays saved search table view
        outputs.savedSearchList$
            .drive(tableView.rx.items(cellIdentifier: String(describing: ImageLabelsCell.self), cellType: ImageLabelsCell.self)) { [weak self] _ , savedSearch, cell in
                self?.configure(cell: cell, for: savedSearch)
            }
            .disposed(by: disposeBag)
        
        /// Displays loading indicator
        outputs.loading$
            .drive(onNext: { [weak self] isLoading in
                guard let `self` = self else { return }
                self.animate(loadingView: self.loadingView, isLoading)
            })
            .disposed(by: disposeBag)
        
        /// Displays error
        outputs.error$
            .drive(onNext: { [weak self] in
                self?.display(error: $0)
            })
            .disposed(by: disposeBag)
    }
    
    override func didChangeTheme() {
        super.didChangeTheme()
        tableView.reloadData()
    }
    
    // MARK: Cell Configurator
    private func configure(cell: ImageLabelsCell, for savedSearch: SavedSearchViewModel) {
        cell.contentView.backgroundColor = Theme.current.primaryBackgroundColor
        cell.imageLabelsView.style.headerLabel = textAttributes(.orange)
        cell.imageLabelsView.imageView.kf.indicatorType = .activity
        cell.imageLabelsView.imageView.contentMode = .scaleAspectFill
        cell.imageLabelsView.imageView.clipsToBounds = true
        
        let config = ImageLabelsCellConfigurator<SavedSearchViewModel>(
            headerKeyPath: \.name,
            subtitleKeyPath: \.name,
            imageUrlKeyPath: \.imageUrl
        )
        
        config.configure(cell, for: savedSearch)
    }
    
}

// MARK: - Table View Delegate
extension SearchListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

}

// MARK: - View Setup
extension SearchListViewController {

    private func setupTableView() {
        tableView.register(ImageLabelsCell.self)
        tableView.separatorStyle = .singleLine
        tableView.contentInset = tableViewEdgeInsets
        
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
}


