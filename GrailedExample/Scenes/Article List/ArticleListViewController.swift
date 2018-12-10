//
//  ArticleListViewController.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/4/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class ArticleListViewController: UIViewController, BindableType {
    
    // MARK: - Dependenices
    var viewModel: ArticleListViewModel
    
    // MARK: - Initalization
    init(viewModel: ArticleListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setViewModelBinding(model: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
    // MARK: - View Properties
    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    // MARK: - Rx Properties
    private let disposeBag = DisposeBag()
    
    // MARK: - Data Source
    private lazy var dataSource = RxTableViewSectionedAnimatedDataSource<ArticleListSection>(
        decideViewTransition: { _, _, _ in .reload },
        configureCell: { (dataSource, table, idxPath, viewModel) in
            switch dataSource[idxPath] {
            case .article(let article):
                return table.dequeueReusableCell(of: ImageLabelsCell.self, for: idxPath) { cell in
                    cell.configure(with: article)
                }
            case .loading:
                return table.dequeueReusableCell(of: LoadingCell.self, for: idxPath) { cell in
                    cell.loadingView.startAnimating()
                }
            }
        })

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
        
        let willDisplayCell$ = tableView.rx
            .willDisplayCell.asObservable()
            .map { $0.indexPath }
        
        let didSelectCell$ = tableView.rx
            .itemSelected.asObservable()
            .do(onNext: { [weak self] in
                self?.tableView.deselectRow(at: $0, animated: true)
            })
        
        let inputs = ArticleListViewModel.Input(viewDidLoad$: viewDidLoad$,
                                                willDisplayCell$: willDisplayCell$,
                                                didSelectCell$: didSelectCell$)
        
        /// Outputs
        let outputs = viewModel.transform(input: inputs)
        
        outputs.articleListSections$
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        outputs.error$
            .drive(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.display(error: $0)
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - View Setup
extension ArticleListViewController {
    
    private func setupTableView() {
        tableView.separatorStyle = .singleLine
        tableView.register(ImageLabelsCell.self)
        tableView.register(LoadingCell.self)
        
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
}

