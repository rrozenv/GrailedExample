//
//  UIViewController+Ext.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/9/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxViewController: UIViewController {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    let isFirstLoad = BehaviorRelay(value: true)
    let isBeingDisplayed = BehaviorRelay(value: false)
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isFirstLoad.accept(false)
        isBeingDisplayed.accept(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isBeingDisplayed.accept(false)
    }
    
    // MARK: View Model Binding
    /// Should override
    func bindViewModel() {
        /** MARK: - Theme Updates **/
        NotificationCenter.default.rx.notification(.themeChanged)
            .subscribe(onNext: { [weak self] _ in
                self?.didChangeTheme()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Theme Update
    /// Should override
    func didChangeTheme() {
        updateNavgationBarAppearance()
    }
    
}

extension UIViewController {
    
    func animate(loadingView: LoadingIndicatable, _ isLoading: Bool, withDelay: Double? = nil) {
        func loadingViewAction() {
            switch isLoading {
            case true:
                view.addSubview(loadingView.view)
                loadingView.view.anchorCenterSuperview()
                loadingView.loadingIndicator.startAnimating()
            case false:
                loadingView.view.removeFromSuperview()
                loadingView.loadingIndicator.stopAnimating()
            }
        }
        
        guard let delay = withDelay, !isLoading else {
            loadingViewAction()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            loadingViewAction()
        }
    }
    
    func display(error: Error) {
        guard viewIfLoaded?.window != nil else { return }
        let alertVc = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alertVc.addAction(UIAlertAction.init(title: "Ok", style: .cancel))
        
        if let error = error as? ErrorRepresentable {
            guard error.shouldDisplay else { return }
            alertVc.title = error.header
            alertVc.message = error.message
        } else {
            alertVc.title = "Error"
            alertVc.message = error.localizedDescription
        }
        
        DispatchQueue.main.async {
            self.present(alertVc, animated: true, completion: nil)
        }
    }
    
    func updateNavgationBarAppearance() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.isNavigationBarHidden = false
    }
    
}

extension UINavigationBar {
    
    func clear() {
        shadowImage = UIImage()
        setBackgroundImage(UIImage(), for: .default)
        backgroundColor = .clear
        barTintColor = .clear
        isTranslucent = true
        UIApplication.shared.statusBarView?.backgroundColor = .clear
    }
    
    func reset(to color: UIColor) {
        shadowImage = UIImage()
        setBackgroundImage(UIImage(), for: .default)
        backgroundColor = color
        barTintColor = color
        isTranslucent = false
        UIApplication.shared.statusBarView?.backgroundColor = color
    }
    
}

extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
}


