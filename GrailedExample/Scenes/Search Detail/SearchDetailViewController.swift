//
//  SearchDetailViewController.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/17/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class SearchDetailViewController: UIViewController, BindableType {
    
    // MARK: - Dependenices
    var viewModel: SavedSearchDetailViewModel
    private let tableViewEdgeInsets: UIEdgeInsets
    lazy var navItem: UINavigationItem = {
        let navItem = UINavigationItem()
        navItem.largeTitleDisplayMode = .never
        navItem.title = "Detail"
        let backButtonImage = UIImage(named: "back_arrow")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: nil, action: nil)
        backButton.tintColor = .black
        navItem.setLeftBarButton(backButton, animated: true)
        return navItem
    }()
    
    // MARK: - Initalization
    init(viewModel: SavedSearchDetailViewModel,
         tableViewEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        self.viewModel = viewModel
        self.tableViewEdgeInsets = tableViewEdgeInsets
        super.init(nibName: nil, bundle: nil)
        self.setViewModelBinding(model: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
    // MARK: - View Properties
    private let imageView = UIImageView()
    private let tableView = RxTableView(frame: .zero, style: .plain)
    private let loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    // MARK: - Rx Properties
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupTableView()
        setupImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.clear()
    }
    
    deinit { debugPrint("\(type(of: self)) deinit") }
    
    // MARK: - Navigation Item
    override var navigationItem: UINavigationItem { return navItem }
    
    // MARK: - Status Bar Style
    //override var prefersStatusBarHidden: Bool { return true }
    
    // MARK: - View Model binding
    func bindViewModel() {
        let outputs = viewModel.transform(input: SavedSearchDetailViewModel.Input())
        
        outputs.savedSearch$
            .drive(onNext: { [weak self] in
                self?.imageView.kf.indicatorType = .activity
                self?.imageView.kf.setImage(with: $0.imageUrl)
            })
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem?.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Cell Configurator
    private func configure(cell: ImageLabelsCell, for savedSearch: SavedSearchViewModel) {
        cell.imageLabelsView.style.headerLabel = textAttributes(.black, UIFont.systemFont(ofSize: 15), .left)
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
extension SearchDetailViewController: UITableViewDelegate {
    
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = -scrollView.contentOffset.y
        let height = min(max(y, 60), 400)
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
    }
    
}

// MARK: - View Setup
extension SearchDetailViewController {
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.register(ImageLabelsCell.self)
        tableView.separatorStyle = .singleLine
        tableView.contentInset = tableViewEdgeInsets
        
        view.addSubview(tableView)
        tableView.anchor(view.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor)
    }
    
    private func setupImageView() {
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300)
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
    }
    
}
