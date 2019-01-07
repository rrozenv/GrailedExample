//
//  UIImageView+Ext.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/23/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImage(color: UIColor?) {
        image = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        tintColor = color
    }
    
}
