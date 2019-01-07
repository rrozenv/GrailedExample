//
//  UINavigationController+Ext.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/17/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    
    open override var prefersStatusBarHidden: Bool {
        return topViewController?.prefersStatusBarHidden ?? false
    }
    
    func hideHairLineImage(in view: UIView) {
        
        var hairLineView: UIImageView?
        
        for view in view.subviews {
            if let imageView = view as? UIImageView,
                view.bounds.size.height <= 1.0  {
                hairLineView = imageView
                break
            }
            hideHairLineImage(in: view)
        }
    
        hairLineView?.isHidden = true
        
    }
    
}
