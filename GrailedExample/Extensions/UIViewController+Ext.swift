//
//  UIViewController+Ext.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/9/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import UIKit

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
    
}


