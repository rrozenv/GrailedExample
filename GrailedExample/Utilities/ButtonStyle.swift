//
//  ButtonStyle.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/16/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit

class ButtonStyle {
    let title: String?
    let titleEdgeInsets: UIEdgeInsets?
    let enabledBackgroundColor: UIColor?
    let selectedBackgroundColor: UIColor?
    let disabledBackgroundColor: UIColor?
    let enabledTitleColor: UIColor?
    let selectedTitleColor: UIColor?
    let disabledTitleColor: UIColor?
    let image: UIImage?
    let font: UIFont?
    let contentEdgeInsets: UIEdgeInsets
    let cornerRadius: CGFloat
    
    init(title: String? = nil,
         titleEdgeInsets: UIEdgeInsets? = nil,
         enabledBackgroundColor: UIColor? = nil,
         selectedBackgroundColor: UIColor? = nil,
         disabledBackgroundColor: UIColor? = nil,
         enabledTitleColor: UIColor? = nil,
         selectedTitleColor: UIColor? = nil,
         disabledTitleColor: UIColor? = nil,
         image: UIImage? = nil,
         font: UIFont? = nil,
         contentEdgeInsets: UIEdgeInsets = .zero,
         cornerRadius: CGFloat = 0.0) {
        self.title = title
        self.titleEdgeInsets = titleEdgeInsets
        self.enabledBackgroundColor = enabledBackgroundColor
        self.selectedBackgroundColor = selectedBackgroundColor
        self.disabledBackgroundColor = disabledBackgroundColor
        self.enabledTitleColor = enabledTitleColor
        self.selectedTitleColor = selectedTitleColor
        self.disabledTitleColor = disabledTitleColor
        self.image = image
        self.font = font
        self.contentEdgeInsets = contentEdgeInsets
        self.cornerRadius = cornerRadius
    }
}

extension UIButton {
    func set(_ style: ButtonStyle) {
        if let enabledBackgroundColor = style.enabledBackgroundColor {
            setBackgroundColor(enabledBackgroundColor, for: .normal)
        }
        
        if let image = style.image {
            adjustsImageWhenHighlighted = false
            setImage(image, for: .normal)
            setImage(image, for: .selected)
            setImage(image, for: .disabled)
            return
        }
        
        if let selectedBackgroundColor = style.selectedBackgroundColor {
            setBackgroundColor(selectedBackgroundColor, for: .selected)
        }
        
        if let disabledBackgroundColor = style.disabledBackgroundColor {
            setBackgroundColor(disabledBackgroundColor, for: .disabled)
        }
        
        if let title = style.title {
           setTitle(title, for: .normal)
           setTitle(title, for: .selected)
           setTitle(title, for: .disabled)
        }
        
        if let font = style.font {
            titleLabel?.font = font
        }
        
        if let edgeInsets = style.titleEdgeInsets {
            titleEdgeInsets = edgeInsets
        }
        
        if let enabledTitleColor = style.enabledTitleColor {
            setTitleColor(enabledTitleColor, for: .normal)
        }
        
        if let selectedTitleColor = style.selectedTitleColor {
            setTitleColor(selectedTitleColor, for: .selected)
        }
        
        if let disabledTitleColor = style.disabledTitleColor {
            setTitleColor(disabledTitleColor, for: .disabled)
        }
        
        if style.selectedBackgroundColor == nil && style.selectedTitleColor == nil {
             adjustsImageWhenHighlighted = false
        }
    }
}

extension UIButton {
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        //clipsToBounds = true
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setBackgroundImage(colorImage, for: state)
    }
    
}


