//
//  LoginViewController.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/24/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController, BindableType {
    
    // MARK: - Dependenices
    var viewModel: LoginViewModel
    
    // MARK: - Initalization
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setViewModelBinding(model: viewModel)
    }
    
    deinit { debugPrint("\(type(of: self)) deinit") }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
    // MARK: - View Properties
    private let loginButton = UIButton()
    
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
        
        /// Triggers on `loginButton` tapped
        let didTapLogin$ = loginButton.rx.tap.asObservable()
        
        /// Final Inputs
        let inputs = LoginViewModel.Input(didTapLogin$: didTapLogin$)
        
    /** MARK: - Outputs **/
        
        _ = viewModel.transform(input: inputs)
    }
    
}

extension LoginViewController {
    
    private func setupButtons() {
        let loginButtonStyle = ButtonStyle(title: "Login",
                                           enabledBackgroundColor: .blue,
                                           selectedTitleColor: .white)
        loginButton.set(loginButtonStyle)
        
        let sv = UIStackView(arrangedSubviews: [loginButton])
        sv.axis = .vertical
        
        view.addSubview(sv)
        sv.anchorCenterSuperview()
        sv.anchor(widthConstant: 300, heightConstant: 200)
    }
    
}
