//
//  SettingsViewController.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/19/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingsViewController: UIViewController, BindableType {
    
    // MARK: - Dependenices
    var viewModel: SettingsViewModel
    
    // MARK: - Initalization
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setViewModelBinding(model: viewModel)
    }
    
    deinit { debugPrint("\(type(of: self)) deinit") }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
    // MARK: - View Properties
    private let logoutButton = UIButton()
    private let themeButton = UIButton()
    
    // MARK: - Rx Properties
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupButtons()
    }
    
    // MARK: - View Model binding
    func bindViewModel() {
    
    /** MARK: - Inputs **/
        
        /// Triggers on `logoutButton` tapped
        let didTapLogout$ = logoutButton.rx.tap.asObservable()
        
        /// Triggers on `logoutButton` tapped
        let didTapChangeTheme$ = themeButton.rx.tap.asObservable()
        
        /// Final Inputs
        let inputs = SettingsViewModel.Input(didTapLogout$: didTapLogout$,
                                             didTapChangeTheme$: didTapChangeTheme$)
        
    /** MARK: - Outputs **/
        
        _ = viewModel.transform(input: inputs)
        
    /** MARK: - Theme Updates **/
        
        NotificationCenter.default.rx.notification(.themeChanged)
            .subscribe(onNext: { [weak self] _ in
                self?.updateNavgationBarAppearance()
            })
            .disposed(by: disposeBag)
    }
    
}

extension SettingsViewController {
    
    private func setupButtons() {
        let themeButtonStyle = ButtonStyle(title: "Change Theme",
                                           enabledBackgroundColor: .blue,
                                           selectedTitleColor: .white)
        themeButton.set(themeButtonStyle)
        
        let logoutButtonStyle = ButtonStyle(title: "Logout",
                                           enabledBackgroundColor: .red,
                                           selectedTitleColor: .white)
        logoutButton.set(logoutButtonStyle)
        
        
        let sv = UIStackView(arrangedSubviews: [themeButton, logoutButton])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        
        view.addSubview(sv)
        sv.anchorCenterSuperview()
        sv.anchor(widthConstant: 300, heightConstant: 200)
    }
    
}






class TestViewController: UIViewController {
    lazy var navItem: UINavigationItem = {
        let navItem = UINavigationItem()
        navItem.largeTitleDisplayMode = .never
        navItem.title = "Detail"
        let backButtonImage = UIImage(named: "back_arrow")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(didTapBackButton))
        navItem.backBarButtonItem?.tintColor = .black
        navItem.setLeftBarButton(backButton, animated: true)
        return navItem
    }()
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let buttonStyle = ButtonStyle(title: "Change Theme", enabledBackgroundColor: .white, selectedBackgroundColor: .black, enabledTitleColor: .black, selectedTitleColor: .white, cornerRadius: 8.0)
        
        let themeButton = UIButton()
        themeButton.set(buttonStyle)
        themeButton.dropShadow()
        
        themeButton.addTarget(self, action: #selector(didTapThemeButton), for: .touchUpInside)
        view.addSubview(themeButton)
        themeButton.anchorCenterSuperview()
        themeButton.anchor(widthConstant: 200, heightConstant: 50)
    }
    
    // MARK: - Navigation Item
    override var navigationItem: UINavigationItem { return navItem }
    
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapThemeButton(_ sender: UIButton) {
        sender.bounce()
        
        switch Theme.current {
        case .theme1:
            Theme(rawValue: 1)?.apply()
        case .theme2:
            Theme(rawValue: 0)?.apply()
        }
    }
    
}
