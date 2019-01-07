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

final class ArticleListViewController: RxViewController, BindableType {
    
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
    private let tableView = RxTableView(frame: CGRect.zero, style: .grouped)
    
    // MARK: - Data Source
    private lazy var dataSource = RxTableViewSectionedAnimatedDataSource<ArticleListSection>(
        decideViewTransition: { _, _, _ in .reload },
        configureCell: { [weak self] (dataSource, table, idxPath, viewModel) in
            switch dataSource[idxPath] {
            case .article(let article):
                return table.dequeueReusableCell(of: ImageLabelsCell.self, for: idxPath) { cell in
                   self?.configure(cell: cell, for: article)
                }
            case .loading:
                return table.dequeueReusableCell(of: LoadingCell.self, for: idxPath) { cell in
                    cell.configure()
                }
            }
        })
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = LocalizeableString.articles.localized
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    deinit { debugPrint("\(type(of: self)) deinit") }
    
    // MARK: - View Model binding
    override func bindViewModel() {
        super.bindViewModel()
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
    /** MARK: - Inputs **/
        
        /// Triggers on `viewDidLoad`
        let viewDidLoad$ = Observable.just(())
        
        /// Triggers on `willDisplayCell`
        let willDisplayCell$ = tableView.rx
            .willDisplayCell.asObservable()
            .map { $0.indexPath }
        
        /// Triggers on `didSelectCell`
        let didSelectCell$ = tableView.rx.itemSelected.asObservable()
        
        /// Final Inputs
        let inputs = ArticleListViewModel.Input(viewDidLoad$: viewDidLoad$,
                                                willDisplayCell$: willDisplayCell$,
                                                didSelectCell$: didSelectCell$)
        
    /** MARK: - Outputs **/
        
        let outputs = viewModel.transform(input: inputs)
        
        /// Displays article sections in tableview
        outputs.articleListSections$
            .drive(tableView.rx.items(dataSource: dataSource))
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
    
    private func configure(cell: ImageLabelsCell, for article: ArticleViewModel) {
        cell.contentView.backgroundColor = Theme.current.primaryBackgroundColor
        cell.imageLabelsView.style = ImageLabelsView.Style.defaultStyle
        
        let configurator = ImageLabelsCellConfigurator<ArticleViewModel>(
            headerKeyPath: \.title,
            subtitleKeyPath: \.author,
            imageUrlKeyPath: nil
        )
        
        configurator.configure(cell, for: article)
    }
    
}

// MARK: - Table View Delegate
extension ArticleListViewController: UITableViewDelegate {
    
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
extension ArticleListViewController {
    
    private func setupTableView() {
        tableView.register(ImageLabelsCell.self)
        tableView.register(LoadingCell.self)
        tableView.separatorStyle = .singleLine

        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
}

